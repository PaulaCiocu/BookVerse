import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/tabScreens/auth_screens/forgot_password.dart';
import 'package:bookverse/custom_ui/custom_text_field.dart';
import 'package:bookverse/home.dart';
import 'package:bookverse/tabScreens/auth_screens/register.dart';
import 'package:bookverse/utils/snackbar.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _jwtToken = '';
  bool _obscurePassword = true;
 
  bool isPasswordValid = false;


  Future<void> storeJwtToken(String token, String userId, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('user_id', userId);
    await prefs.setString('user_email', email);
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
                const SizedBox(height: 40,),
                Image.asset(
                  'assets/login_image.jpeg', 
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
                        CustomTextField(
                            labelText: 'Email',
                            hintText: 'Enter your email address',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: validateEmail,
                            onSaved: (val) => _emailController.text = val?.trim() ?? '',
                          ),

                        CustomTextField(
                            labelText: 'Password',
                            hintText: 'Enter your password',
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
                      
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) =>  const ForgotPasswordPage()));
                          },
                          child:  Text(
                            'Forgot your passsword?',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline
                            )
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
               
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color(0xFFFFDCAA),  
                    foregroundColor: Colors.black87, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      String? errorMessage = await AuthenticationController.loginUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (errorMessage == null) {
                        final token = await AuthenticationController.getToken();
                        final userId = await AuthenticationController.getUserId();
                        
                        if (token != null && userId!= null) {
                          await storeJwtToken(token, userId, _emailController.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home(token: token, userEmail: _emailController.text, userId: userId)), // Passing token to HomePage
                          );
                        } else {
                          showCustomSnackbar(context, "Failed to retrieve token");
                        }
                      } else {
                        showCustomSnackbar(context, errorMessage);
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) =>  const RegisterPage()));
                      },
                      child: Text(
                        "Sign up",
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
