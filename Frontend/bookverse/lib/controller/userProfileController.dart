import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfilecontroller {

  Future<Map<String, dynamic>> fetchUserProfileByEmail(String userEmail) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/person/$userEmail'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<Map<String, dynamic>> fetchUserProfileById(String userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/person/personId/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
