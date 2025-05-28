import 'package:bookverse/controller/booksController.dart';
import 'package:bookverse/controller/reviewController.dart';
import 'package:bookverse/utils/snackbar.dart';
import 'package:bookverse/widgets/add_review_dialog.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  List<dynamic> reviews = [];
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int rating = 1; 
  bool _isExpanded = false;
  bool isContentValid = false;
  late final Future<void> _initFuture;
  void _updateContentValidation(String value) {
    setState(() {
      isContentValid = validateField(value, 'Content') == null;
    });
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

  Map<String, dynamic>? _bookDetails;
  Future<void> _loadDetailsAndStatus() async {
    final detailsFuture = BooksController.fetchBookDetails(widget.bookKey);
    final statusFuture  = BooksController.checkIfBookInReadingList(widget.userId, widget.bookKey);
    final results = await Future.wait([detailsFuture, statusFuture]);
    _bookDetails   = results[0] as Map<String, dynamic>;
    _isAddedToList = results[1] as bool;
  }

  @override
  void initState() {
    super.initState();
    _initFuture = Future.wait([
      _fetchReviews(),                  
      _loadDetailsAndStatus(),            
    ]).then((results) {
     
    });
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
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load trail details"));
          } else {
            final book = _bookDetails!;
            return Stack(
              children:[
                SizedBox(
                  width: double.infinity,
                  height: 160, // choose your image height
                  child: CachedNetworkImage(
                    imageUrl: book['coverImageUrl'] ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Image.asset(
                      'assets/user_profile_backgrounds_screen.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 160.0),
                  child: SafeArea(
                    top: false, 
                    child: SingleChildScrollView(
                    child: 
                      Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                        
                                const SizedBox(height: 20),
                                Text(book['title'] ?? 'Unknown Title', 
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text('${book['author'] ?? 'Unknown'}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic)),
                                const SizedBox(height: 30),
                
                                DefaultTabController(
                                  length: 2,
                                  child: Column(
                                    children: [
                                      const TabBar(
                                        indicatorColor: Colors.black87,
                                        labelColor: Colors.black87,
                                        unselectedLabelColor: Colors.grey,
                                        tabs: [
                                          Tab(text: 'Details'),
                                          Tab(text: 'Reviews'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.55, 
                                        child: TabBarView(
                                          children: [
                                            Column(
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Padding(
                                                      padding:  EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                                      child: Container(
                                                        padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(12),
                                                          gradient: LinearGradient(
                                                            colors: [Colors.white, Colors.grey.shade100], 
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.08),
                                                              blurRadius: 20,
                                                              offset: Offset(0, 10),
                                                            ),
                                                          ],
                                                        
                                                        ),
                                                        
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(12),
                                                                gradient: LinearGradient(
                                                                  colors: [Colors.white, Colors.grey.shade200], 
                                                                  begin: Alignment.topLeft,
                                                                  end: Alignment.bottomRight,
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.black.withOpacity(0.08),
                                                                    blurRadius: 20,
                                                                    offset: Offset(0, 10),
                                                                  ),
                                                                ],),
                                                        
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(height: 5),
                                                                  Text(
                                                                    _isExpanded
                                                                        ? book['description'] ?? 'No description available'
                                                                        : (book['description'] ?? 'No description available').split('\n').take(5).join('\n'),
                                                                    maxLines: _isExpanded ? null : 10,
                                                                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
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
                                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                        fontSize: 12, 
                                                                        color: Color.fromARGB(255, 225, 209, 179),
                                                                        fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 5),
                                                                  const SizedBox(height: 10), 
                                                                  LayoutBuilder(
                                                                    builder: (context, constraints) {
                                                                      return Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: List.generate(
                                                                          (constraints.maxWidth / 10).floor(),
                                                                          (index) => Container(
                                                                            width: 7,
                                                                            height: 2,
                                                                            color: Colors.grey[300],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  const SizedBox(height: 15), 
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Icon(Icons.theater_comedy_rounded, size: 14,  color: Color.fromARGB(255, 225, 209, 179),),
                                                                      const SizedBox(width: 4),
                                                                      Text('Genre:', style: Theme.of(context).textTheme.titleSmall),
                                                                      const SizedBox(width: 5),
                                                                      Expanded(
                                                                        child: Text(
                                                                          book['subjects'] != null
                                                                              ? book['subjects'].join(", ")
                                                                              : 'No genre info available',
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 2,
                                                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 5),
                                                                  Row(
                                                                    children: [
                                                                      Icon(Icons.auto_stories_rounded, size: 14,  color: Color.fromARGB(255, 225, 209, 179),),
                                                                      const SizedBox(width: 5),
                                                                      Text('Pages:', style: Theme.of(context).textTheme.titleSmall),
                                                                      const SizedBox(width: 5),
                                                                      Text(book['pages']?.toString() ?? 'No page info available', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 5),
                                                                  Row(
                                                                    children: [
                                                                      Icon(Icons.language_rounded, size: 14,  color: Color.fromARGB(255, 225, 209, 179),),
                                                                      const SizedBox(width: 5),
                                                                      Text('Language:', style: Theme.of(context).textTheme.titleSmall),
                                                                      const SizedBox(width: 5),
                                                                      Text(book['language'] ?? 'No language info available', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 5),
                                                                  Row(
                                                                    children: [
                                                                      Icon(Icons.calendar_month_rounded, size: 14, color: Color.fromARGB(255, 225, 209, 179), ),
                                                                      const SizedBox(width: 5),
                                                                      Text('Published date:', style: Theme.of(context).textTheme.titleSmall),
                                                                      const SizedBox(width: 5),
                                                                      Text(book['publish_date'] ?? 'No publish date available', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                
                                                ElevatedButton.icon(
                                                  onPressed: _isAddedToList ? null : _addToReadingList,
                                                  icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
                                                  label: Text(_isAddedToList ? "Added to List" : "Add to List"),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: _isAddedToList ? Colors.green : const Color(0xFFFFDCAA),
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(height: 10,)
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20,),
                                                  reviews.isEmpty
                                                      ?  Center(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'No reviews yet',
                                                              style: Theme.of(context).textTheme.titleSmall
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(
                                                    height: 300, 
                                                    child: ListView.builder(
                                                      padding: const EdgeInsets.all(12.0), 
                                                      itemCount: reviews.length,
                                                      itemBuilder: (context, index) {
                                                        final review = reviews[index];
                                                        return Card(
                                                          color: Colors.white,
                                                          elevation: 3, 
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12.0), 
                                                          ),
                                                          child: ListTile(
                                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                                                            title: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  review['personName'] ?? 'Anonymous', 
                                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)
                                                                ),
                                                                const SizedBox(height: 4.0), // Spacing between name and review content
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      review['content'] ?? 'No content',
                                                                      style: Theme.of(context).textTheme.bodyMedium
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            subtitle: Row(
                                                              children: List.generate(
                                                                review['rating'], 
                                                                (index) => const Icon(Icons.star, size: 20, color: Colors.amber),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 40), 
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          rating = 0;   
                                                          _contentController.clear();
                                                          isContentValid = false;
                                                        });
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AddReviewDialog(
                                                              formKey: _formKey,
                                                              contentController: _contentController,
                                                              isContentValid: isContentValid,
                                                              rating: rating,
                                                              updateContentValidation: _updateContentValidation,
                                                              updateRating: (newRating) {
                                                                setState(() {
                                                                  rating = newRating;
                                                                });
                                                              },
                                                              onSubmit: () async {
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
                                                                    showCustomSnackbar(context, "Review submitted successfully!", backgroundColor: Colors.green);
                                                                  } else {
                                                                     showCustomSnackbar(context, "Failed to submit the review. Please try again.", backgroundColor: Colors.red);
                                                                  }
                                                                }
                                                              },
                                                            );
                                                          },
                                                        );
                                                        
                                                      },
                                        
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0), 
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
                                      ),
                                    ],
                                  ),
                                ),
              
                              ],
                            ),
                          )
                    ),
                  ),
                ),
              ]
            );
          }
        }
      ),
    );
  }
}
