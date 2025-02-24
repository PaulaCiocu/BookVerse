import 'dart:convert';
import 'package:bookverse/tabScreens/user_screens/achievmentsScreen.dart';
import 'package:bookverse/tabScreens/user_screens/readingScreen.dart';
import 'package:bookverse/tabScreens/user_screens/trailsSreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final String userEmail; // User ID to fetch profile details
  const UserProfile({required this.userEmail});

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

   void _navigateToScreen(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = const Readingscreen(); // Create an instance of the Reading screen
        break;
      case 1:
        screen = const AchievmentsScreen(); // Create an instance of the Achievements screen
        break;
      case 2:
        screen = const TrailsSreen(); // Create an instance of the Trails screen
        break;
      default:
        return; // Do nothing if index is out of range
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen), // Navigate to the selected screen
    );
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
                  
                      SizedBox(
                        width: double.infinity, // Take full width
                        child: Image.asset(
                          'assets/book_background.png', // Add your image in assets folder
                          height: 180,
                          fit: BoxFit.cover, // Ensure it covers the width nicely
                          alignment: Alignment.topCenter, // Focus on the top part
                        ),
                      ),
                  
                      const SizedBox(height: 60),
                      Text(user['fullName'] ?? 'Unknown User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                     Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center( // Center the text
                        child: Text(
                          user['bio'] != null && user['bio']!.isNotEmpty 
                              ? '"${user['bio']}"' // Add double quotes around the bio
                              : '"No bio available"', // Default message with quotes
                          style: const TextStyle(
                            fontSize: 14, 
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center, // Center text alignment
                        ),
                      ),
                    ),

                      const SizedBox(height: 30),
                      Text(
                        user['nr_of_connections']?.toString() ?? '0', // Convert to string or show '0' if null
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      const Text('Connections', style: TextStyle(fontSize: 14)),
                    ],
                  ),

                  const SizedBox(height: 100,),
                  // Bottom Navigation Bar for Tabs
                  // Bottom Navigation Bar for Tabs
                  BottomNavigationBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index; // Update the selected index
                        
                      });
                      _navigateToScreen(index);
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu_book_rounded, size: 25),
                        label: "Reading",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.star, size: 25),
                        label: "Achievements",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.terrain, size: 25),
                        label: "Trails",
                      ),
                    ],
                    selectedItemColor: Colors.black54, // Set the selected item color to black
                    unselectedItemColor: Colors.black38, // Set unselected item color to a lighter shade
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, // Make the selected label bold
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



