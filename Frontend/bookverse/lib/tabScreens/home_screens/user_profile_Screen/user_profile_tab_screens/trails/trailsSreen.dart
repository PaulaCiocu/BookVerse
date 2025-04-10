import 'dart:convert';
import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/trailProgreesScreen.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/create_trail/createTrailStepOne.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrailsScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onClose;



  const TrailsScreen({super.key, required this.userId, required this.onClose,});

  @override
  _TrailsScreenState createState() => _TrailsScreenState();
}

class _TrailsScreenState extends State<TrailsScreen> {
  List<dynamic> _trails =[];
  bool isLoading = true;

  Future<void> _loadTrails() async {
    final trailsList = await TrailController.fetchTrails(widget.userId);
    setState(() {
      _trails = trailsList;
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
      body: SafeArea(
        child: SingleChildScrollView(  // Make everything scrollable
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/trail_background.png',
                  height: 120,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              const SizedBox(height: 40),
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
                      _trails.isEmpty
                          ? const Center(child: Text("No trails available."))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _trails.length,
                              itemBuilder: (context, index) {
                                final trail = _trails[index];
                  
                                if (trail['trail']['deleted'] == true) {
                                  return Card(
                                    color: Colors.grey.shade300,
                                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                                    elevation: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         ListTile(
                                            title: Text(
                                              trail['trail']['title'] ?? 'No Title',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  trail['trail']['description'] ?? 'No description available',
                                                  style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 5,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                               ],
                                            ),
                                            leading: ClipOval(
                                              child: trail['trail']['imageUrl'] != null
                                                  ? Image.network(
                                                      trail['trail']['imageUrl'],
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/user_profile_backgrounds_screen.png',
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                       
                                        const Center(
                                          child: Text(
                                            "This trail was deleted by the owner.",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8,)
                                      ],
                                    ),
                                  );
                                }
                  
                                final pagesRead = trail['pagesRead'] ?? 0;
                                final totalBooksPages = trail['trail']['totalPages'] ?? 1;
                                final progress = (pagesRead / totalBooksPages).clamp(0.0, 1.0);
                                final progressPercentage = (progress * 100).toStringAsFixed(0);
                                final trailBooks = trail['trail']['trailBooks'] as List<dynamic>;
                  
                                return Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                                  elevation: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                trail['trail']['title'] ?? 'No Title',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    trail['trail']['description'] ?? 'No description available',
                                                    style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 5,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => Trailprogreesscreen(
                                                            trail: trail['trail'],
                                                            createdType: trail['createdType'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'View trail ..',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              leading: ClipOval(
                                                child: trail['trail']['imageUrl'] != null
                                                    ? Image.network(
                                                        trail['trail']['imageUrl'],
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/user_profile_backgrounds_screen.png',
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  value: progress,
                                                  backgroundColor: Colors.grey[300],
                                                  color: const Color.fromARGB(255, 251, 207, 146),
                                                  strokeWidth: 4,
                                                ),
                                                Text(
                                                  '$progressPercentage%',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
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
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateTrailStepOne(userId: widget.userId,)));
                },
                child: Container(
                  width: 120,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFFDCAA),
                  ),
                  child: const Center(
                    child: Text(
                      'Create trail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
