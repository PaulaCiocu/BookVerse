import 'dart:convert';
import 'package:bookverse/controller/imageController.dart';
import 'package:http/http.dart' as http;

class UserProfileController {

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

static Future<bool> updateProfile(String selectedAvatar,String id, String fullName, String bio) async {
  final url = Uri.parse('http://10.0.2.2:8080/person/edit/id/$id');
  final headers = {
    'Content-Type': 'application/json',
  };
  String? profilePictureUrl = '';
  if (selectedAvatar.isNotEmpty) {
    profilePictureUrl = await ImageController.uploadAvatar(selectedAvatar);
    print('Uploaded Image URL: $profilePictureUrl');
  }
  final body = json.encode({
    'fullName': fullName,
    'bio': bio,
    'profilePictureUrl': profilePictureUrl, 
  });
  final response = await http.put(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    return true;
  } else {
    print('Failed to update profile: ${response.body}');
    return false; 
    }
  }
}
