import 'package:flutter/material.dart';

class AchievmentsScreen extends StatefulWidget {
  final String user_email;
  final VoidCallback onClose;
  const AchievmentsScreen({super.key, required this.user_email, required this.onClose});

  @override
  _AchievmentsScreenState createState() => _AchievmentsScreenState();
}

class _AchievmentsScreenState extends State<AchievmentsScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Achievments screen ",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        )
      ),
    );
  
  }
}