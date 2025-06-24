import 'package:bookverse/tabScreens/home_screens/search_screen/book_details_screen.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/explore_trails.dart';
import 'package:bookverse/tabScreens/home_screens/search_screen/search_books.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/trail_details.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile_tabs/trails.dart';
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
  String? selectedBookKey; 
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
              ExploreTrails(
                onTrailsSelected: (String trailKey) { 
                  setState(() {
                    selectedTrailKey = trailKey;
                  });
                },
                userId: widget.userId,
              ),
              SearchBooks(
                onBookSelected: (bookKey) {
                  setState(() {
                    selectedBookKey = bookKey;
                  });
                }, userId: widget.userId,
              ),
              UserProfile(
                userId: widget.userId,
              ),
           
            ],
          ),

          // Show the overlay screens only when the respective id is not null
          if (selectedTrailKey != null)
            Positioned.fill(
              child: TrailDetails(
                trailId: selectedTrailKey!,
                onClose: () {
                  setState(() {
                    selectedTrailKey = null;
                  });
                },
                userId: widget.userId,
              ),
            ),
          if (selectedBookKey != null)
            Positioned.fill(
              child: BookDetailScreen(
                bookKey: selectedBookKey!,
                onClose: () {
                  setState(() {
                    selectedBookKey = null;
                  });
                },
                userId: widget.userId,
              ),
            ),
      
          if (trailsUserId != null)
            Positioned.fill(
              child: TrailsScreen(
                userId: trailsUserId!,
                onClose: () {
                  setState(() {
                    trailsUserId = null;
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
              selectedTrailKey = null;
            }
            if (selectedBookKey != null) {
              selectedBookKey = null; 
            }
            if (trailsUserId != null) {
              trailsUserId = null; 
            } else {
              screenIndex = index; 
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false, 
        showUnselectedLabels: false, 
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined, size: 35), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 35), label: "Profile"),
     
         ],
       ),
    );
  }

  
}
