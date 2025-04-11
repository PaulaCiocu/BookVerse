import 'package:bookverse/auth_screens/login.dart';
import 'package:bookverse/tabScreens/home_screens/settings/created_trails.dart';
import 'package:bookverse/tabScreens/home_screens/settings/edit_profile.dart';
import 'package:bookverse/tabScreens/home_screens/settings/followed_trails.dart';
import 'package:bookverse/tabScreens/home_screens/settings/reading_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final String userEmail;
  final String userId;

  const SettingsScreen({super.key, required this.userEmail, required this.userId});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<String?> getStoredJwtToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

  Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');  
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Edit Profile'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen( userId: widget.userId, email: widget.userEmail,)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.follow_the_signs),
                      title: const Text('Followed Trails'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FollowedTrailsscreen(userId: widget.userId,)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.map),
                      title: const Text('Created Trails'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreatedTrailsScreen(userId: widget.userId,)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.library_books),
                      title: const Text('Reading List'),
                       onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingListsceen(userId: widget.userId,)));
                      },
                    ),
                    
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notifications'),
                      onTap: () {
                        // Add your notifications settings logic here
                      },
                    ),
                    // Log out section
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Log Out'),
                      onTap: () async {
                        // Show confirmation dialog
                        bool? logoutConfirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Column(
                                children: [
                                  Text(
                                    'Confirm Logout', 
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Text(
                                    'Are you sure you want to log out?', 
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16
                                    ),
                                  ),
                                   SizedBox(height: 10,),
                                ],
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false); // User cancels logout
                                      },
                                      child: const Text('CANCEL', style: TextStyle(color: Colors.grey, fontSize: 14),),
                                    ),
                                    const SizedBox(width: 20,),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true); // User confirms logout
                                      },
                                      child: const Text('OK', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );

                        if (logoutConfirmed == true) {
                          await logout(); // Proceed with logout if confirmed
                        }
                      },
                    
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
