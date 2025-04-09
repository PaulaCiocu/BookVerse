import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookDetailScreen extends StatefulWidget {
  final String bookKey;
  final String userId;
  final VoidCallback onClose;

  const BookDetailScreen({
    required this.bookKey,
    required this.onClose,
    required this.userId,
  });

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isAddedToList = false;
  Future<Map<String, dynamic>>? _bookDetailsFuture;
  List<dynamic> reviews = [];
  TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int rating = 1; 

  bool isContentValid = false;
  // Update TextField widget
  Widget buildTextField({
    required TextEditingController controller,
    required bool isObscure,
    required String hintText,
    required String? Function(String?) validator,
    required bool isValid,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(fontSize: 14, color: Color(0xFF171719), height: 1.36),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xD9FFFFFF),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Colors.green : Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Colors.green : const Color(0xFFD7D7DC)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Colors.green : const Color(0xFFD7D7DC)),
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
      validator: validator,
      onChanged: onChanged,
      maxLines: 6, // Allow up to 5 lines for the user to write
      keyboardType: TextInputType.multiline, // Allow multi-line input
    );
  }

  // Update the validation state when text changes
  void _updateContentValidation(String value) {
    setState(() {
      isContentValid = validateContent(value) == null;
    });
  }

   String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Content can not be empty';
    }
    return null;
      }
  Future<bool> createReview({
    required int rating,
    required String content,
  }) async {
    final url = Uri.parse(
      'http://10.0.2.2:8080/api/reviews/create/${widget.bookKey}/${widget.userId}?content=$content&rating=$rating',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Review created successfully');
        return true;
      } else {
        print('Failed to create review: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error creating review: $e');
      return false;
    }
  }





  Future<void> fetchReviews() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/reviews/book/${widget.bookKey}'));
    if (response.statusCode == 200) {
      setState(() {
        reviews = json.decode(response.body);
      });
    }
  }

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
        _isAddedToList = true;
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
    fetchReviews();
    _bookDetailsFuture = _fetchBookDetails();
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: book['coverImageUrl'] != null
                            ? Image.network(
                                book['coverImageUrl'],
                                height: 180,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              )
                            : const Icon(Icons.book, size: 100),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Text(book['title'] ?? 'Unknown Title', 
                          style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        )  
                      ),
                      const SizedBox(height: 10),
                      Text('${book['author'] ?? 'Unknown'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Text(
                                  _isExpanded ? 'See less...' : 'See more...',
                                ),
                              ),
                              const SizedBox(height: 10),
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
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Pages:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  Text(book['pages']?.toString() ?? 'No page info available'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Language:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  Text(book['language'] ?? 'No language info available'),
                                ],
                              ),
                              const SizedBox(height: 5),
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
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _isAddedToList ? null : addToReadingList,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text("Reviews", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                            SizedBox(height: 20,),
                            reviews.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'No reviews yet',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                              height: 200, // Give it fixed height
                              child: ListView.builder(
                                padding: const EdgeInsets.all(12.0), // Add padding to the list
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return Card(  // Wrap with Card for better presentation
                                    color: Colors.white,
                                    elevation: 3, // Add shadow for depth
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0), // Padding inside the ListTile
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            review['person']['fullName'] ?? 'Anonymous', // Display name of the reviewer
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0), // Spacing between name and review content
                                          Text(
                                            review['content'] ?? 'No content',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            'Rating: ${review['rating']}/5',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Icon(Icons.star, size: 20, color: Colors.amber,)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20), // Space between reviews and button
                            ElevatedButton(
                                onPressed: () {
                                  // Show dialog to add review
                                  showDialog(
                                    context: context,
                                    
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Form(
                                          key: _formKey,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text('Add Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                                                const SizedBox(height: 10),
                                                
                                                 buildTextField(
                                                    controller: _contentController,
                                                    isObscure: false,
                                                    hintText: '',
                                                    validator: validateContent,
                                                    isValid: isContentValid,
                                                    onChanged: _updateContentValidation,
                                                  ),
                                                const SizedBox(height: 20),
                                                
                                                Row(
                                                  children: [
                                                    Text('Rating', style: TextStyle(fontSize: 16),),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      width: 60,
                                                      height: 40,
                                                      child: DropdownButtonFormField<int>(
                                                        value: rating,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            rating = value!;
                                                          });
                                                        },
                                                        items: List.generate(5, (index) {
                                                          return DropdownMenuItem<int>(
                                                            value: index + 1,
                                                            child: Text('${index + 1}'),
                                                          );
                                                        }),
                                                         decoration: InputDecoration(
                                                          
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding inside the field
                                                          filled: true, // Ensure the background color is filled
                                                          fillColor: Colors.white, // Background color of the field
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.white), // Border color
                                                            borderRadius: BorderRadius.circular(12), // Rounded corners
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.white),
                                                            borderRadius: BorderRadius.circular(12), // Rounded corners
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.blue), // Border color when focused
                                                            borderRadius: BorderRadius.circular(12), // Rounded corners
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              
                                              Navigator.pop(context); // Close the dialog
                                            },
                                            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 14),),
                                          ),
                                          TextButton(
  onPressed: () async {
    if (_formKey.currentState?.validate() ?? false) {
      bool success = await createReview(
        rating: rating,
        content: _contentController.text,
      );

      if (success) {
        fetchReviews(); // Refresh the reviews list
        Navigator.pop(context); // Close the form dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Review submitted successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit the review. Please try again."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  },
  child: const Text('Submit', style: TextStyle(fontSize: 16, color: Colors.black87)),
),

                                        ],
                                      );
                                    },
                                  );
                                },
                  
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0), // Rounded corners for button
                                ),
                               backgroundColor: const Color(0xFFFFDCAA), 
                              ),
                              child: const Text(
                                'Add Review',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
