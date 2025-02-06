import 'package:bookverse/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disable the debug banner
      title: 'BookVerse',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white, // Set background to white
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title Text
            const SizedBox( height: 50,),

            const Text(
              'BookVerse',
              style: TextStyle(
                fontSize: 38, 
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600, 
                color: Color(0xFF030303), 
                letterSpacing: 1.2, 
              ),
            ),
            const SizedBox(height: 50),

            // Image (Placeholder)
            Image.asset(
              'assets/welcome_image.jpeg', // Add your image in assets folder
              height: 220,
              width: 220,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 100),

            // Message
            const Text(
              'Discover new reading paths',
              style: TextStyle(
                fontSize: 18, 
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600, 
                color: Color(0xFF030303), 
                letterSpacing: 0.8, 
              ),
            ),
            // Message
            const Text(
              'BookVerse',
              style: TextStyle(
                fontSize: 18, 
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600, 
                color: Color(0xFF030303), 
                letterSpacing: 1.2, 
              ),
            ),

            const SizedBox(height: 50),

            GestureDetector(
              onTap: () {
                // Navigate to the next page (e.g., login or main screen)
                Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginPage())
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
               width: 158, 
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDCAA), // Background color: #ffdcaa
                  borderRadius: BorderRadius.circular(8), // border-radius: 8px
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // box-shadow
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.my_library_books, // Book icon
                      size: 21,
                      color: Color(0xFF000000), // Icon color: #000000
                    ),
                    SizedBox(width: 7), // gap between icon and text
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto', // font-family: "Roboto"
                        color: Color(0xFF000000), // Text color: #000000
                        height: 24 / 14, // line-height: 24px
                      ),
                    ),
                  ],
                ),
              ),
            )

          
          ],
        ),
      ),
    );
  }
}
