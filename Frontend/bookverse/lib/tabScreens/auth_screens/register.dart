import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/controller/registrationSuccessPage.dart';
import 'package:bookverse/tabScreens/auth_screens/login.dart';
import 'package:bookverse/custom_ui/custom_text_field.dart';
import 'package:bookverse/utils/snackbar.dart';
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
  bool _obscurePassword = true;
  void _selectAvatar(String avatarPath) async {
    setState(() {
      _selectedAvatar = avatarPath;
    });
  }
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    print('password');
    print(_passwordController.text);
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Sign up',
                   style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your BookVerse account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
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
                  
                        CustomTextField(
                          controller: _fullNameController,
                          labelText: 'Full Name',
                          hintText: 'Enter your name',
                          keyboardType: TextInputType.name,
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: validateFullName,
                          onSaved: (val) => _fullNameController.text = val?.trim() ?? '',
                        ),

                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: validateEmail,
                          onSaved: (val) => _emailController.text = val?.trim() ?? '',
                        ),

                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          hintText: 'Choose a strong password',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword 
                                  ? Icons.visibility_outlined 
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: validatePassword,
                          onSaved: (val) => _passwordController.text = val?.trim() ?? '',
                        ),
                    
                        CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Repeat Password',
                          hintText: 'Passwords must match',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword 
                                  ? Icons.visibility_outlined 
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: validateConfirmPassword,
                          onSaved: (val) => _confirmPasswordController.text = val?.trim() ?? '',
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose avatar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                            ],
                          ),
                        ),
                    
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if ( (_formKey.currentState?.validate() ?? false) && _selectedAvatar.isNotEmpty) {
                      _formKey.currentState?.save();
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
                    Text(
                      "Already have an account ?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                      child:  Text(
                        "Login",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
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
