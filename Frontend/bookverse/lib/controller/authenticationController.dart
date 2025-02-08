import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationController {
  static Future<bool> registerUser({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8080/auth/register'); // Replace with your backend URL
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fullName': fullName,
        'email': email,
        'username': username,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Success
    } else {
      return false; // Failure
    }
  }

   static Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8080/auth/login'); // Replace with your backend URL
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Success
    } else {
      return false; // Failure
    }
    
    
  }
}
