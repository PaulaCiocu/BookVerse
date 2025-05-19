import 'package:bookverse/auth_screens/login.dart';
import 'package:bookverse/custom_ui/custom_text_field.dart';
import 'package:bookverse/events/AppEvents.dart';
import 'package:bookverse/controller/userProfileController.dart';
import 'package:bookverse/custom_ui/custom_textfield.dart';
import 'package:bookverse/utils/snackbar.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:bookverse/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final String email;
  const EditProfileScreen({super.key, required this.userId,  required this.email});

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

    Future<String?> getStoredJwtToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');  
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
  

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
      extendBodyBehindAppBar:true,
     
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
       
        actions: [
          TextButton.icon(
            onPressed: () async {
              bool? logoutConfirmed = await showLogoutConfirmationDialog(context);
              if (logoutConfirmed == true) {
                await logout();
              }
            },
            icon: const Icon(Icons.logout, color: Colors.black, size: 20, weight: 6),
            label: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
      body: Stack(
        children: 
        [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/trail_background.png',
              height: 140,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          
          Padding(
          padding: const EdgeInsets.only(left: 36.0, right: 36.0, bottom: 36.0, top: 180),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Profile settings",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)
                ),
                const SizedBox(height: 30),
                 CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: validateFullName,
                    onSaved: (val) => _nameController.text = val?.trim() ?? '',
                  ),
               
                CustomTextField(
                    controller: _bioController,
                    labelText: 'Description',
                    hintText: 'Favourite quote',
                    prefixIcon:  Icon(Icons.edit),
                    validator: validateFullName,
                    onSaved: (val) => _bioController.text = val?.trim() ?? '',
                  ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Choose avatar",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                   
                      SizedBox(
                        height: 200,
                        child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, 
                          crossAxisSpacing: 10, 
                          mainAxisSpacing: 10, 
                        ),
                        itemCount: avatars.length, 
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
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                       if ((_formKey.currentState?.validate() ?? false )) {
                        if (selectedAvatar == null) {
                            showTopSnackBar(context, 'Please choose an avatar!', backgroundColor: Colors.grey.shade400,  icon: Icons.error_outline,);
                            return;
                          }
                         _formKey.currentState?.save();
                          String name = _nameController.text;
                          String bio = _bioController.text;
        
                          bool success = await UserProfileController.updateProfile(selectedAvatar!, widget.userId, name, bio);
                          if (success) {
                            AppEvents.notifyProfileUpdated();
                              showTopSnackBar(context, 'Profile updated successfully!', backgroundColor: Colors.green,  icon: Icons.check_circle_outline,);
                          } else {
                            showTopSnackBar(context, 'Failed to update profile.', backgroundColor: Colors.red.shade400,  icon: Icons.error_outline,);
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
        ]
      ),
    );
  }
}
