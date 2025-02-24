import 'package:bookverse/tabScreens/bookDetailsScreen.dart';
import 'package:bookverse/tabScreens/exploreTrails.dart';
import 'package:bookverse/tabScreens/notifications.dart';
import 'package:bookverse/tabScreens/searchBooks.dart';
import 'package:bookverse/tabScreens/userProfile.dart';
import 'package:bookverse/tabScreens/user_screens/achievmentsScreen.dart';
import 'package:bookverse/tabScreens/user_screens/readingScreen.dart';
import 'package:bookverse/tabScreens/user_screens/trailsSreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String token;
  final String userEmail;

  const Home({super.key, required this.token, required this.userEmail});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenIndex = 0;
  String? selectedBookKey; // Store the selected book key
  String? selectedTabScreenProfile;
  String? readUserEmail;
  String? achievementsUserEmail;
  String? trailsUserEmail;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: screenIndex,
            children: [
              ExploreTrails(),
              SearchBooks(onBookSelected: (bookKey) {
                setState(() {
                  selectedBookKey = bookKey; // Store the selected book key
                });
              }),
              UserProfile(userEmail: widget.userEmail, onReadSelected: (userEmail) { 
                  setState(() {
                    readUserEmail = userEmail; // Store the selected book key
                  });
                }, onAchievementsSelected: (userEmail) { 
                  setState(() {
                    achievementsUserEmail = userEmail; // Store the selected book key
                  });
              }, onTrailsSelected: (String userEmail) { 
                  setState(() {
                    trailsUserEmail = userEmail; // Store the selected book key
                  });
               },),
              Notifications(),
            ],
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
                },
              ),
            ),
          if (readUserEmail != null)
            Positioned.fill(
              child: Readingscreen(
                user_email: readUserEmail!,
                onClose: () {
                  setState(() {
                    readUserEmail = null; // Close book details
                  });
                },
              ),
            ),

            if (achievementsUserEmail != null)
            Positioned.fill(
              child: AchievmentsScreen(
                user_email: achievementsUserEmail!,
                onClose: () {
                  setState(() {
                    achievementsUserEmail = null; // Close book details
                  });
                },
              ),
            ),

            if (trailsUserEmail != null)
            Positioned.fill(
              child: TrailsScreen(
                user_email: trailsUserEmail!,
                onClose: () {
                  setState(() {
                    trailsUserEmail = null; // Close book details
                  });
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            if (selectedBookKey != null) {
              selectedBookKey = null; // Close book details if it's open
            }
            if (readUserEmail != null) {
              readUserEmail = null; 
            } 
            if (achievementsUserEmail != null) {
              achievementsUserEmail = null; 
            } 
            if (trailsUserEmail != null) {
              trailsUserEmail = null; 
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications, size: 30), label: "Notifications"),
        ],
      ),
    );
  }

  // Function to navigate to ReadingScreen
  
}
