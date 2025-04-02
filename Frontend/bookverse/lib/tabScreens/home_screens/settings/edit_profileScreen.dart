import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final String userEmail;
  const EditProfileScreen({super.key, required this.userEmail});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final List<String> avatars = [
  'assets/avatars/avatar_woman.png',
  'assets/avatars/avatar2.png',
  'assets/avatars/avatar3.png',
  'assets/avatars/avatar4.png',
  'assets/avatars/avatar5.png',
  'assets/avatars/avatar6.png',
  'assets/avatars/avatar7.png',
  'assets/avatars/avatar8.png',
  'assets/avatars/avatar9.png',
  'assets/avatars/avatar10.png',
  'assets/avatars/avatar11.png',
  'assets/avatars/avatar12.png',
];
  
  bool isNameValid = false;
  bool isBioValid = false;
  String? selectedAvatar;

 Widget buildTextField({
    required TextEditingController controller,
    required bool isObscure,
    required String hintText,
    required String? Function(String?) validator,
    required bool isValid,
    required void Function(String) onChanged,
    int maxLines = 1,
    double minHeight = 50,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, color: Color(0xFF171719), height: 1.36),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: isValid ? Colors.green : Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isValid ? Colors.green : const Color(0xFFD7D7DC)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isValid ? Colors.green : const Color(0xFFD7D7DC)),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  void _updateNameValidation(String value) {
    setState(() {
      isNameValid = validateName(value) == null;
    });
  }

  void _updateBioValidation(String value) {
    setState(() {
      isBioValid = validateBio(value) == null;
    });
  }

    String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    return null;
  }
  
// Function to load image from assets as bytes
  Future<Uint8List?> loadAssetImage(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (e) {
      print("Error loading asset image: $e");
      return null;
    }
  }
 Future<String> uploadAvatar(String avatarPath) async {
    try {
      // Load the image as bytes
      Uint8List? imageBytes = await loadAssetImage(avatarPath);
      if (imageBytes == null) {
        return 'Error loading image';
      }

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('avatars/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file
      await storageRef.putData(imageBytes);

      // Get the image URL
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return 'Error uploading image';
    }
  }

  // Fetch user profile data on screen load
  Future<void> _fetchUserData() async {
    final url = Uri.parse('http://10.0.2.2:8080/person/${widget.userEmail}');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Set the initial values of the profile fields
        setState(() {
          _nameController.text = data['fullName'] ?? '';
          _bioController.text = data['bio'] ?? '';
          // selectedAvatar = data['profilePictureUrl'] ?? '';
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

   @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function to load data when the screen is loaded
  }

 Future<bool> updateProfile(String fullName, String bio) async {
  final url = Uri.parse('http://10.0.2.2:8080/person/edit/${widget.userEmail}');
  final headers = {
    'Content-Type': 'application/json',
  };

  String? profilePictureUrl = ''; // Default to empty string if no avatar selected
  if (selectedAvatar!=null && selectedAvatar!.isNotEmpty) {
    // If an avatar is selected, upload it and get the URL
    profilePictureUrl = await uploadAvatar(selectedAvatar!);
    print('Uploaded Image URL: $profilePictureUrl');
  }
  
  // Prepare the request body
  final body = json.encode({
    'fullName': fullName,
    'bio': bio,
    'profilePictureUrl': profilePictureUrl, // Send empty string if no avatar selected
  });

  // Send the PUT request to update the profile
  final response = await http.put(url, headers: headers, body: body);

  // Check the response status to confirm the update
  if (response.statusCode == 200) {
    return true; // Profile update successful
  } else {
    print('Failed to update profile: ${response.body}');
    return false; // Profile update failed
  }
}


  void _selectAvatar(String avatarPath) async {
    setState(() {
      selectedAvatar = avatarPath;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Edit profile",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20, // Slightly larger text for readability
          color: Colors.black87, // Text color
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA), // Set AppBar background color
      elevation: 0, // Remove shadow for a clean look
    ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
               buildTextField(
                controller: _nameController,
                isObscure: false,
                hintText: 'Name',
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
                isValid: isNameValid,
                onChanged: _updateNameValidation
              ),
              const SizedBox(height: 20),
              const Text(
                "Bio",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
               buildTextField(
                controller: _bioController,
                isObscure: false,
                hintText: 'Quote',
                validator: (value) => value!.isEmpty ? 'Bio is required' : null,
                isValid: isBioValid,
                onChanged: _updateBioValidation
              ),
              const SizedBox(height: 20),
              const Text(
                "Choose avatar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
             const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,  // Number of columns
                    crossAxisSpacing: 10,  // Horizontal space between items
                    mainAxisSpacing: 10,  // Vertical space between items
                  ),
                  itemCount: avatars.length,  // Number of items in the grid
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _selectAvatar(avatars[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedAvatar == avatars[index] 
                              ? const Color(0xFFFFDCAA) : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 3,
                              //offset: Offset(0, 4),
                            ),
                          ],
                          color: selectedAvatar == avatars[index] 
                              ? const Color(0xFFFFDCAA)
                              : Colors.transparent,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            avatars[index],
                            fit: BoxFit.cover,  
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

    
              Center(
                child: GestureDetector(
                  onTap: () async {
                     if ((_formKey.currentState?.validate() ?? false )) {
                        String name = _nameController.text;
                        String bio = _bioController.text;

                        bool success = await updateProfile(name, bio);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile.')));
                        }

                    } else {
                      //If any condition fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields.')),
                      );
                
                    }
                  },

                  child: Container(
                    width: 120, 
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDCAA),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16, 
                          color: Colors.black87, 
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
