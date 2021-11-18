import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/authDataModel.dart';
import 'package:pwot/models/image.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';
import 'package:firebase/firebase.dart' as FB;
import 'dart:html' as HTML;


class DesktopAddTherapist extends StatefulWidget {
  const DesktopAddTherapist({Key? key, required this.completer, required this.refreshUI}) : super(key: key);
  final Function refreshUI;
  final Completer completer;

  @override
  _DesktopAddTherapistState createState() => _DesktopAddTherapistState();
}

class _DesktopAddTherapistState extends State<DesktopAddTherapist> {
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeCotact = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();
  TextEditingController signupContactController = TextEditingController();

  HTML.File? file;
  bool loader = false;

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    focusNodeCotact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: AppColor.bgSideMenu,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppColor.bgColor,
        ),
        child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),): Container(
          padding: const EdgeInsets.only(top: 23.0),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: 600.0,
                      height: 500.0,
                      child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,)) : Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(child: Icon(Icons.supervised_user_circle_sharp, color: AppColor.bgSideMenu, size: width * 0.1,),),
                              const Expanded(child: Text("Add New Therapist", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),))
                            ],
                          ),
                          //row 1
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                      child: TextField(
                                        focusNode: focusNodeName,
                                        controller: signupNameController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: AppColor.bgSideMenu),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.userAlt,
                                            color: AppColor.bgSideMenu,
                                            size: 22.0,
                                          ),
                                          hintText: 'Full Name',
                                          hintStyle: TextStyle(color: AppColor.bgSideMenu),
                                        ),
                                        onSubmitted: (_) {
                                          focusNodeName.requestFocus();
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 250.0,
                                      height: 2.0,
                                      color: AppColor.yellow,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                      child: TextField(
                                        focusNode: focusNodeEmail,
                                        controller: signupEmailController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: AppColor.bgSideMenu),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.envelope,
                                            color: AppColor.bgSideMenu,
                                            size: 22.0,
                                          ),
                                          hintText: 'Email',
                                          hintStyle: TextStyle(color: AppColor.bgSideMenu),
                                        ),
                                        onSubmitted: (_) {
                                          focusNodeEmail.requestFocus();
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 250.0,
                                      height: 2.0,
                                      color: AppColor.yellow,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          //row 2
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                      child: TextField(
                                        focusNode: focusNodePassword,
                                        controller: signupPasswordController,
                                        obscureText: _obscureTextPassword,
                                        style: TextStyle(color: AppColor.bgSideMenu),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.lock,
                                            size: 22.0,
                                            color: AppColor.bgSideMenu,
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(color: AppColor.bgSideMenu),
                                          suffixIcon: GestureDetector(
                                            onTap: _toggleSignup1,
                                            child: Icon(
                                              _obscureTextPassword
                                                  ? FontAwesomeIcons.eye
                                                  : FontAwesomeIcons.eyeSlash,
                                              size: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        onSubmitted: (_) {
                                          //_toggleSignUpButton();
                                        },
                                        textInputAction: TextInputAction.go,
                                      ),
                                    ),
                                    Container(
                                      width: 250.0,
                                      height: 2.0,
                                      color: AppColor.yellow,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                      child: TextField(
                                        focusNode: focusNodeConfirmPassword,
                                        controller: signupConfirmPasswordController,
                                        obscureText: _obscureTextConfirmPassword,
                                        style: TextStyle(color: AppColor.bgSideMenu),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.lock,
                                            size: 22.0,
                                            color: AppColor.bgSideMenu,
                                          ),
                                          hintText: 'Confirm Password',
                                          hintStyle: TextStyle(color: AppColor.bgSideMenu),
                                          suffixIcon: GestureDetector(
                                            onTap: _toggleSignup2,
                                            child: Icon(
                                              _obscureTextConfirmPassword
                                                  ? FontAwesomeIcons.eye
                                                  : FontAwesomeIcons.eyeSlash,
                                              size: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        onSubmitted: (_) {
                                          //_toggleSignUpButton();
                                        },
                                        textInputAction: TextInputAction.go,
                                      ),
                                    ),
                                    Container(
                                      width: 250.0,
                                      height: 2.0,
                                      color: AppColor.yellow,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          //row 3
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        focusNode: focusNodeCotact,
                                        controller: signupContactController,
                                        style: TextStyle(color: AppColor.bgSideMenu),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.phoneAlt,
                                            size: 22.0,
                                            color: AppColor.bgSideMenu,
                                          ),
                                          hintText: 'Contact Number',
                                          hintStyle: TextStyle(color: AppColor.bgSideMenu),
                                        ),
                                        onSubmitted: (_) {
                                          //_toggleSignUpButton();
                                        },
                                        textInputAction: TextInputAction.go,
                                      ),
                                    ),
                                    Container(
                                      width: 250.0,
                                      height: 2.0,
                                      color: AppColor.yellow,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //row 4
                          Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 35),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                        color: AppColor.yellow
                                    ),
                                    child: MaterialButton(
                                      highlightColor: Colors.transparent,
                                      child: Text("Select Image"),
                                      onPressed: () {
                                        HTML.FileUploadInputElement picker = HTML.FileUploadInputElement()..accept = 'image/*';
                                        picker.click();

                                        picker.onChange.listen((event) {
                                          setState(() {
                                            file = picker.files?.first;
                                          });
                                          context.showSuccessBar(
                                              content: Row(
                                                children: [
                                                  const Text("Image selected successfully - "),
                                                  Text(file!.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              duration: Duration(seconds: 5)
                                          );
                                          final reader = HTML.FileReader();
                                          reader.readAsDataUrl(file!);
                                          reader.onLoadEnd.listen((event) {

                                          });
                                        });
                                      },
                                    ),
                                  ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 35),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                      color: Colors.red.shade900
                                  ),
                                  child: MaterialButton(
                                    highlightColor: Colors.transparent,
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      widget.completer.complete();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 470.0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all( Radius.circular(5.0)),
                        color: AppColor.bgSideMenu
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      child: const Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,),
                        ),
                      ),
                      onPressed: () async {
                        if (signupNameController.text == "" || signupNameController.text.isEmpty){
                          context.showErrorBar(content: const Text("Name can not be empty."));
                          return;
                        }
                        if (signupEmailController.text == "" || signupEmailController.text.isEmpty){
                          context.showErrorBar(content: const Text("Email can not be empty."));
                          return;
                        }
                        if (signupPasswordController.text == "" || signupPasswordController.text.isEmpty){
                          context.showErrorBar(content: const Text("Password can not be empty."));
                          return;
                        }
                        if (signupConfirmPasswordController.text == "" || signupConfirmPasswordController.text.isEmpty){
                          context.showErrorBar(content: const Text("Confirm password can not be empty."));
                          return;
                        }
                        if (signupPasswordController.text != signupConfirmPasswordController.text){
                          context.showErrorBar(content: const Text("Password and Confirm Password do not match."));
                          return;
                        }
                        if (signupContactController.text.isEmpty){
                          context.showErrorBar(content: const Text("Contact number can not be empty."));
                          return;
                        }

                        if (file == null){
                          context.showErrorBar(content: const Text("Please select an image."));
                          return;
                        }
                        setState(() {
                          loader = true;
                        });
                        PostImage image = await uploadImage();
                        print("Image address is -----> ${image.url}");
                        bool result = await uploadPost(
                            signupEmailController.text,
                            signupPasswordController.text,
                            signupNameController.text,
                            signupContactController.text,
                            image.url
                        );
                        print("Your therapist creation was $result");
                        List<UserModel> users = [];
                        List<UserModel> therapists = [];
                        await FirebaseFirestore.instance.collection('users').get()
                        .then((value) {
                          value.docs.forEach((element) {
                            users.add(UserModel.fromJson(element.data()));
                          });
                          users.forEach((element) {
                            if (element.admin) {
                              therapists.add(element);
                            }
                          });
                          setState(() {
                            loader = false;
                          });
                          widget.completer.complete();
                          widget.refreshUI(therapists);
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void StopLoader() {
    setState(() {
      loader = false;
    });
  }

  void StartLoader() {
    setState(() {
      loader = true;
    });
  }

  void _toggleSignup1() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
  void _toggleSignup2() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }


  //this method only upload the image and get the image download url
  Future<PostImage> uploadImage() async {
    String link = "";
    final datTime = DateTime.now().toIso8601String();
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final path = '$userID/$datTime';
    FB.UploadTaskSnapshot task = await FB.storage().refFromURL('gs://wilvcdn2021.appspot.com').child(path).put(file).future;
    Uri uri = await task.ref.getDownloadURL();
    link = uri.toString();
    PostImage image = PostImage(id: task.ref.name, url: link);
    return image;
  }

  Future<bool> uploadPost(String email, String password, String name, String contact, String link) async {
    bool task = false;
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

      //once user has been registered
      usersRef.doc(user!.uid).set({
        'uid': user.uid,
        'admin': true,
        'contact': contact,
        'pic': link,
        'name': name
      });
      await user.updateDisplayName(name);
      task = true;
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        context.showErrorBar(content: Text("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        context.showErrorBar(content: Text("The account already exists for that email."));
      }
      return task;
    } catch (e) {
      print(e);
    }

    return task;
  }

}
