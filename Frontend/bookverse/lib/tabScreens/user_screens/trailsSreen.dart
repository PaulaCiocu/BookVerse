import 'package:flutter/material.dart';

class TrailsScreen extends StatefulWidget {
  final String user_email;
  final VoidCallback onClose;
  const TrailsScreen({super.key, required this.user_email, required this.onClose});

  @override
  _TrailsScreenState createState() => _TrailsScreenState();
}

class _TrailsScreenState extends State<TrailsScreen> {

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: Text(
          "Reading trails screen ",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        )
      ),
    );
  
  }
}