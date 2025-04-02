
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class BookDetailScreen extends StatefulWidget {
  final String bookKey;
  final String userId;
  final VoidCallback onClose;
  const BookDetailScreen({required this.bookKey, required this.onClose, required this.userId});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isAddedToList = false; // Track if the book is added
  Future<Map<String, dynamic>>? _bookDetailsFuture; // Change to nullable
  Future<Map<String, dynamic>> _fetchBookDetails() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/books/${widget.bookKey}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  Future<void> addToReadingList() async {
    final url = 'http://10.0.2.2:8080/reading-list/add/${widget.userId}/${widget.bookKey}';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _isAddedToList = true; // Update state when added
      });
    } else {
      print('Failed to add book: ${response.statusCode} - ${response.body}');
    }
  }
  
  Future<void> _checkIfBookInReadingList() async {
  final url = 'http://10.0.2.2:8080/reading-list/check/${widget.userId}/${widget.bookKey}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    setState(() {
      _isAddedToList = response.body.toLowerCase() == 'true';
    });
  } else {
    print('Failed to check reading list status: ${response.statusCode}');
  }
}

  @override
  void initState() {
    super.initState();
    _bookDetailsFuture = _fetchBookDetails(); // Fetch book details on initialization
    _checkIfBookInReadingList();
  }
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _bookDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final book = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity, // Take full width
                      child: book['coverImageUrl'] != null
                          ? Image.network(
                              book['coverImageUrl'],
                              height: 180,
                              fit: BoxFit.cover, // Ensure it covers the width nicely
                              alignment: Alignment.topCenter, // Focus on the top part
                            )
                          : const Icon(Icons.book, size: 100),
                    ),
                    const SizedBox(height: 20),
                
                        
                    Text(book['title'] ?? 'Unknown Title', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text('${book['author'] ?? 'Unknown'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    // Container for description and below items
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0), // Add padding here
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300), // Border color and opacity
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                          children: [
                            const Text('Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            Text(
                              _isExpanded
                                  ? book['description'] ?? 'No description available'
                                  : (book['description'] ?? 'No description available').split('\n').take(5).join('\n'),
                              maxLines: _isExpanded ? null : 5,
                              overflow: _isExpanded ? null : TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded; // Toggle expanded state
                                });
                              },
                              child: Text(
                                _isExpanded ? 'See less...' : 'See more...',
                              ),
                            ),
                            
                            const SizedBox(height: 10), // Add spacing before genre
                            
                            // Genre
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Genre:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    book['subjects'] != null
                                        ? book['subjects'].join(", ")
                                        : 'No genre info available',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5), // Add spacing before pages
                            
                            // Pages
                            Row(
                              children: [
                                const Text('Pages:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5),
                                Text(book['pages']?.toString() ?? 'No page info available'),
                              ],
                            ),
                            const SizedBox(height: 5), // Add spacing before language
                            
                            // Language
                            Row(
                              children: [
                                const Text('Language:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5),
                                Text(book['language'] ?? 'No language info available'),
                              ],
                            ),
                            const SizedBox(height: 5), // Add spacing before publish date
                            
                            // Published date
                            Row(
                              children: [
                                const Text('Published date:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5),
                                Text(book['publish_date'] ?? 'No publish date available'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                                        // Add some spacing before the button
                    const SizedBox(height: 20),

                    // ADd to reading Button
                    ElevatedButton.icon(
                      onPressed: _isAddedToList ? null : addToReadingList, // Disable button if already added
                      icon: const Icon(Icons.menu_book_rounded, color: Colors.black87),
                      label: Text(_isAddedToList ? "Added to Reading List" : "Add to Reading"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAddedToList ? Colors.green : const Color(0xFFFFDCAA),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    
                    const SizedBox(height: 20), 

                  
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
