import 'package:bookverse/tabScreens/home_screens/explore_trails/seeAnotherUsersProfileScreen.dart';
import 'package:bookverse/tabScreens/home_screens/search_screen/bookDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _trailFuture = fetchTrailDetails(); // Fetch trail details initially
    _checkIfBookInReadingList();
  }

  Future<void> _checkIfBookInReadingList() async {
  print("is added to list $_isAddedToList");
  final url = 'http://10.0.2.2:8080/reading-trails/exists/${widget.userId}/${widget.trailId}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    setState(() {
      _isAddedToList = response.body.toLowerCase() == 'true';
    });
  } else {
    print('Failed to check reading list status: ${response.statusCode}');
  }
}
 Future<void> addToReadingList() async {
    final url = 'http://10.0.2.2:8080/reading-trails/add/${widget.userId}/${widget.trailId}/FOLLOWED';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      setState(() {
        _isAddedToList = true; // Update state when added
      });
    } else {
      print('Failed to add book: ${response.statusCode} - ${response.body}');
    }
  }
  Future<Map<String, dynamic>> fetchTrailDetails() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/trails/${widget.trailId}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load trail details');
    }
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
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SeeanotherusersprofileScreen(userId: trail['creatorId'],)));
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
                              const Text('Genre:', style: TextStyle(fontSize: 14, color: Colors.black54)),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  trail['genre'] != null
                                      ? trail['genre'].join(", ")
                                      : 'No genre info available',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.black54
                                  ),
                                ),
                              ),
                            ],
                          ),
          
          
                          const SizedBox(height: 20),
                          // Number of Readings
                          
                              
                          // Display Books in the Trail
                          const Text(
                            "Books",
                            style: TextStyle(fontSize: 16,),
                          ),
                          const SizedBox(height: 8),
                              
                          Column(
                            children: (trail['trailBookList'] as List<dynamic>? ?? []).map((bookEntry) {
                              var book = bookEntry['book'];
                              return GestureDetector(
                                onTap: () {
                                  // // Navigate to BookDetails screen when the book is tappeda
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => BookDetailScreen(bookKey: book['key'], userId: widget.userId, onClose: () {  }, ),
                                  //   ),
                                  // );
                                  
          
                                },
                                child: Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: ClipOval(
                                      child: Image.network(
                                        book['coverImageUrl'] ?? 'assets/default_image.png', // Fallback to a default image if null
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      book['title'] ?? 'No Title',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${book['author'] ?? 'Unknown'}"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox( height: 20,),
                            // ADd to reading Button
                          ElevatedButton.icon(
                            onPressed: _isAddedToList ? null : addToReadingList, // Disable button if already added
                            label: Text(_isAddedToList ? "Added to Trails List" : "Add to Trails"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isAddedToList ? Colors.green : const Color(0xFFFFDCAA), // Orange when false
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
