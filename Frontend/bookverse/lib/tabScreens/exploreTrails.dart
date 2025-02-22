import 'package:flutter/material.dart';

class ExploreTrails extends StatefulWidget {
  const ExploreTrails({super.key});

  @override
  State<ExploreTrails> createState() => _ExploreTrailsState();
}

class _ExploreTrailsState extends State<ExploreTrails> {
  @override
  Widget build(BuildContext context) {
   return const Scaffold(
      body: Center(
        child: Text(
          "Explore books screen ",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        )
      ),
    );
  }
}