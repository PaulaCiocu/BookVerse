import 'package:bookverse/controller/AppEvents.dart';
import 'package:bookverse/controller/userProfileController.dart';
import 'package:bookverse/custom_ui/custom_textfield.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final String email;
  const EditProfileScreen({super.key, required this.userId, re, required this.email});

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

  void _updateNameValidation(String value) {
    setState(() {
      isNameValid = validateField(value, 'Name') == null;
      _formKey.currentState!.validate(); 
    });
  }

  void _updateBioValidation(String value) {
    setState(() {
      isBioValid = validateField(value, 'Quote') == null;
      _formKey.currentState!.validate(); 
    });
  }

  Future<void> _fetchUserData() async {
    final data = await UserProfileController.fetchUserProfileById(widget.userId);
    setState(() {
      _nameController.text = data['fullName'] ?? '';
      _bioController.text = data['bio'] ?? '';
    });
      
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); 
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
          fontSize: 20, 
          color: Colors.black87, 
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA), 
      elevation: 0, 
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
                validator: (value) => value!.isEmpty ? 'Quote is required' : null,
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

                        bool success = await UserProfileController.updateProfile(selectedAvatar!, widget.email, name, bio);
                        if (success) {
                          AppEvents.notifyProfileUpdated();
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
