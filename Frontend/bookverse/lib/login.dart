import 'package:bookverse/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column( // Wrap the children in a Column widget
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image (Placeholder)
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
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD7D7DC)),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xD9FFFFFF), // rgba(255, 255, 255, 0.83)
                    ),
                    child: const TextField(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF171719),
                        height: 1.36, // Similar to line-height of 19px
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: InputBorder.none,
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),

                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14, 
                      fontFamily: 'Poppins',
                      color: Color(0xFF000000), 
                      letterSpacing: 1.2, 
                    ),
                  ),

                  const SizedBox(height: 8,),
                  // Password Input Field
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD7D7DC)),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xD9FFFFFF), // rgba(255, 255, 255, 0.83)
                    ),
                    child: const TextField(
                      obscureText: true, // For password input
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF171719),
                        height: 1.36,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: InputBorder.none,
                        hintText: 'Enter your password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
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
                              MaterialPageRoute(builder: (context) => const RegisterPage()));
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
                        onTap: () {
                          // Add your onPressed action here
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
    );
  }
}
