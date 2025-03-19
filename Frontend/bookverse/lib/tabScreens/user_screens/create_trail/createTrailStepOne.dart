import 'dart:convert';

import 'package:bookverse/tabScreens/user_screens/create_trail/SuccessPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateTrailStepOne extends StatefulWidget {
  final String userId;
  const CreateTrailStepOne({super.key, required this.userId});

  @override
  State<CreateTrailStepOne> createState() => _CreateTrailStepOneState();
}

class _CreateTrailStepOneState extends State<CreateTrailStepOne> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  List<dynamic> _addedBooks = []; // This will store books added to the trail

  bool isTitleValid = false;
  bool isDescriptionValid = false;

  Widget buildTextField({
    required TextEditingController controller,
    required bool isObscure,
    required String hintText,
    required String? Function(String?) validator,
    required bool isValid,
    required void Function(String) onChanged,
    int maxLines = 1,
    double minHeight = 50,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, color: Color(0xFF171719), height: 1.36),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
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
      ),
    );
  }

  void _updateTitleValidation(String value) {
    setState(() {
      isTitleValid = validateTitle(value) == null;
    });
  }

  void _updateDescriptionValidation(String value) {
    setState(() {
      isDescriptionValid = validateDescription(value) == null;
    });
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  Future<void> _searchBooks() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final uri = Uri.parse('http://10.0.2.2:8080/books/search?query=$query');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        _books = json.decode(response.body);
      });
    }
  }

Future<void> addToReadingList(int trailId) async {
  final url = 'http://10.0.2.2:8080/reading-trails/add/${widget.userId}/$trailId/CREATED';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 201) {
    print("Added to reading list");
  } else {
    print('Failed to add book: ${response.statusCode} - ${response.body}');
  }
}
  Future<void> createReadingTrail(String title, String description, List books) async {
      final url = Uri.parse('http://10.0.2.2:8080/trails/create'); 
      final userId = widget.userId;
      print('User id: $userId');
      print('Books id : $books');
      final Map<String, dynamic> payload = {
        'title': title,
        'description': description,
        'creatorId': widget.userId,
        'books': books.map((book) => {'bookKey': book}).toList(),
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(payload),
        );
      if (response.statusCode == 201 ) {
        print('Trail created successfully');
        // Extract trail ID from response body
        final int trailId = int.parse(response.body);         
        
        print('Trail ID: $trailId'); // Debugging output
        addToReadingList(trailId);
        //add trail to reading list 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
      );
      } else {
        print('Failed to create trail. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating trail: $e');
    }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Create Trail",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20, // Slightly larger text for readability
          color: Colors.black87, // Text color
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA), // Set AppBar background color
      elevation: 0, // Remove shadow for a clean look
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              buildTextField(
                controller: _titleController,
                isObscure: false,
                hintText: 'Title',
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
                isValid: isTitleValid,
                onChanged: _updateTitleValidation
              ),
              const SizedBox(height: 20),
              buildTextField(
                controller: _descriptionController,
                isObscure: false,
                hintText: 'Description',
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
                isValid: isDescriptionValid,
                onChanged: _updateDescriptionValidation,
                maxLines: 5,
                minHeight: 120,
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    hintText: 'Search books by title',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchBooks,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              // Use SizedBox instead of Expanded
              SizedBox(
                height: 250, // Adjust height as needed
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      final book = _books[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            book['title'] ?? 'Unknown Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          subtitle: Text(
                            book['author'] ?? 'Unknown Author',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          leading: book['coverImageUrl'] != null
                              ? CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(book['coverImageUrl']),
                                )
                              : const Icon(Icons.book),
                          trailing: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                // Check if the book is already in the _addedBooks list
                                if (!_addedBooks.contains(book)) {
                                  _addedBooks.add(book);
                                } else {
                                  // Optionally, you can show a message or alert here if you want to inform the user
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('This book is already added.')),
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          
              const SizedBox(height: 50),
          
              // Books Added Section
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Books Added:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _addedBooks.isEmpty
                        ? const Text(
                            'No books added yet.',
                            style: TextStyle(color: Colors.black45),
                          )
                        : SizedBox(
                            height: 300, // Adjust height as needed
                            child: ListView.builder(
                              itemCount: _addedBooks.length,
                              itemBuilder: (context, index) {
                                final book = _addedBooks[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    title: Text(
                                      book['title'] ?? 'Unknown Title',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    subtitle: Text(
                                      book['author'] ?? 'Unknown Author',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    leading: book['coverImageUrl'] != null
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(book['coverImageUrl']),
                                          )
                                        : const Icon(Icons.book),
                                    trailing: IconButton(
                                      icon: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color:  Color(0xFFFFDCAA),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:  Color(0xFFFFDCAA),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _addedBooks.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  
                  ],
                ),
              ),
          
              const SizedBox(height: 30),
          
              GestureDetector(
                onTap: () {
                   if (_addedBooks.length >= 2 && (_formKey.currentState?.validate() ?? false )) {
                      String title = _titleController.text;
                      String description = _descriptionController.text;
                      List bookIds = _addedBooks.map((book) => book['key']).toList(); // Extract book IDs for the API call
                      createReadingTrail(title, description, bookIds);
              
                  } else {
                    // If any condition fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields and add at least 2 books.')),
                    );
                  }
                },
                child: Container(
                  width: 120, // Increased width for better text fit
                  height: 40, // Increased height for better touch interaction
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDCAA), // #ffdcaa
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Create Trail",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16, // Slightly larger text for readability
                        color: Colors.black87, // Text color
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    ),
  );
}

}
