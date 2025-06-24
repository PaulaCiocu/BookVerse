import 'dart:convert';
import 'package:bookverse/controller/imageController.dart';
import 'package:bookverse/services/firebase_auth.dart';
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

    try {
      await AuthService().registerWithEmailAndPassword(email, password);
    } catch (e) {
      return 'Firebase registration error: \$e';
    }

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
 
    String idToken;
    try {
      final result = await AuthService().signInWithEmailAndPassword(email, password);
      if (result is String && result.contains("Please verify your email!")) {
        return result; // Return error string
      }
      idToken = result;
    } catch (e) {
      return 'Please verify credentials!';
    }

    // 🔐 Store Firebase token locally
    await secureStorage.write(key: 'jwt_token', value: idToken);

    // 🔐 Send token to backend instead of email/password
    //final url = Uri.parse('http://10.0.2.2:8080/auth/login');
    final url = Uri.parse('http://10.0.2.2:8080/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final personId = responseData['personId'];

        await secureStorage.write(key: 'person_id', value: personId.toString());
        return null;
      } else {
        final responseData = json.decode(response.body);
        return responseData['description'] ?? "Login failed";
      }
    } catch (e) {
      return "An error occurred. Please try again.";
    } 
  }

  static Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  static Future<String?> getUserId() async {
    return await secureStorage.read(key: 'person_id');
  }

  static Future<void> logout() async {
    await AuthService().signOut();
    await secureStorage.delete(key: 'jwt_token');
  }

  static Future<String?> forgot_password({required String email}) async {
    return await AuthService().sendPasswordResetEmail(email);
  }

}
