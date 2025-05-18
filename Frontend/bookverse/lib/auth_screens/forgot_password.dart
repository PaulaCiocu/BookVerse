import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/auth_screens/login.dart';
import 'package:bookverse/custom_ui/custom_text_field.dart';
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFDCAA), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              'Forgot password',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 40,), 
            Text(
              'Please enter your email address to receive a password reset link.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
    
            const SizedBox(height: 60),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: validateEmail,
                    onSaved: (val) => _emailController.text = val?.trim() ?? '',
                  ),

                ],
              ),
            ),

            const SizedBox(height: 60,),
            GestureDetector(
              onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                       _formKey.currentState?.save();
                      String? errorMessage = await AuthenticationController.forgot_password(
                        email: _emailController.text,
                      );
        
                      if (errorMessage == null) {
                        // Success, navigate to another page
                        showCustomSnackbar(context, "Request sent successfully!");
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
              child:  Center(
                child: Text(
                  'Reset password',
                 style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            ),
            const SizedBox(height: 30,), 

            // GestureDetector(
            //   onTap: (){
            //       Navigator.push(
            //         context, 
            //         MaterialPageRoute(builder: (context) =>  const LoginPage()));
            //   },
            //   child: Container(
            //   width: 130, 
            //   height: 48,
            //   decoration: BoxDecoration(
            //     color:  Colors.white, 
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child:  Center(
            //     child: Text(
            //       'Login',
            //       style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //     ),
            //   )
            // )
          
          ],
        ),
      ),
    );
  }
}
