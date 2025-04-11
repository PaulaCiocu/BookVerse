import 'dart:convert';

import 'package:http/http.dart' as http;

class BooksController {

   static Future<Map<String, dynamic>> fetchBookDetails(String bookKey) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/books/$bookKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  static Future<List<dynamic>> fetchReadingListBooks(String userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-list/books/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load reading list');
    }
  }

  static Future<bool> checkIfBookInReadingList(String userId, String bookKey) async {
    final url = 'http://10.0.2.2:8080/reading-list/check/$userId/$bookKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
       return response.body.toLowerCase() == 'true';
    } else {
      throw Exception("Failed to check reading list status: ${response.statusCode}'");
    }
  }

  static Future<bool> addToReadingList(String userId, String bookKey) async {
    final url = 'http://10.0.2.2:8080/reading-list/add/$userId/$bookKey';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add book: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> removeBooksFromReadingList(String userId, String bookId) async {
    final url = Uri.parse('http://10.0.2.2:8080/reading-list/delete/$userId/$bookId');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print("Deleted successfully");
      return true;
    } else {
      throw Exception('Failed to delete trail: ${response.body}');
    }
  }

  static Future<List<dynamic>> searchBooks(String selectedFilter, String query) async {
    if (query.isEmpty) return [];
    String endpoint = '';
    switch (selectedFilter) {
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
       return json.decode(response.body);
    } else{
      throw Exception('Failed to fetch book: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> canBookBeDeleted(String userId, String bookId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-list/isBookNotInTrail/$userId/$bookId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load reading list');
    }
  }

  static Future<bool> updateProgress(String userId, String bookId, int newPagesRead) async {
    final url = Uri.parse(
      'http://10.0.2.2:8080/reading-list/update-progress/$userId/$bookId?pagesRead=$newPagesRead'
    );
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update progress: ${response.statusCode}');
    }
  }
}