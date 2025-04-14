import 'package:bookverse/auth_screens/login.dart';
import 'package:bookverse/tabScreens/home_screens/settings/created_trails.dart';
import 'package:bookverse/tabScreens/home_screens/settings/edit_profile.dart';
import 'package:bookverse/tabScreens/home_screens/settings/followed_trails.dart';
import 'package:bookverse/tabScreens/home_screens/settings/notifications.dart';
import 'package:bookverse/tabScreens/home_screens/settings/reading_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final String userEmail;
  final String userId;
  final VoidCallback onNotificationsUpdated;


  const SettingsScreen({super.key, required this.userEmail, required this.userId, required this.onNotificationsUpdated, });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  int _unreadCount =0;

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
  Future<int> getUnseenCount() async {
    final url = Uri.parse('http://10.0.2.2:8080/notifications/unseen-count/${widget.userId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
        setState(() {
        _unreadCount = int.parse(response.body);;
      });
      return int.parse(response.body); 
    } else {
      throw Exception('Failed to fetch unseen notification count');
    }
  }

  @override
  void initState() {
    super.initState();
    getUnseenCount();
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
                      title: Row(
                        children: [
                          const Text('Notifications'),
                          const SizedBox(width: 8),
                          if (_unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$_unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Notifications(userId: widget.userId,),
                        )).then((_) {
                          // Refresh the unread notification count when coming back
                          getUnseenCount();
                          widget.onNotificationsUpdated();
                        });

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
