import 'dart:io';
import 'package:bookverse/controller/booksController.dart';
import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/custom_ui/custom_text_field.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile/user_profile_tabs/trails/create_trail/success_page.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:bookverse/widgets/book_tile.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not create trail!')));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: 
        [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/trail_background.png',
              height: 140,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 160.0, right: 24, left: 24, bottom:16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Create Trail", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: _selectedImage == null
                            ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                            : ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'Trail Name',
                        hintText: 'Enter trail name',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.menu_book_rounded),
                        validator: validateFullName,
                        onSaved: (val) => _titleController.text = val?.trim() ?? '',
                      ),
                      
                      CustomTextField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Enter a short description of the trail',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.edit),
                        validator: validateFieldNotEmpty,
                        onSaved: (val) => _descriptionController.text = val?.trim() ?? '',
                        maxLines: 3,
                      ),
                      
                    
                  
                    //search
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all( 
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
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
                      height: 200, 
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _books.length,
                          itemBuilder: (context, index) {
                            final book = _books[index];
                            return BookTile(
                              book: book,
                              icon: const Icon(Icons.add, color: Colors.white, size: 22),
                              backgroundColor: Colors.grey.shade400,
                              onTap: () {
                                setState(() {
                                  if (!_addedBooks.any((b) => b['book']['key'] == book['key'])) {
                                    _addedBooks.add({
                                      'id': _addedBooks.length,
                                      'book': book,
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
                            );
                          },
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Books Added',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                
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
                                height: 200, // Adjust height as needed
                                child:
                                 ListView.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  itemCount: _addedBooks.length,
                                  itemBuilder: (context, index) {
                                    final book = _addedBooks[index]['book'];
                                    return BookTile(
                                      book: book,
                                      icon: const Icon(Icons.remove, color: Colors.white, size: 22),
                                      onTap: () {
                                        setState(() {
                                          _addedBooks.removeAt(index);
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
              
                    const SizedBox(height: 30),
                
                    GestureDetector(
                      onTap: ()  {
                        if (_addedBooks.length >= 2 && (_formKey.currentState?.validate() ?? false ) 
                              && _selectedImage!= null) {
                            _formKey.currentState?.save();
                            String title = _titleController.text;
                            String description = _descriptionController.text;
                            List bookIds = _addedBooks.map((entry) => entry['book']['key']).toList();
                            print('Books ids:');
                            print(bookIds);
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
                        width: 110, 
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
                        child:  Center(
                          child: Text(
                            "Create Trail",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
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
        ]
      ),
    );
  }

}
