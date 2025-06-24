import 'dart:convert';

import 'package:http/http.dart' as http;

class ReviewController {

  static Future<bool> createReview({
    required String bookKey, 
    required String userId, 
    required int rating,
    required String content,
  }) async {
    final url = Uri.parse(
      'http://10.0.2.2:8080/api/reviews/create/$bookKey/$userId?content=$content&rating=$rating',
    );
   
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Review created successfully');
      return true;
    } else {
      throw Exception('Failed to create review: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchReviews(String bookKey) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/reviews/book/$bookKey'));
    if (response.statusCode == 200) {
        return json.decode(response.body);
    }
    else{
      throw Exception('Failed to fetch review: ${response.statusCode}');
    }
  }
}