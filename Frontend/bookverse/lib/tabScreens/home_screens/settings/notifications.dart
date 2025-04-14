import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  final String userId;
  const Notifications({super.key, required this.userId});


  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<dynamic> notifications = [];

  Future<void> loadNotifications() async {
    final url = Uri.parse('http://10.0.2.2:8080/notifications/${widget.userId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        notifications = json.decode(response.body);
      });
    
    } else {
      throw Exception('Failed to fetch unseen notification count');
    }
  }

  Widget buildStyledMessage(String message) {
    final RegExp regExp = RegExp(r"'(.*?)'");
    final match = regExp.firstMatch(message);

    if (match != null) {
      final before = message.substring(0, match.start);
      final quoted = match.group(1); // without the surrounding quotes
      final after = message.substring(match.end);

      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before),
            TextSpan(
              text: "$quoted",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
      );
    } else {
      return Text(message); // fallback if no quotes found
    }
  }


  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20, 
            color: Colors.black87, 
          ),
        ),
        backgroundColor: const Color(0xFFFFDCAA), 
        elevation: 0,
      ),  
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          title: buildStyledMessage(notification['message']),
                          onTap: () {
                            // Mark as read if needed
                          },
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),

    );
  }
}