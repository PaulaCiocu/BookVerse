import 'dart:convert';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/achievmentsScreen.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/readingScreen.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/trailsSreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final String userEmail; // User ID to fetch profile details
  final Function(String userEmail) onReadSelected;
  final Function(String userEmail) onAchievementsSelected;
  final Function(String userEmail) onTrailsSelected;

  const UserProfile({super.key, required this.userEmail, required this.onReadSelected, required this.onAchievementsSelected, required this.onTrailsSelected});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<Map<String, dynamic>>? _userProfileFuture; // Change to nullable
  int _selectedIndex = 0; // Track the selected index for BottomNavigationBar

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/person/${widget.userEmail}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _fetchUserProfile(); // Fetch user profile on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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

                  const SizedBox(height: 100,),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                           widget.onReadSelected(user['id']);
                          },
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/icons/page_icons.png', width: 35, height: 35),
                              SizedBox(height: 4),
                              Text("Reading", style: TextStyle(fontSize: 16, color: Colors.black87)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onAchievementsSelected(user['id']);
                          },
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/badges/medal_icon.png', width: 35, height: 35),
                              SizedBox(height: 4),
                              Text("Achievements", style: TextStyle(fontSize: 16, color: Colors.black87)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                           widget.onTrailsSelected(user['id']);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/icons/books_shelve_icon.png', width: 35, height: 35),
                              const SizedBox(height: 4),
                              const Text("Trails", style: TextStyle(fontSize: 16, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


