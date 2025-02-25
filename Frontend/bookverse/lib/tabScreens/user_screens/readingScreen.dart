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
   List<dynamic> books = []; // Store the list of books
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchReadingList(); // Fetch the reading list when the screen is initialized
  }

  Future<void> fetchReadingList() async {
    try {
      // Replace with your API endpoint to fetch the reading list
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-list/books/${widget.user_id}'));
      
      if (response.statusCode == 200) {
        setState(() {
          books = json.decode(response.body); // Decode the JSON response
          isLoading = false; // Set loading to false after fetching
        });
      } else {
        throw Exception('Failed to load reading list');
      }
    } catch (error) {
      // Handle errors (e.g., show a snackbar or dialog)
      print('Error fetching reading list: $error');
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        SizedBox(
          width: double.infinity, // Take full width
          child: Image.asset(
            'assets/book_reading_background.png', // Add your image in assets folder
            height: 160,
            fit: BoxFit.cover, // Ensure it covers the width nicely
            alignment: Alignment.topCenter, // Focus on the top part
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          "Reading List",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 60.0), // Add space at the top
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
              : books.isEmpty
                  ? const Center(child: Text("No books in your reading list.")) // Handle empty list case
                  : ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final bookData = books[index]['book'];
                        final status = books[index]['status']; 
                        final pagesRead = books[index]['pagesRead'] ?? 0; 
                        final totalPages = bookData['pages'] ?? 1; // Access total pages, default to 1 to avoid division by zero
                        // Calculate progress percentage
                        final progress = (pagesRead / totalPages).clamp(0.0, 1.0);
                        final progressPercentage = (progress * 100).toStringAsFixed(0); // Convert to percentage string
 // Circular Progress Indicator with percentage
                        
                        print('Total Pages for ${bookData['title']}: $totalPages');

                              
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), // Add horizontal and vertical padding
                          child: Row(
                            children: [
                              // Book Information
                              Expanded(
                                child: ListTile(
                                  title: Text(bookData['title'] ?? 'Unknown Title'),
                                  subtitle: Text(bookData['author'] ?? 'Unknown Author'),
                                  leading: bookData['coverImageUrl'] != null
                                      ? ClipOval(
                                          child: Image.network(
                                            bookData['coverImageUrl'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.book),
                                ),
                              ),
                              // Circular Progress Indicator with percentage
                              SizedBox(
                                width: 60, // Set width for the circular progress
                                height: 60,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey[300], // Background color of the progress circle
                                      color: const Color.fromARGB(255, 251, 207, 146), // Color of the progress
                                      strokeWidth: 4, // You can also adjust the stroke width if needed
                                    ),
                                    Text(
                                      '$progressPercentage%', // Display progress percentage
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12, // Adjust font size for better visibility
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
            ],
          ),
  ),
      );

  }
}
