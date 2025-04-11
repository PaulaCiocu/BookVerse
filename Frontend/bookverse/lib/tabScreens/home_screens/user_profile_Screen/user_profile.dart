import 'dart:async';

import 'package:bookverse/controller/AppEvents.dart';
import 'package:bookverse/controller/userProfileController.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  final Function(String userId) onReadSelected;
  final Function(String userId) onAchievementsSelected;
  final Function(String userId) onTrailsSelected;

  const UserProfile({super.key,  required this.onReadSelected, required this.onAchievementsSelected, required this.onTrailsSelected, required this.userId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<Map<String, dynamic>>? _userProfile;
  late StreamSubscription _profileUpdateSubscription;

  
  void _loadUserProfile() {
    setState(() {
      _userProfile = UserProfilecontroller.fetchUserProfileById(widget.userId);
    });
  }


  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    _profileUpdateSubscription = AppEvents.profileUpdated.stream.listen((_) {
      _loadUserProfile(); 
    });
  }


  @override
  void dispose() {
    _profileUpdateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userProfile,
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

                      const SizedBox(height: 120), 
    
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
                              const Text("Achievements", style: TextStyle(fontSize: 16, color: Colors.black87)),
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


