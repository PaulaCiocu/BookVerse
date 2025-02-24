import 'package:flutter/material.dart';

class Readingscreen extends StatefulWidget {
  final String user_email;
  final VoidCallback onClose;
  const Readingscreen({super.key, required this.user_email, required this.onClose});

  @override
  State<Readingscreen> createState() => _ReadingscreenState();
}

class _ReadingscreenState extends State<Readingscreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "This is the Reading Screen", // Display user email
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
