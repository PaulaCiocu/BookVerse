import 'package:bookverse/tabScreens/bookDetailsScreen.dart';
import 'package:bookverse/tabScreens/exploreTrails.dart';
import 'package:bookverse/tabScreens/notifications.dart';
import 'package:bookverse/tabScreens/searchBooks.dart';
import 'package:bookverse/tabScreens/userProfile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String token; 

  const Home({super.key, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenIndex = 0;
  String? selectedBookKey; // Store the selected book key
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
            UserProfile(userEmail: 'fuknolegnu@gufum.com'),
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
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      onTap: (index) {
      setState(() {
        if (selectedBookKey != null) {
          selectedBookKey = null; // Close book details if it's open
        } else {
          screenIndex = index; // Otherwise, switch screens
        }
      });
    },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      currentIndex: screenIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.search_outlined, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.notifications, size: 30), label: ""),
      ],
    ),
  );
}

}
