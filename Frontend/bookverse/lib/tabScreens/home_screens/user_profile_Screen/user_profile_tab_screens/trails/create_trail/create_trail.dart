import 'dart:io';
import 'package:bookverse/controller/booksController.dart';
import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/custom_ui/custom_textfield.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/create_trail/success_page.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:flutter/material.dart';
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
  final List<dynamic> _addedBooks = [];
  final String _selectedFilter = 'Title';
  bool isTitleValid = false;
  bool isDescriptionValid = false;
  File? _selectedImage; 
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _updateTitleValidation(String value) {
    setState(() {
      isTitleValid = validateField(value, 'Title') == null;
      _formKey.currentState!.validate(); 
    });
  }

  void _updateDescriptionValidation(String value) {
    setState(() {
      isDescriptionValid = validateField(value, 'Description') == null;
      _formKey.currentState!.validate(); 
    });
  }

  Future<void> _searchBooks() async {
    final query = _searchController.text.trim();
    final bookList = await BooksController.searchBooks(_selectedFilter, query);
    setState(() {
      _books = bookList;
    });
  }

  Future<void> createReadingTrail(String title, String description, List books) async {
    final success = await TrailController.createReadingTrail(widget.userId, _selectedImage!, title, description, books);
    if(success){
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SuccessPage()),);
    } else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not create trail!')));
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
            fontSize: 20, 
            color: Colors.black87, 
          ),
        ),
        backgroundColor: const Color(0xFFFFDCAA), 
        elevation: 0
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
                const SizedBox(height: 50),
                buildTextField(
                  controller: _titleController,
                  isObscure: false,
                  hintText: 'Title',
                  validator: (value) => validateField(value, 'Title', minLength: 5),
                  isValid: isTitleValid,
                  onChanged: _updateTitleValidation
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: _descriptionController,
                  isObscure: false,
                  hintText: 'Description',
                  validator: (value) => validateField(value, 'Description', minLength: 5),
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
                  height: 250, 
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _books.isEmpty
                      ? const Center(
                        child: Text(
                          'No books available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      )
                      : ListView.builder(
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
                              height: 300, 
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
                    width: 120, 
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDCAA), 
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
                          fontSize: 16, 
                          color: Colors.black87,
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
