import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static Future<String> SignIn(String email, String password) async {
    String result = "";
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      result = "Signed In";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = 'No user found linked to this email.';
      } else if (e.code == 'wrong-password') {
        result = 'Wrong password provided for this user.';
      }
    }
    return result;
  }
  static Future<String> SignUp() async {
    return "true";
  }
}