import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SeeanotherusersprofileScreen extends StatefulWidget {
  final String userId;
  const SeeanotherusersprofileScreen({super.key, required this.userId});

  @override
  State<SeeanotherusersprofileScreen> createState() => _SeeanotherusersprofileScreenState();
}

class _SeeanotherusersprofileScreenState extends State<SeeanotherusersprofileScreen> {
  Future<Map<String, dynamic>>? _userProfile; // Change to nullable
  List<dynamic> trails = [];
  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/person/personId/${widget.userId}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> fetchTrails() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-trails/person/${widget.userId}'));
      if (response.statusCode == 200) {
        setState(() {
          trails = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load trails');
      }
    } catch (error) {
      print('Error fetching trails: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _userProfile = _fetchUserProfile(); // Fetch user profile on initialization
    fetchTrails();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Edit profile",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20, // Slightly larger text for readability
            color: Colors.black87, // Text color
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final user = snapshot.data!;
                return Column(
                  children: [
                    // User Profile Info
                    Column(
                      children: [
                       Stack(
                          clipBehavior: Clip.none,  // Allow the avatar to overlap the background without clipping it
                          children: [
                            // Background image
                            SizedBox(
                              width: double.infinity,
                              child: Image.asset(
                                'assets/brown background.png',
                                height: 120,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            // Profile picture (Avatar)
                            Positioned(
                              top: 70, // Adjust this value to position the avatar on top of the background
                              left: MediaQuery.of(context).size.width / 2 - 50, // Center the avatar horizontally
                              child: CircleAvatar(
                                radius: 50, // Set the size of the avatar
                                backgroundImage: user['profilePictureUrl'] != null 
                                    ? NetworkImage(user['profilePictureUrl']) // Use the user's image if available
                                    : const AssetImage('assets/avatars/avatar_woman.png') as ImageProvider, // Default image if null
                              ),
                            ),
                          ],
                        ),
          
                        const SizedBox(height: 120), // Space between avatar and name
              
                        Text(user['fullName'] ?? 'Unknown User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87)),
                        const SizedBox(height: 30),
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical:20.0),
                        child: Center( 
                          child: Text(
                            user['bio'] != null && user['bio']!.isNotEmpty 
                                ? '"${user['bio']}"'
                                : '"No bio available"',
                            style: const TextStyle(
                              fontSize: 16, 
                              fontStyle: FontStyle.italic,
                              color: Colors.black54
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ],
                    ),
          
                    const SizedBox(height: 50,),
                    trails.isEmpty
                    ? const Center(child: Text("No trails available."))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: trails.length,
                        itemBuilder: (context, index) {
                          final trail = trails[index];
                    
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
                                  
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                         
                   
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