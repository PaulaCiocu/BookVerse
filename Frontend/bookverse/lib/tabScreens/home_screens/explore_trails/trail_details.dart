import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/see_another_user_profile_screen.dart';
import 'package:flutter/material.dart';


class TrailDetails extends StatefulWidget {
  final String trailId;
  final String userId;
  final VoidCallback onClose;

  const TrailDetails({super.key, required this.trailId, required this.onClose, required this.userId});

  @override
  State<TrailDetails> createState() => _TrailDetailsState();
}

class _TrailDetailsState extends State<TrailDetails> {
  Future<Map<String, dynamic>>? _trailFuture;
  bool _isAddedToList = false; 

  Future<void> addToReadingList() async {
    final isAdded = await TrailController.addToReadingList(widget.userId, widget.trailId);
    setState(() {
      _isAddedToList = isAdded;
    });
  }

  Future<void> _checkIfTrailInReadingList() async {
    final isAdded = await TrailController.checkIfTrailInReadingList(widget.userId, widget.trailId);
    setState(() {
      _isAddedToList = isAdded;
    });
  }

  void _loadTrailDetails() {
    _trailFuture = TrailController.fetchTrailDetails(widget.trailId);
  }

  @override
  void initState() {
    super.initState();
    _loadTrailDetails();
    _checkIfTrailInReadingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _trailFuture, // Call the function in the body
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Show loader
              } else if (snapshot.hasError) {
                return const Center(child: Text("Failed to load trail details")); // Error message
              } else {
                final trail = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity, // Take full width
                      child: trail['imageUrl'] != null
                          ? Image.network(
                              trail['imageUrl']!,
                              height: 180,
                              fit: BoxFit.cover, // Ensure it covers the width nicely
                              alignment: Alignment.topCenter, // Focus on the top part
                            )
                          : Image.asset(
                              'assets/user_profile_backgrounds_screen.png', // Use Image.asset for local assets
                              height: 180,
                              fit: BoxFit.cover, // Ensure it covers the width nicely
                              alignment: Alignment.topCenter, // Focus on the top part
                            ),
                    ),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            trail['title'] ?? 'No Title',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Readings: ${trail?['numberOfReadings'] ?? 0}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left:24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Creator: ${trail['personName'] ?? 'Unknown'}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.info_outline, size: 16),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SeeAnotherUserProfileScreen(userId: trail['creatorId'],)));
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            trail['description'] ?? 'No Description',
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Genre:', style: TextStyle(fontSize: 12,)),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  trail['genre'] != null
                                      ? trail['genre'].join(", ")
                                      : 'No genre info available',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Display Books in the Trail
                          const Text(
                            "Books",
                            style: TextStyle(fontSize: 16,),
                          ),
                          const SizedBox(height: 8),
                              
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            color: Colors.white,
                            child: Column(
                              children: (trail['trailBookList'] as List<dynamic>? ?? []).map((bookEntry) {
                                var book = bookEntry['book'];
                                return ListTile(
                                  leading: ClipOval(
                                    child: Image.network(
                                      book['coverImageUrl'] ?? 'assets/default_image.png', // Fallback to a default image if null
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    book['title'] ?? 'No Title',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${book['author'] ?? 'Unknown'}", 
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic
                                        ),),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox( height: 20,),
                          //add to reading button
                          ElevatedButton.icon(
                            onPressed: _isAddedToList ? null : addToReadingList,
                            label: Text(_isAddedToList ? "Added to Trails List" : "Add to Trails"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isAddedToList ? Colors.green : const Color(0xFFFFDCAA), 
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
