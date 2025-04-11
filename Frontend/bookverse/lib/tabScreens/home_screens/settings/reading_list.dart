import 'package:bookverse/controller/booksController.dart';
import 'package:flutter/material.dart';

class ReadingListsceen extends StatefulWidget {
  final String userId;
  const ReadingListsceen({super.key, required this.userId});

  @override
  State<ReadingListsceen> createState() => _ReadingListsceenState();
}

class _ReadingListsceenState extends State<ReadingListsceen> {
  List<dynamic> books = [];
  bool isLoading = true;

  Future<void> updateProgress(String bookId, int newPagesRead) async {
    final update = await BooksController.updateProgress(widget.userId, bookId, newPagesRead);
    if (update) {
      setState(() {
        final updatedBookIndex = books.indexWhere((book) => book['bookKey'] == bookId);
        if (updatedBookIndex != -1) {
          books[updatedBookIndex]['pagesRead'] = newPagesRead;
        }
      });
    }
  }

  Future<void> fetchReadingList() async {
    final readingList = await BooksController.fetchReadingListBooks(widget.userId);
    setState(() {
        books = readingList;
        isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    fetchReadingList();
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
          borderRadius: BorderRadius.circular(12.0), 
        ),
        title: const Text(
          'Update Reading Progress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87, 
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
          fontSize: 20,
          color: Colors.black87, 
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA),
      elevation: 0, 
    ),
    body: SafeArea(
      child: SingleChildScrollView( 
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Books List",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            const SizedBox(height: 40.0),
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
                                                final bool canDelete = await BooksController.canBookBeDeleted(widget.userId, book['bookKey']);
                                                
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
                                                                  fontSize: 16,
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
                                                  BooksController.removeBooksFromReadingList(widget.userId, book['bookKey']);
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