import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadingListsceen extends StatefulWidget {
  final String userId;
  const ReadingListsceen({super.key, required this.userId});

  @override
  State<ReadingListsceen> createState() => _ReadingListsceenState();
}

class _ReadingListsceenState extends State<ReadingListsceen> {
   List<dynamic> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReadingList();
  }

  Future<void> fetchReadingList() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-list/books/${widget.userId}'));

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

  // Function to update progress for a specific book
Future<void> updateProgress(String bookId, int newPagesRead) async {
  try {
    final url = Uri.parse(
      'http://10.0.2.2:8080/reading-list/update-progress/${widget.userId}/$bookId?pagesRead=$newPagesRead'
    );

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        // Find the book and update its progress locally
        final updatedBookIndex = books.indexWhere((book) => book['bookKey'] == bookId);
        if (updatedBookIndex != -1) {
          books[updatedBookIndex]['pagesRead'] = newPagesRead; // Update the pagesRead
        }
      });
    } else {
      throw Exception('Failed to update progress: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating progress: $error');
  }
}

Future<bool> canBookBeDeleted(String bookId) async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-list/isBookNotInTrail/${widget.userId}/$bookId'));

    if (response.statusCode == 200) {
      // Assuming the response body is a boolean value
      return json.decode(response.body);
    } else {
      // Handle unexpected responses, e.g. server error or wrong status code
      throw Exception('Failed to load reading list');
    }
  } catch (error) {
    print('Error fetching reading list: $error');
    // Handle error gracefully, maybe return false or show a message
    return false;
  }
}

Future<bool> removeBooksFromReadingList(String bookId) async {
    final url = Uri.parse('http://10.0.2.2:8080/reading-list/delete/${widget.userId}/$bookId');
    
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Trail deleted successfully
        print("Deleted successfully");
        return true;
      } else {
        // Failed to delete trail
        print('Failed to delete trail: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting trail: $e');
      return false;
    }
  }

  Future<void> showProgressDialog(BuildContext context, String bookId, int currentPagesRead) async {
  TextEditingController controller = TextEditingController(text: currentPagesRead.toString());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners for the dialog
        ),
        title: const Text(
          'Update Reading Progress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87, // Title color
          ),
        ),
        content: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, color: Color(0xFF171719), height: 1.36),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                hintText: 'Pages Read',
                filled: true,
                fillColor: const Color(0xD9FFFFFF),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                // Ensure the entered value is not negative
                final parsedValue = int.tryParse(value ?? '');
                if (parsedValue == null || parsedValue < 0) {
                  return 'Please enter a positive number';
                }
                return null;
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final newPagesRead = int.tryParse(controller.text) ?? currentPagesRead;
                updateProgress(bookId, newPagesRead);
                Navigator.of(context).pop();
              } else {
                // Show a snackbar if validation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a valid positive number")),
                );
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      );
    },
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Reading List",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20, // Slightly larger text for readability
          color: Colors.black87, // Text color
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA), // Set AppBar background color
      elevation: 0, // Remove shadow for a clean look
    ),
    body: SafeArea(
      child: SingleChildScrollView(  // Wrap everything in a SingleChildScrollView
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Books List",
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
                      child: ListView.builder(
                          shrinkWrap: true, // Ensures the ListView takes up only as much space as necessary
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            final pagesRead = book['pagesRead'] ?? 0;
                            final totalPages = book['totalPages'] ?? 1;
                            final progress = (pagesRead / totalPages).clamp(0.0, 1.0);
                            final progressPercentage = (progress * 100).toStringAsFixed(0);
                      
                            return Card(
                              color: Colors.white,
                              child: Padding(
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
                                            child: GestureDetector(
                                              onTap: () {
                                                showProgressDialog(context, book['bookKey'], pagesRead);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Update Nr. Pages: $pagesRead / $totalPages',
                                                    style: const TextStyle(fontSize: 14,   color: Colors.black87),
                                                  ),
                                                  const SizedBox(width: 8,),
                                                  const Icon(
                                                    Icons.edit,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () async {
                                              // Show confirmation dialog
                                              bool? removeBooksConfirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    contentPadding: EdgeInsets.zero,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16),  // Optional: Rounded corners for the dialog
                                                    ),
                                                    title: const Column(
                                                      children: [
                                                        Text(
                                                          'Remove book from reading list', 
                                                          style: TextStyle(
                                                            color: Colors.black87,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18
                                                          ),
                                                        ),
                                                        SizedBox(height: 20,),
                                                        Text(
                                                          'Are you sure you want to remove this book?', 
                                                          style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 16
                                                          ),
                                                        ),
                                                        // SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(false); // User cancels logout
                                                            },
                                                            child: const Text('CANCEL', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                                          ),
                                                          const SizedBox(width: 20,),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(true); // User confirms logout
                                                            },
                                                            child: const Text('YES', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              if (removeBooksConfirmed == true) {
                                                final bool canDelete = await canBookBeDeleted(book['bookKey']);
                                                
                                               if (canDelete == false) {
                                                  showDialog<bool>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor: Colors.white,
                                                        titlePadding: EdgeInsets.all(16),
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Book is part of a trail and can not be deleted',
                                                                style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(Icons.close, color: Colors.grey),
                                                              onPressed: () {
                                                                Navigator.of(context).pop(false);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }

                                                else{
                                                  removeBooksFromReadingList(book['bookKey']);
                                                 
                                                }
                                                
                                              }
                                               fetchReadingList();
                                            },
        
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 12.0, top: 6),
                                              child: Container(
                                                width: 80,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFDCAA),
                                                  borderRadius: BorderRadius.circular(3),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.shade300,
                                                      blurRadius: 3,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'REMOVE',
                                                      style: TextStyle(fontSize: 12, color: Colors.black87),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // GestureDetector(
                                          //   onTap: () {
                                              
                                          //   },
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(bottom: 12.0, top: 6),
                                          //     child: Container(
                                          //       width: 80,
                                          //       height: 20,
                                          //       decoration: BoxDecoration(
                                          //         color: const Color(0xFFFFDCAA),
                                          //         borderRadius: BorderRadius.circular(3),
                                          //         boxShadow: [
                                          //           BoxShadow(
                                          //             color: Colors.grey.shade300,
                                          //             blurRadius: 3,
                                          //             offset: const Offset(0, 2),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //       child: const Row(
                                          //         mainAxisAlignment: MainAxisAlignment.center,
                                          //         children: [
                                          //           Text(
                                          //             'REMOVE',
                                          //             style: TextStyle(fontSize: 12, color: Colors.black87),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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