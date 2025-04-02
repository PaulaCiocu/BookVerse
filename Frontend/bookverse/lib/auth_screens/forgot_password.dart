import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/auth_screens/login.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

    bool isEmailValid = false;
  bool isPasswordValid = false;

  Widget buildTextField({
    required TextEditingController controller,
    required bool isObscure,
    required String hintText,
    required String? Function(String?) validator,
    required bool isValid,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(fontSize: 14, color: Color(0xFF171719), height: 1.36),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xD9FFFFFF),
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
    );
  }

  void _updateEmailValidation(String value) {
    setState(() {
      isEmailValid = validateEmail(value) == null;
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
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
      body:  Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Forgot you password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 80,), 
            const Text(
              'Please enter your email address to receive a password reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
    
            const SizedBox(height: 60),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter email address',
                    style: TextStyle(
                      fontSize: 14, 
                      fontFamily: 'Poppins',
                      color: Color(0xFF030303), 
                      letterSpacing: 1.2, 
                    ),
                  ),
                  const SizedBox(height: 12,),
                  // Email Input Field
                  buildTextField(
                    controller: _emailController,
                    isObscure: false,
                    hintText: 'Enter your email',
                    validator: validateEmail,
                    isValid: isEmailValid,
                    onChanged: _updateEmailValidation,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60,),
            GestureDetector(
              onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                  
                      String? errorMessage = await AuthenticationController.forgot_password(
                        email: _emailController.text,
                      );
        
                      if (errorMessage == null) {
                        // Success, navigate to another page
                        showCustomSnackbar(context, "Email sent successfully!");
                      } else {
                        // Show error message in a SnackBar
                        showCustomSnackbar(context, errorMessage);
        
                      }
                    }
              },
              child: Container(
              width: 250, 
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFDCAA), 
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Request reset password link',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    ),
                  ),
                ),
              )
            ),
            const SizedBox(height: 30,), 

            GestureDetector(
              onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) =>  const LoginPage()));
              },
              child: Container(
              width: 130, 
              height: 48,
              decoration: BoxDecoration(
                color:  Colors.white, 
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Back To Login',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    ),
                  ),
                ),
              )
            )
          
          ],
        ),
      ),
    );
  }
}
