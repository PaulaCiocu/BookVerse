import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Readingscreen extends StatefulWidget {
  final String user_id;
  final VoidCallback onClose;

  const Readingscreen({super.key, required this.user_id, required this.onClose});

  @override
  State<Readingscreen> createState() => _ReadingscreenState();
}

class _ReadingscreenState extends State<Readingscreen> {
  List<dynamic> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReadingList();
  }

  Future<void> fetchReadingList() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-list/books/${widget.user_id}'));

      if (response.statusCode == 200) {
        setState(() {
          books = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reading list');
      }
    } catch (error) {
      print('Error fetching reading list: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(  // Wrap everything in a SingleChildScrollView
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/trail_background.png',
                height: 120,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Reading List",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            const SizedBox(height: 40.0),
            // Directly place your ListView.builder here
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : books.isEmpty
                    ? const Center(child: Text("No books in your reading list."))
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.white,
                        child: ListView.builder(
                            shrinkWrap: true, // Ensures the ListView takes up only as much space as necessary
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              final pagesRead = book['pagesRead'] ?? 0;
                              final totalPages = book['totalPages'] ?? 1;
                              final progress = (pagesRead / totalPages).clamp(0.0, 1.0);
                              final progressPercentage = (progress * 100).toStringAsFixed(0);
                        
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    // Book cover image or default icon
                                    Padding(
                                      padding: const EdgeInsets.all(8.0), // Padding around the image/icon
                                      child: book['coverImageUrl'] != null
                                          ? ClipOval(
                                              child: Image.network(
                                                book['coverImageUrl'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Icon(Icons.book, size: 50), // Default icon if no cover image
                                    ),
                                    // Book details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 1.0, top:12.0), // Space between title and author
                                            child: Text(
                                              book['title'] ?? 'Unknown Title',
                                              style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Padding(
                                            padding:  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0), // Space between author and pages
                                            child: Text(
                                              book['author'] ?? 'Unknown Author',
                                              style: const TextStyle(fontSize: 14,  color: Colors.black87),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                            child: Text(
                                              'Pages: $pagesRead / $totalPages',
                                              style: const TextStyle(fontSize: 12,   color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: progress,
                                            backgroundColor: Colors.grey[300],
                                            color: const Color.fromARGB(255, 251, 207, 146),
                                            strokeWidth: 4,
                                          ),
                                          Text(
                                            '$progressPercentage%',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ),
                    ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}



}
