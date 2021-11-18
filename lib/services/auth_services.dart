import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pwot/models/authDataModel.dart';
import 'package:pwot/models/userModel.dart';

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

  static Future<AuthData> SignUp(String email, String password, String displayName, String contact) async {
    late AuthData data;
    String message = "null";
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    User? user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      user = userCredential.user!;
      usersRef.doc(user.uid).set({
        'uid': user.uid,
        'admin': true,
        'contact': contact
      });
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


  static Future<UserModel> getUserModel(String id) async {
    List<UserModel> users = [];
    UserModel user;
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      value.docs.forEach((element) {
        UserModel userModel = UserModel.fromJson(element.data());
        userModel.uid = element.id;
        users.add(userModel);
      });
    });

    user = UserModel(uid: id, admin: false, contact: "Not available");
    if (users.isNotEmpty) {
      users.forEach((element) {
        if (element.uid == id && element.admin == true) {
          user = element;
        }
      });
    }

    print(FirebaseAuth.instance.currentUser!.displayName);
    return user;
  }
}