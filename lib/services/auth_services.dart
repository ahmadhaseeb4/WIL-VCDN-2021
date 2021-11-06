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
      } else if (e.code == "invalid-email"){
        result = "Invalid email provided";
      }
    }
    return result;
  }
  static Future<String> SignUp(String email, String password, String displayName) async {
    String result = "";
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User user = userCredential.user!;
      result = "Signed Up";
      await user.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        result = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        result = 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    return result;
  }
}