import 'package:bookverse/login.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
              'Please enter the email address to receive a password reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
    
            const SizedBox(height: 60),
            Column(
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

            SizedBox(height: 60,),
            GestureDetector(
              onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) =>  LoginPage()));
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
            SizedBox(height: 30,), 

            GestureDetector(
              onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) =>  LoginPage()));
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
