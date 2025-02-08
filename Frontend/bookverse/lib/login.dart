import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/forgot_password.dart';
import 'package:bookverse/home.dart';
import 'package:bookverse/register.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  void _updatePasswordValidation(String value) {
    setState(() {
      isPasswordValid = validatePassword(value) == null;
    });
  }
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column( // Wrap the children in a Column widget
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image (Placeholder)
                const SizedBox(height: 40,),
                
                Image.asset(
                  'assets/login_image.jpeg', // Add your image in assets folder
                  height: 220,
                  width: 220,
                  fit: BoxFit.cover,
                ),
          
                const SizedBox(height: 20),
          
                const Text(
                  'BookVerse',
                  style: TextStyle(
                    fontSize: 40, 
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600, 
                    color: Color(0xFF030303), 
                    letterSpacing: 1.2, 
                  ),
                ),
          
                const SizedBox(height: 20),
          
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14, 
                          fontFamily: 'Poppins',
                          color: Color(0xFF030303), 
                          letterSpacing: 1.2, 
                        ),
                      ),
                      const SizedBox(height: 8,),
                      // Email Input Field
                      buildTextField(
                              controller: _emailController,
                              isObscure: false,
                              hintText: 'Enter your email',
                              validator: validateEmail,
                              isValid: isEmailValid,
                              onChanged: _updateEmailValidation,
                            ),
                      const SizedBox(height: 20,),
          
                      Row(
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14, 
                              fontFamily: 'Poppins',
                              color: Color(0xFF000000), 
                              letterSpacing: 1.2, 
                            ),
                          ),

                          const SizedBox(width: 80,),
                          
                          GestureDetector(
                            onTap: (){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) =>  ForgotPasswordPage()));
                            },
                            child: const Text(
                              'Forgot your passsword?',
                              style: TextStyle(
                                fontSize: 14, 
                                fontFamily: 'Poppins',
                                color: Color(0xFF000000), 
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2, 
                                decoration: TextDecoration.underline
                              ),
                            ),
                          )
                        ],
                      ),
          
                      const SizedBox(height: 8,),
                      // Password Input Field
                      buildTextField(
                        controller: _passwordController,
                        isObscure: true,
                        hintText: 'Enter your password',
                        validator: validatePassword,
                        isValid: isPasswordValid,
                        onChanged: _updatePasswordValidation,
                      ),
                      
                      const SizedBox(height: 30,),
                      Row(
                        children: [
                          const Text(
                            "Don't have an account ?",
                            style: TextStyle(
                              fontSize: 14, 
                              fontFamily: 'Poppins',
                              color: Color(0xFF000000), 
                              letterSpacing: 1.2, 
                            ),
                          ),
          
                          const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: (){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) =>  RegisterPage()));
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 14, 
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000), 
                                letterSpacing: 1.2, 
                                decoration: TextDecoration.underline
                              ),
                            ),
                          )
          
                          
                        ],
                      ),
          
                     
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 160.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Explore reading paths",
                            style: TextStyle(
                              fontSize: 12, 
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400, 
                              color: Color(0xFF000000), 
                              letterSpacing: 1.2, 
                            ),
                          ),
                          const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: () async {
                           //   if (_formKey.currentState?.validate() ?? false) {
                                // If the form is valid, send the data to the backend
                                final bool isLoggedIn = await AuthenticationController.loginUser(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                if (isLoggedIn) {
                                  // Show success message or navigate to another page
                                  print("Login succesfull!");
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) =>  HomePage())
                                );
                                  
                                  // You can navigate to another screen here, if needed
                                } else {
                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registration failed, please try again.')),
                                  );
                                }
                              // } else {
                              //   // If the form is not valid, show an error message
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text('Please fill in all fields correctly')),
                              //   );
                              // }
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDCAA), // #ffdcaa
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward, // Choose your desired icon here
                                  color: Colors.black, // #000000
                                  size: 18, // 18px width and height
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  
                      // Custom button with icon
                      
                    ],
                  ),
                ),
          
              ],    
            ),
          ),
        ),
      ),
    );
  }
}
