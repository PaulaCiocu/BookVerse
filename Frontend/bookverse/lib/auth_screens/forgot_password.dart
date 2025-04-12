import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/auth_screens/login.dart';
import 'package:bookverse/custom_ui/custom_textfield.dart';
import 'package:bookverse/validation/validation.dart';
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


  void _updateEmailValidation(String value) {
    setState(() {
      isEmailValid = validateEmail('Email') == null;
      _formKey.currentState!.validate();
    });
  }

  void showCustomSnackbar(BuildContext context, String errorMessage) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 60, 
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 335,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:  Colors.white, 
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 2),
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
                    validator: (value) => value!.isEmpty ? 'Email is required' : null,
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
