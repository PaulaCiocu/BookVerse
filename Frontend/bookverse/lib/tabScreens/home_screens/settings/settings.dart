import 'package:bookverse/auth_screens/login.dart';
import 'package:bookverse/tabScreens/home_screens/settings/created_trails.dart';
import 'package:bookverse/tabScreens/home_screens/settings/edit_profile.dart';
import 'package:bookverse/tabScreens/home_screens/settings/followed_trails.dart';
import 'package:bookverse/tabScreens/home_screens/settings/notifications.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/reading_list.dart';
import 'package:bookverse/widgets/dialogs.dart';
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
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge
        ),
     
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                   
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Edit Profile', ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen( userId: widget.userId, email: widget.userEmail,)));
                      },
                    ),
                   

                    // // Log out section
                    // ListTile(
                    //   leading: const Icon(Icons.exit_to_app),
                    //   title: const Text('Log Out'),
                    //   onTap: () async {
                    //     // Show confirmation dialog
                    //     bool? logoutConfirmed = await showLogoutConfirmationDialog(context);
                    //     if (logoutConfirmed == true) {
                    //       await logout(); // Proceed with logout if confirmed
                    //     }
                    //   },
                    
                    // ),

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
