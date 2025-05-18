import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/create_trail/update_trail.dart';
import 'package:bookverse/widgets/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CreatedTrailsScreen extends StatefulWidget {
  final String userId;
  const CreatedTrailsScreen({super.key, required this.userId});

  @override
  State<CreatedTrailsScreen> createState() => _CreatedTrailsScreenState();
}

class _CreatedTrailsScreenState extends State<CreatedTrailsScreen> {
  List<dynamic> trails = [];
  bool isLoading = true;

  Future<void> _loadTrails() async {
    final trailList = await TrailController.fetchTrailsCreated(widget.userId);
    setState(() {
      trails = trailList;
      isLoading = false;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _loadTrails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Created trails",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20, 
          color: Colors.black87, 
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA), 
      elevation: 0,
    ),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Column(
            children: [
              const SizedBox(height: 60),  
              const Text(
                "Trails List",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 60),  
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      trails.isEmpty
                          ? const Center(child: Text("No trails available."))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: trails.length,
                              itemBuilder: (context, index) {
                                final trail = trails[index];
                                
                                return Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left:16.0, right: 16.0),
                                  elevation: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                             title: Row(
                                                children: [
                                                  // Title expands and takes the available space
                                                  Expanded(
                                                    child: Text(
                                                      trail['trail']['title'] ?? 'No Title',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black87,
                                                      ),
                                                      overflow: TextOverflow.ellipsis, // optional: avoid overflow if title is long
                                                    ),
                                                  ),
                                                  
                                                  // Icons stay at the end
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          Navigator.push(
                                                            context, 
                                                            MaterialPageRoute(
                                                              builder: (context) => UpdatetrailScreen(trail: trail, userId: widget.userId)
                                                            ),
                                                          );
                                                          _loadTrails();
                                                        },
                                                      
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          size: 20,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () async {
                                                          bool? unfollowConfirmed = await showRemoveCreatedTrailDialog(context);
                                                          
                                                          if (unfollowConfirmed == true) {
                                                            bool? keepBooksConfirmed = await showKeepBooksDialog(context);
                                                            TrailController.deleteCreatedTrail(
                                                              widget.userId,
                                                              trail['trail']['id'].toString(),
                                                              keepBooksConfirmed!,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                            
                                             leading: trail['trail']['imageUrl'] != null
                                              ? ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: trail['trail']['imageUrl'],
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : const Icon(Icons.book, size: 50),
                  
                                            ),
                                          ),
                                        ],
                                      ),
                                          
                                      ],
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
              const SizedBox(height: 60),
              
            ],
          ),
        ),
      ),
    );
  }
}