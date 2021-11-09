import 'package:firebase_auth/firebase_auth.dart';
import 'package:pwot/models/authDataModel.dart';

class AuthServices {
  static Future<AuthData> SignIn(String email, String password) async {
    late AuthData data;
    String message = "null";
    User? user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      user = userCredential.user!;
      message = "Signed In";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found linked to this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for this user.';
      } else if (e.code == "invalid-email"){
        message = "Invalid email provided";
      }
    }
    data = AuthData(user: user, message: message);
    return data;
  }
  static Future<AuthData> SignUp(String email, String password, String displayName) async {
    late AuthData data;
    String message = "nul";
    User? user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      user = userCredential.user!;
      await user.updateDisplayName(displayName);
      message = "Signed Up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }

    data = AuthData(user: user, message: message);
    return data;
  }
}