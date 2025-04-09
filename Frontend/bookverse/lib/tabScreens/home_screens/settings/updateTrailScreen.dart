import 'dart:convert';
import 'dart:io';

import 'package:bookverse/tabScreens/home_screens/settings/update_success_Screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdatetrailScreen extends StatefulWidget {
  final Map<String, dynamic> trail;
  final String userId;
  const UpdatetrailScreen({super.key, required this.trail, required this.userId});

  @override
  State<UpdatetrailScreen> createState() => _UpdatetrailScreenState();
}

class _UpdatetrailScreenState extends State<UpdatetrailScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _searchController = TextEditingController();

  bool isTitleValid = false;
  bool isDescriptionValid = false;
  List<dynamic> _addedBooks = [];
  List<dynamic> _books = [];
  File? _selectedImage; // Store selected image
  final ImagePicker _picker = ImagePicker();
  String defaulImage= '';


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
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

  void _updateNameValidation(String value) {
    setState(() {
      isTitleValid = validateTitle(value) == null;
    });
  }

  void _updateBioValidation(String value) {
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


  @override
  void initState() {
    super.initState();
    _titleController.text = widget.trail['trail']['title'] ?? '';
    _descriptionController.text =widget.trail['trail']['description'] ?? '';
    _addedBooks = List.from(widget.trail['trail']['trailBooks'] ?? []);
    defaulImage = widget.trail['trail']['imageUrl'] ?? '';
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

  Future<void> updateTrail( String title, String description, List bookIds) async {
    final url = Uri.parse('http://10.0.2.2:8080/trails/${widget.trail['trail']['id']}');
    final headers = {
      'Content-Type': 'application/json',
    };
 
    String? imageUrl = _selectedImage != null ? await uploadImage(_selectedImage!) : null;
    print(imageUrl);
 
    // Prepare the request body
    final body = json.encode({
      'title': title,
      'description': description,
      'creatorId': widget.userId,
      'books': bookIds.map((book) => {'bookKey': book}).toList(),
      'imageUrl': imageUrl, 
    });
    

    // Send the PUT request to update the profile
    final response = await http.put(url, headers: headers, body: body);

    // Check the response status to confirm the update
    if (response.statusCode == 200) {
       // Navigate to SuccessPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UpdateSuccessScreen()),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Updated succesfully!')),);
    
    } else {
      print('Failed to update profile: ${response.body}');
   
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Update trail",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20, // Slightly larger text for readability
          color: Colors.black87, // Text color
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA), // Set AppBar background color
      elevation: 0, // Remove shadow for a clean look
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const Text(
                  "Title",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                buildTextField(
                  controller: _titleController,
                  isObscure: false,
                  hintText: 'Title',
                  validator: (value) => value!.isEmpty ? 'Title is required' : null,
                  isValid: isTitleValid,
                  onChanged: _updateNameValidation,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                buildTextField(
                  controller: _descriptionController,
                  isObscure: false,
                  hintText: 'Description',
                  validator: (value) => value!.isEmpty ? 'Description is required' : null,
                  isValid: isDescriptionValid,
                  onChanged: _updateBioValidation,
                  maxLines: 5,
                ),

                const SizedBox(height: 20),
                const SizedBox(height: 40),
                //search
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        //blurRadius: 8,
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
                                  if (!_addedBooks.any((b) => b['book']['key'] == book['key'])) {
                                    _addedBooks.add({
                                      'id': _addedBooks.length,  // Assigning a new ID
                                      'book': book,  // Keeping the original structure
                                      'orderIndex': _addedBooks.length, 
                                      'pagesRead': 0,
                                    });
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
                const Text(
                  'Books Added:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),                // Books Added Section
                
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
                                final book = _addedBooks[index]['book'];
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
                
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_addedBooks.length >= 2 && (_formKey.currentState?.validate() ?? false )) {
                          String title = _titleController.text;
                          String description = _descriptionController.text;
                          List bookIds = _addedBooks.map((book) => book['book']['key']).toList();
                          print(bookIds);
                          updateTrail(title, description, bookIds);
                          
                      } else {
                        // If any condition fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill in all fields and add at least 2 books.')),
                          );
                      }
                    },
                    child: Container(
                      width: 120, // Increased width for better text fit
                      height: 40, // Increased height for better touch interaction
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDCAA), // #ffdcaa
                        borderRadius: BorderRadius.circular(10),
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
                          "Update Trail",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16, // Slightly larger text for readability
                            color: Colors.black87, // Text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
