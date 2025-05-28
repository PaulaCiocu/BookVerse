import 'dart:async';

import 'package:bookverse/events/AppEvents.dart';
import 'package:bookverse/controller/userProfileController.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile_tabs/edit_profile.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile_tabs/notifications.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile_tabs/reading_list.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile_tabs/achievments.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile_tabs/trails.dart';
import 'package:bookverse/widgets/user_option_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final String userId;
  const UserProfile({super.key, required this.userId});

  @override
  _UserProfileState createState() => _UserProfileState();

  static updateProfile(String? selectedAvatar, String email, String name, String bio) {}
}

class _UserProfileState extends State<UserProfile> {
  Future<Map<String, dynamic>>? _userProfile;
  late StreamSubscription _profileUpdateSubscription;
   int _unreadCount =0 ;

  void _loadUserProfile() {
    setState(() {
      _userProfile = UserProfileController.fetchUserProfileById(widget.userId);
    });
  }

  Future<int> _getUnseenCount() async {
    final url = Uri.parse('http://10.0.2.2:8080/notifications/unseen-count/${widget.userId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
        setState(() {
        _unreadCount = int.parse(response.body);
        print("Unseen notifications");
        print(_unreadCount);
      });
      return int.parse(response.body); 
    } else {
      throw Exception('Failed to fetch unseen notification count');
    }
  }


  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _getUnseenCount();
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
                        clipBehavior: Clip.none, 
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              'assets/brown background.png',
                              height: 120,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),

                          Positioned(
                            top: 25,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Notifications(userId: widget.userId),
                                  ),
                                );
                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  const Icon(Icons.notifications, size: 35, color: Colors.white),
                                  if (_unreadCount > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade400,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '$_unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: 70, 
                            left: MediaQuery.of(context).size.width / 2 - 50, 
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: user['profilePictureUrl'] != null
                                ? CachedNetworkImageProvider(user['profilePictureUrl']!)
                                : const AssetImage('assets/avatars/avatar_woman.png') as ImageProvider,

                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 70), 
                    Text(
                      user['fullName'] ?? 'Unknown User', 
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical:10.0),
                      child: Center( 
                        child: Text(
                          user['bio'] != null && user['bio']!.isNotEmpty 
                              ? '"${user['bio']}"'
                              : '"No bio available"',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ],
                  ),
                  const SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildOptionCard(
                              context: context,
                              iconPath: 'assets/icons/page_icons.png',
                              label: 'Reading',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReadingListsceen(userId: widget.userId),
                                  ),
                                );
                              },
                            ),
                            buildOptionCard(
                              context: context,
                              iconPath: 'assets/badges/medal_icon.png',
                              label: 'Achievements',
                              onTap: () {
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AchievmentsScreen(userId: widget.userId, onClose: () {  },),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildOptionCard(
                              context: context,
                              iconPath: 'assets/icons/books_shelve_icon.png',
                              label: 'Trails',
                              onTap: () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TrailsScreen(userId: widget.userId, onClose: () {  },),
                                  ),
                                );
                              },
                            ),
                            buildOptionCard(
                              context: context,
                              iconPath: 'assets/icons/settings.png',
                              label: 'Profile Settings',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfileScreen(
                                      userId: widget.userId,
                                      email: '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
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