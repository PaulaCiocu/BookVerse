import 'dart:convert';
import 'dart:io';

import 'package:bookverse/controller/booksController.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/create_trail/SuccessPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  String _selectedFilter = 'Title';

  bool isTitleValid = false;
  bool isDescriptionValid = false;

  File? _selectedImage; // Store selected image
  final ImagePicker _picker = ImagePicker();


  Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }
}

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
    final bookList = await BooksController.searchBooks(_selectedFilter, query);
    setState(() {
      _books = bookList;
    });
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
Future<String> uploadImage(File imageFile) async {
  try {
    // Create a reference to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('trail_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    // Upload the file
    await storageRef.putFile(imageFile);
    
    // Get the image URL
    String imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return '';
  }
}
Future<void> createReadingTrail(String title, String description, List books) async {
  final url = Uri.parse('http://10.0.2.2:8080/trails/create');
  
  // Upload the selected image
  String? imageUrl = _selectedImage != null ? await uploadImage(_selectedImage!) : null;
  print(imageUrl);
  final Map<String, dynamic> payload = {
    'title': title,
    'description': description,
    'creatorId': widget.userId,
    'books': books.map((book) => {'bookKey': book}).toList(),
    'imageUrl': imageUrl,  // Add the image URL here
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    if (response.statusCode == 201) {
      print('Trail created successfully');
      final int trailId = int.parse(response.body); // Assuming the trail ID is in the response body

      addToReadingList(trailId);

      // Navigate to SuccessPage
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
              // Image picker button
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage == null
                    ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
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
              //search
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
                                if (!_addedBooks.contains(book)) {
                                  _addedBooks.add(book);
                                } else {
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
                   if (_addedBooks.length >= 2 && (_formKey.currentState?.validate() ?? false ) 
                        && _selectedImage!= null) {
                      String title = _titleController.text;
                      String description = _descriptionController.text;
                      List bookIds = _addedBooks.map((book) => book['key']).toList();
                      createReadingTrail(title, description, bookIds);
              
                  } else {
                    // If any condition fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_selectedImage == null 
                          ? 'Please upload an image to create a trail.' 
                          : 'Please fill in all fields and add at least 2 books.')),
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
