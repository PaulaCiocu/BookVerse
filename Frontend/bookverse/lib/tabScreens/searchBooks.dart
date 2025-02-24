import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBooks extends StatefulWidget {
  final Function(String bookKey) onBookSelected;

  
  const SearchBooks({super.key, required this.onBookSelected});

  @override
  State<SearchBooks> createState() => _SearchBooksState();
}

class _SearchBooksState extends State<SearchBooks> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Title'; // Default search by Title
  List<dynamic> _books = [];

  Future<void> _searchBooks() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    String endpoint = '';
    switch (_selectedFilter) {
      case 'Title':
        endpoint = '/books/search?query=$query';
        break;
      case 'Author':
        endpoint = '/books/search/author?author=$query';
        break;
      case 'Genre':
        endpoint = '/books/searchByGenre?genre=$query';
        break;
    }

    final uri = Uri.parse('http://10.0.2.2:8080$endpoint');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        _books = json.decode(response.body);
      });
    }
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search books by $_selectedFilter',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _searchBooks,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: ['Title', 'Author', 'Genre']
                        .map((filter) => DropdownMenuItem(
                              value: filter,
                              child: Text(filter),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedFilter = value;
                        });
                      }
                    },
                
                  ),
                ],
              ),
              
              
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return ListTile(
                      title: Text(book['title'] ?? 'Unknown Title'),
                      subtitle: Text(book['author'] ?? 'Unknown Author'),
                      leading: book['coverImageUrl'] != null
                          ? Image.network(book['coverImageUrl'], width: 50, height: 75, fit: BoxFit.cover)
                          : const Icon(Icons.book),
                      onTap: () {
                        widget.onBookSelected(book['key']); // Change screen without hiding the navbar
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
