import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class ImageController {

  static Future<String> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('trail_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(imageFile);
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  static Future<Uint8List?> loadAssetImage(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (e) {
      print("Error loading asset image: $e");
      return null;
    }
  }
  
  static Future<String> uploadAvatar(String avatarPath) async {
    try {
      Uint8List? imageBytes = await loadAssetImage(avatarPath);
      if (imageBytes == null) {
        return 'Error loading image';
      }
      final storageRef = FirebaseStorage.instance.ref().child('avatars/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putData(imageBytes);
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
        return 'Error uploading image: $e';
    }
  }
}
