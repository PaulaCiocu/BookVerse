import 'package:bookverse/tabScreens/auth_screens/login.dart';
import 'package:bookverse/home.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase initializes properly
//   await FirebaseAppCheck.instance.activate(
//   androidProvider: AndroidAppCheckProvider.debug,
//   webProvider:    WebAppCheckProvider.debug,
// );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookVerse',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const WelcomePage(), // Show WelcomePage when app starts
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            // Check if the user is already logged in
            final isLoggedIn = await _checkLoginStatus();
            if (isLoggedIn) {
               
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('jwt_token') ?? '';
              final email = prefs.getString('user_email') ?? '';
              final userId = prefs.getString('user_id') ?? '';
              
            
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home(token: token, userEmail: email, userId: userId,)));
            } else {
              // If not logged in, navigate to LoginPage
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BookVerse',
                style: Theme.of(context).textTheme.displayMedium
              ),
              
              const SizedBox(height: 50),
              Image.asset(
                'assets/welcome_image.jpeg',
                height: 240,
                width: 240,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                'Discover new reading paths',
                style: Theme.of(context).textTheme.titleSmall
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDCAA),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.my_library_books,
                      size: 21,
                      color: Color(0xFF000000),
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Get Started',
                      style: Theme.of(context).textTheme.titleSmall
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

  // Function to check if the user is logged in
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token'); // Get the token from SharedPreferences
    return token != null; // If a token exists, the user is logged in
  }
}

