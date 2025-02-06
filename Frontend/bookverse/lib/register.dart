import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60,),
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
                const SizedBox(height: 40,),
                
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //name
                      const Text(
                        'Enter your full name',
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w500, 
                          color: Color(0xFF080a0b), 
                          letterSpacing: 1.2, 
                        ),
                      ),
                      const SizedBox(height: 8,),
                      // Full naem Input Field
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD7D7DC)),
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xD9FFFFFF), // rgba(255, 255, 255, 0.83)
                        ),
                        child: const TextField(
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF171719),
                            height: 1.36, 
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: InputBorder.none,
                            hintText: 'Full Name',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
          
                      //email
                      const Text(
                        'Enter your e-mail address',
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w500, 
                          color: Color(0xFF080a0b), 
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
                            fontSize: 14,
                            color: Color(0xFF171719),
                            height: 1.36, // Similar to line-height of 19px
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: InputBorder.none,
                            hintText: 'email@email.com',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
          
                      //username
                      const Text(
                        'Choose a username',
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w500, 
                          color: Color(0xFF080a0b), 
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
                            fontSize: 14,
                            color: Color(0xFF171719),
                            height: 1.36, // Similar to line-height of 19px
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: InputBorder.none,
                            hintText: 'username123',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
          
                      //password
                      const Text(
                        'Set up your password',
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w500, 
                          color: Color(0xFF080a0b), 
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
                            hintText: '*********',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      
                      //confirm password
                      const Text(
                        'Repeat password',
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w500, 
                          color: Color(0xFF080a0b), 
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
                            hintText: '*********',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                  
                    ],
                  ),
                ),
          
                GestureDetector(
                  onTap: () {
                    // Add your action here
                  },
                  child: Container(
                    width: 335,
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFFFDCAA), // #ffdcaa
                    ),
                    child: const Center(
                      child: Text(
                        'Join Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.black, // #000000
                          height: 1.3, // Approximate line-height: 21px / 16px
                        ),
                      ),
                    ),
                  ),
                )
          
              ],
            )
          ),
        ),
      ),
    );
  }
}