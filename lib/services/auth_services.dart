import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pwot/models/authDataModel.dart';
import 'package:pwot/models/userModel.dart';

class AuthServices {
  static late AuthCredential _AuthCredentials;

  static Future<AuthData> SignIn(String email, String password) async {
    late AuthData data;
    String message = "null";
    User? user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      _AuthCredentials = EmailAuthProvider.credential(email: email, password: password);
      user = userCredential.user!;
      _AuthCredentials = EmailAuthProvider.credential(email: email, password: password);
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

  static Future<AuthData> SignUp(String email, String password, String displayName, String contact, String userCode) async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    late AuthData data;
    String message = "null";
    String? code;
    User? user;

    QuerySnapshot<Map<String, dynamic>> codeFuture = await FirebaseFirestore.instance.collection('code').get();
    code = codeFuture.docs.first.data()['code'];


    if (userCode.isEmpty){
      print("The code is empty so I am registering the user as General");
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        user = userCredential.user!;
        usersRef.doc(user.uid).set({
          'admin': false,
          'contact': contact,
          'name': displayName,
          'pic': '',
          'uid': user.uid
        });
        await user.updateDisplayName(displayName);
        _AuthCredentials = EmailAuthProvider.credential(email: email, password: password);
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
    }
    else if (code == userCode) {
      print("The code is verified so I am registering the user as Admin");
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        user = userCredential.user!;
        usersRef.doc(user.uid).set({
          'admin': true,
          'contact': contact,
          'name': displayName,
          'pic': '',
          'uid': user.uid
        });
        await user.updateDisplayName(displayName);
        _AuthCredentials = EmailAuthProvider.credential(email: email, password: password);
        message = "Signed Up! Admin";

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
    }
    else if (code == null || code != userCode) {
      print("Code error");
      message = "The code you entered is invalid";
    }

    print("Data being sent it -> ${data.message}");
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

    user = UserModel(uid: id, admin: false, contact: "Not available", pic: "", name: 'Not available');
    if (users.isNotEmpty) {
      users.forEach((element) {
        if (element.uid == id) {
          user = element;
        }
      });
    }
    return user;
  }

  static AuthCredential getAuthCredentials(){
    return _AuthCredentials;
  }
}