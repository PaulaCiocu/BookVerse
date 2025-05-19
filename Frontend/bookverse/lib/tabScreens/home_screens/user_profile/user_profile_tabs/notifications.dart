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
      throw Exception('Failed to fetch notifications');
    }
  }

    Future<void> markAsSeen() async {
    final url = Uri.parse('http://10.0.2.2:8080/notifications/mark-as-seen/${widget.userId}');

    final response = await http.post(
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
      throw Exception('Failed to fetch notifications');
    }
  }

  Widget buildStyledMessage(String message) {
    final RegExp regExp = RegExp(r"'(.*?)'");
    final match = regExp.firstMatch(message);

    if (match != null) {
      final before = message.substring(0, match.start);
      final quoted = match.group(1);
      final after = message.substring(match.end);

      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before),
            TextSpan(
              text: quoted,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      );
    } else {
      return Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadNotifications();
    markAsSeen();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            'assets/achievements.png',
            height: 140,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 24, right: 24, bottom: 8),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Notifications",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 60,),
                Expanded(
                child: notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'No notifications yet.',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0), // space between cards
                          child: Card(
                            elevation: 2,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.notifications, color: Colors.amber, size: 30),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DefaultTextStyle(
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                      child: buildStyledMessage(notification['message']),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


}
