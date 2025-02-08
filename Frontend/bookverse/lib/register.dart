import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/controller/registrationSuccessPage.dart';
import 'package:bookverse/login.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // Validation state variables for each field
  bool isFullNameValid = false;
  bool isEmailValid = false;
  bool isUsernameValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;
  // This function is used to build TextFields with validation
  // Widget buildTextField({
  //   required TextEditingController controller,
  //   required bool isObscure,
  //   required String hintText,
  //   required String? Function(String?) validator,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     obscureText: isObscure,
  //     style: const TextStyle(
  //       fontSize: 14,
  //       color: Color(0xFF171719),
  //       height: 1.36,
  //     ),
  //     decoration: InputDecoration(
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
  //       hintText: hintText,
  //       filled: true,
  //       fillColor: const Color(0xD9FFFFFF),
  //       border: OutlineInputBorder(
  //         borderSide: BorderSide(
  //           color: controller.text.isEmpty
  //               ? const Color(0xFFD7D7DC)
  //               : Colors.green, // Green or default grey border
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderSide: const BorderSide(color: Colors.red),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(
  //           color: controller.text.isEmpty
  //               ? const Color(0xFFD7D7DC)
  //               : Colors.green, // Green when validation is successful
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //     ),
  //     validator: validator,
  //   );
  // }
  // Update TextField widget
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

  // Update the validation state when text changes
  void _updateFullNameValidation(String value) {
    setState(() {
      isFullNameValid = validateFullName(value) == null;
    });
  }
  void _updateEmailValidation(String value) {
    setState(() {
      isEmailValid = validateEmail(value) == null;
    });
  }

  void _updateUsernameValidation(String value) {
    setState(() {
      isUsernameValid = validateUsername(value) == null;
    });
  }

  void _updatePasswordValidation(String value) {
    setState(() {
      isPasswordValid = validatePassword(value) == null;
    });
  }

  void _updateConfirmPasswordValidation(String value) {
    setState(() {
      isConfirmPasswordValid = validateConfirmPassword(value) == null;
    });
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return 'Enter a valid name (letters and spaces only)';
    }
    if (value.trim().length < 2 || value.trim().length > 50) {
      return 'Name must be between 2 and 50 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 2 || value.trim().length > 50) {
      return 'Username must be between 2 and 50 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    String passwordRegex =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
    if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'Password must contain at least 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character';
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
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
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          validator: validateEmail,
                          isValid: isEmailValid,
                          onChanged: _updateEmailValidation,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Choose a username',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF080a0b),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          controller: _usernameController,
                          isObscure: false,
                          hintText: 'username123',
                          validator: validateUsername,
                          isValid: isUsernameValid,
                          onChanged: _updateUsernameValidation,
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
                    if (_formKey.currentState?.validate() ?? false) {
                      // If the form is valid, send the data to the backend
                      final bool isRegistered = await AuthenticationController.registerUser(
                        fullName: _fullNameController.text,
                        email: _emailController.text,
                        username: _usernameController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      );

                      if (isRegistered) {
                        // Show success message or navigate to another page
                        print("Registration succesfull!");
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const RegistrationSuccessPage())
                      );
                        
                        // You can navigate to another screen here, if needed
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration failed, please try again.')),
                        );
                      }
                    } else {
                      // If the form is not valid, show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields correctly')),
                      );
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
                          fontFamily: 'Poppins',
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
                            MaterialPageRoute(builder: (context) => LoginPage()));
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
