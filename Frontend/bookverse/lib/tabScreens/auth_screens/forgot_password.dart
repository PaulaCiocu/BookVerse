import 'package:bookverse/controller/authenticationController.dart';
import 'package:bookverse/custom_ui/custom_text_field.dart';
import 'package:bookverse/utils/snackbar.dart';
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
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60,), 
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
                      showCustomSnackbar(context, "Request sent successfully!");
                    } else {
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
            ],
          ),
        ),
      ),
    );
  }
}
