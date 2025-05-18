import 'dart:convert';

import 'package:bookverse/controller/booksController.dart';
import 'package:bookverse/custom_ui/custom_text_field.dart';
import 'package:bookverse/events/AppEvents.dart';
import 'package:bookverse/widgets/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reading_list_${widget.userId}', jsonEncode(books));

    
    }
  }
  Future<void> removeBookFromReadingList(String bookId) async {
  final remove = await BooksController.removeBooksFromReadingList(widget.userId, bookId);
  if (remove) {
    setState(() {
      books.removeWhere((book) => book['bookKey'] == bookId);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reading_list_${widget.userId}', jsonEncode(books));
  }
}

  Future<void> fetchReadingList() async {
    try {
      // Try loading cached data first for immediate display
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('reading_list_${widget.userId}');
      
      if (cachedData != null) {
        // If we have cached data, show it immediately
        setState(() {
          books = List<dynamic>.from(jsonDecode(cachedData));
          isLoading = false; // No longer loading since we have data to show
        });
      }
      
      // Then fetch fresh data from network (happens in background if we already showed cached data)
      final readingList = await BooksController.fetchReadingListBooks(widget.userId);
      
      // Update UI with fresh data
      setState(() {
        books = readingList;
        isLoading = false;
      });
      
      // Save updated data to cache for next time
      await prefs.setString('reading_list_${widget.userId}', jsonEncode(readingList));
    } catch (e) {
      print('Error in fetchReadingList: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> clearCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('reading_list_${widget.userId}');
}
  
  @override
  void initState() {
    super.initState();
    fetchReadingList();
  }

  String? validatePagesRead(String? value) {
    final parsedValue = int.tryParse(value ?? '');
    if (parsedValue == null || parsedValue < 0) {
      return 'Please enter a positive number';
    }
    return null;
  }


  

  Future<void> showProgressDialog(BuildContext context, String bookId, int currentPagesRead) async {
  TextEditingController controller = TextEditingController(text: currentPagesRead.toString());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // softer corners
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        content: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: Colors.amber.shade200,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Update Pages Read',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: controller,
                keyboardType: TextInputType.number,
                labelText: 'Pages',
                hintText: 'Enter new pages read',
                prefixIcon: const Icon(Icons.pages_outlined),
                validator: (value) {
                  final parsedValue = int.tryParse(value ?? '');
                  if (parsedValue == null || parsedValue < 0) {
                    return 'Please enter a positive number';
                  }
                  return null;
                },
                onSaved: (val) => controller.text = val?.trim() ?? '',
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        final newPagesRead = int.tryParse(controller.text) ?? currentPagesRead;
                        updateProgress(bookId, newPagesRead);
                        AppEvents.notifyAchievementsUpdated();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a valid positive number")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Update',
                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar:true,
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    body: Stack(
      children: 
      [ 
        SizedBox(
          width: double.infinity,
          // child: Image.asset(
          //         'assets/brown background.png',
          //         height: 140,
          //         fit: BoxFit.cover,
          //         alignment: Alignment.topCenter,
          //       ),
          child: Image.asset(
            'assets/trail_background.png',
            height: 140,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: SafeArea(
            child: Column(
              children: [
                Text(
                  "Reading List",
                   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)
                ),
                const SizedBox(height: 30.0),
                Expanded(
                  child: isLoading
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: book['coverImageUrl'] != null
                                              ? ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: book['coverImageUrl']!,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : const Icon(Icons.book, size: 50),
                        
                                          ),
                                          // Book details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 1.0, top:12.0),
                                                  child: Text(
                                                    book['title'] ?? 'Unknown Title',
                                                    style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                                                  child: Text(
                                                    book['author'] ?? 'Unknown Author',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
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
                                                          'Nr. Pages: $pagesRead / $totalPages',
                                                           style: Theme.of(context).textTheme.bodyMedium,
                                                        ),
                                                        const SizedBox(width: 8,),
                                                        const Icon(
                                                          Icons.edit,
                                                          size: 15,
                                                          color: Colors.amber,
                                                        ),

                                                        GestureDetector(
                                                          onTap: () async {
                                                          bool? removeBooksConfirmed = await showRemoveBookDialog(context);
                                                            if (removeBooksConfirmed == true) {
                                                              final bool canDelete = await BooksController.canBookBeDeleted(widget.userId, book['bookKey']);
                                                              if (!canDelete) {
                                                                await showBookCannotBeDeletedDialog(context);
                                                              } else {
                                                                removeBookFromReadingList(book['bookKey']);
                                                              }
                                                            }
                                                            fetchReadingList();
                                                          },
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.delete,
                                                              size: 15,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                
                                                      ],
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
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ]
    ),
  );
}
}