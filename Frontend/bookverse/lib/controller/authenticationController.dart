import 'dart:convert';
import 'package:bookverse/controller/imageController.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthenticationController {
  static  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  static Future registerUser({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required String selectedAvatar
  }) async {
    final url = Uri.parse('http://10.0.2.2:8080/auth/register'); // Replace with your backend URL
    String? profilePictureUrl = '';
    
    profilePictureUrl = await ImageController.uploadAvatar(selectedAvatar);
    print('Uploaded Image URL: $profilePictureUrl');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName,
          'email': email,
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword,
          'profilePictureUrl': profilePictureUrl
        }),
      );

      if (response.statusCode == 200) {
        return null; // Success, no error message
      } else {
        final responseData = json.decode(response.body);
        return responseData['description'] ?? "Registration failed"; // Return error message
      }
    } catch (e) {
      return "An error occurred. Please try again."; // Handle unexpected errors
    }

  }

static Future loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8080/auth/login'); // Replace with your backend URL
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final personId = responseData['personId']; // Get the user ID from the response

        // Store the token and user ID securely
        await secureStorage.write(key: 'jwt_token', value: token);
        await secureStorage.write(key: 'person_id', value: personId.toString()); // Store user ID as a string

        return null; // Success, no error message
      } else {
        final responseData = json.decode(response.body);
        return responseData['description'] ?? "Login failed"; // Return error message
      }
    } catch (e) {
      return "An error occurred. Please try again."; // Handle unexpected errors
    }
  }

  static Future forgot_password({required String email}) async {
    final url = Uri.parse('http://10.0.2.2:8080/auth/forgot-password'); // Replace with your backend URL
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        
        return null; // Success, no error message
      } else {
        final responseData = json.decode(response.body);
        return responseData['description'] ?? "Email sending failed"; // Return error message
      }
    } catch (e) {
      return "An error occurred. Please try again."; // Handle unexpected errors
    }

  }

  static Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  static Future<String?> getUserId() async {
    return await secureStorage.read(key: 'person_id');
  }

  static Future<void> logout() async {
    await secureStorage.delete(key: 'jwt_token');
  }
}
