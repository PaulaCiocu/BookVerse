import 'package:bookverse/controller/booksController.dart';
import 'package:bookverse/controller/reviewController.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookKey;
  final String userId;
  final VoidCallback onClose;

  const BookDetailScreen({
    super.key, 
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
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int rating = 1; 
  bool _isExpanded = false;
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

  Future<void> _addToReadingList() async {
    final isAdded = await BooksController.addToReadingList(widget.userId, widget.bookKey);
    setState(() {
      _isAddedToList =  isAdded;
    });
  }

  Future<void> _fetchReviews() async {
    final reviewList = await ReviewController.fetchReviews(widget.bookKey);
    setState(() {
      reviews = reviewList;
    });
  }

  Future<void> _loadData() async {
    _bookDetailsFuture =  BooksController.fetchBookDetails(widget.bookKey);
    final isAddedToList = await BooksController.checkIfBookInReadingList(widget.userId, widget.bookKey);
    setState(() {
      _isAddedToList = isAddedToList;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchReviews();
    _loadData();
  }


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
                        onPressed: _isAddedToList ? null : _addToReadingList,
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
                                          const Icon(Icons.star, size: 20, color: Colors.amber,)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20), 
                            ElevatedButton(
                                onPressed: () {
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
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 14),),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if (_formKey.currentState?.validate() ?? false) {
                                                bool success = await ReviewController.createReview(
                                                  userId: widget.userId,
                                                  bookKey: widget.bookKey,
                                                  rating: rating,
                                                  content: _contentController.text,
                                                );

                                                if (success) {
                                                  _fetchReviews(); 
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("Review submitted successfully!"),
                                                      backgroundColor: Colors.green,
                                                      duration: Duration(seconds: 3),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
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
