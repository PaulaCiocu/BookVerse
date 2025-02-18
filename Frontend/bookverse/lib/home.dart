import 'package:bookverse/tabScreens/exploreTrails.dart';
import 'package:bookverse/tabScreens/notifications.dart';
import 'package:bookverse/tabScreens/searchBooks.dart';
import 'package:bookverse/tabScreens/userProfile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String token; // Receive the token as a constructor parameter

  // Constructor for passing the token
  const Home({super.key, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int screenIndex = 0;
  List tabScreensList = [
    ExploreTrails(),
    SearchBooks(),
    UserProfile(),
    Notifications()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar( 
        onTap: (indexNumber){
            setState(() {
              screenIndex = indexNumber; 
            });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor:   Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: screenIndex,
        items: const [

          //swapping screen
          BottomNavigationBarItem( 
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: ""
          ),
          // search  button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.search_outlined,
              size: 30,
              
            ), 
            label: ""
          ),  
        // user detail screen button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ), 
            label: ""
          ),  
          // user detail screen button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.notification_add,
              size: 30,
            ), 
            label: ""
          ),  
        ],
      ),
      body: tabScreensList[screenIndex],
    );
  }
}
