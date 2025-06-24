import 'dart:convert';

import 'package:http/http.dart' as http;

class AchievmentsController {
  static Future<Map<String, dynamic>> fetchAchievements(String userId) async {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/achievements/person/$userId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load achievements');
      }
  }
}

