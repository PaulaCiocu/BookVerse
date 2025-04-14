import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/controller/registrationSuccessPage.dart';
import 'package:bookverse/auth_screens/login.dart';
import 'package:bookverse/custom_ui/custom_textfield.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  String _selectedAvatar='';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isFullNameValid = false;
  bool isEmailValid = false;
  bool isUsernameValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;

  void _selectAvatar(String avatarPath) async {
    setState(() {
      _selectedAvatar = avatarPath;
    });
  }

  void _updateFullNameValidation(String value) {
    setState(() {
      isFullNameValid = validateFullName(value) == null;
    });
  }
  void _updateEmailValidation(String value) {
    setState(() {
      isEmailValid = validateEmail(value) == null;
      _formKey.currentState!.validate(); 
    });
  }
  void _updatePasswordValidation(String value) {
    setState(() {
      isPasswordValid = validatePassword(value) == null;
      _formKey.currentState!.validate(); 
    });
  }

  void _updateConfirmPasswordValidation(String value) {
    setState(() {
      isConfirmPasswordValid = validateConfirmPassword(value) == null;
    });
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void showCustomSnackbar(BuildContext context, String errorMessage) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60, // Adjust the distance from the top
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 335,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:  Colors.white, // Match button color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay
    overlay.insert(overlayEntry);

    // Remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF030303),
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  'Join the Bookeverse community',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5d5d5b),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose your avatar:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF080a0b),
                            letterSpacing: 1.2,
                          ),
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
                                      color: _selectedAvatar == avatars[index] 
                                        ? const Color(0xFFFFDCAA) : Colors.transparent,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        blurRadius: 3,
                                      ),
                                    ],
                                    color: _selectedAvatar == avatars[index] 
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
                        SizedBox(height: 20,),      
                        const Text(
                          'Enter your full name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF080a0b),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          controller: _fullNameController,
                          isObscure: false,
                          hintText: 'Full Name',
                          validator: validateFullName,
                          isValid: isFullNameValid,
                          onChanged: _updateFullNameValidation,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Enter your e-mail address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF080a0b),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          controller: _emailController,
                          isObscure: false,
                          hintText: 'email@email.com',
                          validator: (value) => value!.isEmpty ? 'Email is required' : null,
                          isValid: isEmailValid,
                          onChanged: _updateEmailValidation,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Set up your password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF080a0b),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          controller: _passwordController,
                          isObscure: true,
                          hintText: '**********',
                          validator: validatePassword,
                          isValid: isPasswordValid,
                          onChanged: _updatePasswordValidation,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Repeat password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF080a0b),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          controller: _confirmPasswordController,
                          isObscure: true,
                          hintText: '**********',
                          validator: validateConfirmPassword,
                          isValid: isConfirmPasswordValid,
                          onChanged: _updateConfirmPasswordValidation,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if ( _selectedAvatar.isNotEmpty && (_formKey.currentState?.validate() ?? false)) {
                       String? errorMessage = await AuthenticationController.registerUser(
                        fullName: _fullNameController.text,
                        email: _emailController.text,
                        username: _usernameController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                        selectedAvatar: _selectedAvatar
                      );
            
                        if (errorMessage == null) {
                           Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const RegistrationSuccessPage())
                          );
                        } else {
                          showCustomSnackbar(context, errorMessage);
                        }
                     
                     }
                  },
                  child: Container(
                    width: 335,
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFFFDCAA),
                    ),
                    child: const Center(
                      child: Text(
                        'Join Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account ?",
                      style: TextStyle(
                        fontSize: 14, 
                        color: Color(0xFF000000), 
                        letterSpacing: 1.2, 
                      ),
                    ),
            
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000), 
                          letterSpacing: 1.2, 
                          decoration: TextDecoration.underline
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
