
import 'package:bookverse/controller/booksController.dart';
import 'package:flutter/material.dart';

class SearchBooks extends StatefulWidget {
  final Function(String bookKey) onBookSelected;
  
  const SearchBooks({super.key, required this.onBookSelected});

  @override
  State<SearchBooks> createState() => _SearchBooksState();
}

class _SearchBooksState extends State<SearchBooks> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Title';
  List<dynamic> _books = [];

  Future<void> _searchBooks() async {
    final query = _searchController.text.trim();
    final bookList = await BooksController.searchBooks(_selectedFilter, query);
    setState(() {
         _books = bookList;
      });
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                 children: [
                   // Search TextField
                   Expanded(
                     child: Container(
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
                           contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                           hintText: 'Search books by $_selectedFilter',
                           border: InputBorder.none,
                           suffixIcon: IconButton(
                             icon: const Icon(Icons.search),
                             onPressed: _searchBooks,
                           ),
                         ),
                       ),
                     ),
                   ),
                    const SizedBox(width: 12,),
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        setState(() {
                          _selectedFilter = value; 
                        });
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "Title", child: Text("Title")),
                        const PopupMenuItem(value: "Author", child: Text("Author")),
                        const PopupMenuItem(value: "Genre", child: Text("Genre")),
                      ],
                      icon: const Icon(Icons.filter_list),
                    ),
                 ],
               ),
             ),
              
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        return ListTile(
                          title: Text(book['title'] ?? 'Unknown Title'),
                          subtitle: Text(book['author'] ?? 'Unknown Author'),
                          leading: book['coverImageUrl'] != null
                            ? ClipOval(
                                child: Image.network(
                                  book['coverImageUrl'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0), 
                                child: const Icon(
                                  Icons.book,
                                  size: 50,
                                ),
                              ),
                          onTap: () {
                            widget.onBookSelected(book['key']); 
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
