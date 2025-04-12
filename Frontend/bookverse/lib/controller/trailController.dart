import 'dart:convert';
import 'dart:io';

import 'package:bookverse/controller/imageController.dart';
import 'package:http/http.dart' as http;

class TrailController {

  static Future<bool> createReadingTrail(String userId, File selectedImage, String title, String description, List books) async {
    final url = Uri.parse('http://10.0.2.2:8080/trails/create');
    String? imageUrl = await ImageController.uploadImage(selectedImage);
    print(imageUrl);
    final Map<String, dynamic> payload = {
      'title': title,
      'description': description,
      'creatorId': userId,
      'books': books.map((book) => {'bookKey': book}).toList(),
      'imageUrl': imageUrl,  
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );
      if (response.statusCode == 201) {
        print('Trail created successfully');
        final int trailId = int.parse(response.body);
        TrailController.addToReadingListTrailCreated(userId, trailId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<dynamic>> fetchTrailsExcept({String? genre, String? author, String? bookTitle, String? trailName, required String userId }) async {
    final Map<String, String> queryParams = {};
    if (genre != null && genre.isNotEmpty) {
      queryParams['genre'] = genre;
    } else if (author != null && author.isNotEmpty) {
      queryParams['author'] = author;
    } else if (bookTitle != null && bookTitle.isNotEmpty) {
      queryParams['bookTitle'] = bookTitle;
    } else if (trailName != null && trailName.isNotEmpty) {
      queryParams['trailName'] = trailName;
    }
    Uri uri = Uri.parse('http://10.0.2.2:8080/trails/except/person/$userId')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData;
        
    } else {
      throw Exception('Failed to load trails. Status code: ${response.statusCode}');
    }
  }


  static Future<Map<String, dynamic>> fetchTrailDetails(String trailId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/trails/$trailId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load trail details');
    }
  }

  static Future<List<dynamic>> fetchTrails(String userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-trails/person/$userId'));
    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
      
      throw Exception('Failed to load trails');
    }
  }

  static Future<bool> checkIfTrailInReadingList(String userId, String trailId) async {
    final url = 'http://10.0.2.2:8080/reading-trails/exists/$userId/$trailId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body.toLowerCase() == 'true';
    
    } else {
      throw Exception('Failed to check reading list status: ${response.statusCode}');
    }
  }

  static Future<bool> addToReadingList(String userId, String trailId) async {
    final url = 'http://10.0.2.2:8080/reading-trails/add/$userId/$trailId/FOLLOWED';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add book: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> addToReadingListTrailCreated(String userId, int trailId) async {
    final url = 'http://10.0.2.2:8080/reading-trails/add/$userId/$trailId/CREATED';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add book: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<List<dynamic>> fetchTrailsCreated(String userId) async {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-trails/created/person/$userId'));
      if (response.statusCode == 200) {
         return json.decode(response.body); 
      } else {
        throw Exception('Failed to load trails');
      }
  }

  static Future<List<dynamic>> fetchTrailsFollowed(String userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-trails/followed/person/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load trails');
    }
  }


  static Future<bool> unfollowTrailFromReadingList(String userId, String trailId, bool keepBooksConfirmed) async {
    final url = Uri.parse('http://10.0.2.2:8080/reading-trails/delete/$userId/$trailId/$keepBooksConfirmed');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print("Deleted successfully");
      return true;
    } else {
      throw Exception('Failed to delete trail: ${response.body}');
    }
  }

  static Future<bool> deleteCreatedTrail(String userId,String trailId, bool keepBooksConfirmed) async {
    final url = Uri.parse('http://10.0.2.2:8080/trails/delete/$trailId/$userId/$keepBooksConfirmed');
    final response = await http.delete(url);
    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted successfully");
      return true;
    } else {
      throw Exception('Failed to delete trail: ${response.body}');
    }
  }

  static Future<bool> updateTrail(String userId, String trailId, String title, String description, List bookIds, String imageUrl) async {
    final url = Uri.parse('http://10.0.2.2:8080/trails/$trailId');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'title': title,
      'description': description,
      'creatorId': userId,
      'books': bookIds.map((book) => {'bookKey': book}).toList(),
      'imageUrl': imageUrl, 
    });
    
    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}
