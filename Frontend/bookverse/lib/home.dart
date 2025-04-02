import 'package:bookverse/tabScreens/home_screens/search_screen/bookDetailsScreen.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/exploreTrails.dart';
import 'package:bookverse/tabScreens/home_screens/notifications.dart';
import 'package:bookverse/tabScreens/home_screens/search_screen/searchBooks.dart';
import 'package:bookverse/tabScreens/home_screens/settings/settingsScreen.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/userProfile.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/achievmentsScreen.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/readingScreen.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/trailDetails.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/trailsSreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String token;
  final String userEmail;
  final String userId;

  const Home({super.key, required this.token, required this.userEmail, required this.userId});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenIndex = 0;
  String? selectedBookKey; // Store the selected book key
  String? selectedTrailKey;
  String? selectedTabScreenProfile;
  String? readUserId;
  String? achievementsUserId;
  String? trailsUserId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: screenIndex,
            children: [
              ExploreTrails(onTrailsSelected: (String trailKey) { 
                setState(() {
                  selectedTrailKey = trailKey; // Store the selected book key
                });
               }, userId: widget.userId,),
              SearchBooks(onBookSelected: (bookKey) {
                setState(() {
                  selectedBookKey = bookKey; // Store the selected book key
                });
              }),
              UserProfile(userEmail: widget.userEmail, onReadSelected: (id) { 
                  setState(() {
                    readUserId = id; // Store the selected book key
                  });
                }, onAchievementsSelected: (id) { 
                  setState(() {
                    achievementsUserId = id; // Store the selected book key
                  });
              }, onTrailsSelected: (String id) { 
                  setState(() {
                    trailsUserId = id; // Store the selected book key
                  });
               },),
              SettingsScreen(userEmail: widget.userEmail, userId: widget.userId,),
            ],
          ),

          if (selectedTrailKey != null)
            Positioned.fill(
              child: TrailDetails(
                trailId: selectedTrailKey!,
                onClose: () {
                  setState(() {
                    selectedTrailKey = null; 
                  });
                }, userId: widget.userId, 
              ),
            ),
          // Show BookDetailScreen on top if selectedBookKey is set
          if (selectedBookKey != null)
            Positioned.fill(
              child: BookDetailScreen(
                bookKey: selectedBookKey!,
                onClose: () {
                  setState(() {
                    selectedBookKey = null; // Close book details
                  });
                }, userId: widget.userId,
              ),
            ),
          if (readUserId != null)
            Positioned.fill(
              child: Readingscreen(
                user_id: readUserId!,
                onClose: () {
                  setState(() {
                    readUserId = null; // Close book details
                  });
                },
              ),
            ),

            if (achievementsUserId != null)
            Positioned.fill(
              child: AchievmentsScreen(
                user_id: achievementsUserId!,
                onClose: () {
                  setState(() {
                    achievementsUserId = null; // Close book details
                  });
                },
              ),
            ),

            if (trailsUserId != null)
            Positioned.fill(
              child: TrailsScreen(
                userId: trailsUserId!,
                onClose: () {
                  setState(() {
                    trailsUserId = null; // Close book details
                  });
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            if (selectedTrailKey != null) {
              selectedTrailKey = null; // Close book details if it's open
            }
            if (selectedBookKey != null) {
              selectedBookKey = null; // Close book details if it's open
            }
            if (readUserId != null) {
              readUserId = null; 
            } 
            if (achievementsUserId != null) {
              achievementsUserId = null; 
            } 
            if (trailsUserId != null) {
              trailsUserId = null; 
            } 
            else {
              screenIndex = index; // Switch screens
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined, size: 30), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings, size: 30), label: "Settings"),
        ],
      ),
    );
  }

  // Function to navigate to ReadingScreen
  
}
