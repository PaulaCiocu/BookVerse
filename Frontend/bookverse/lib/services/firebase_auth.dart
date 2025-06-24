

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    var cred = await _auth.signInWithEmailAndPassword(email: email, password: password);

    if (cred.user != null && !cred.user!.emailVerified) {
      await signOut(); // You don't need to create a new AuthService() here
      return 'Please verify your email before logging in.';
    }
    
    return await cred.user!.getIdToken();
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.sendEmailVerification();

    } catch (error) {
      print(error.toString());
    } 
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }


   Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  signInWithGoogle() {}
}