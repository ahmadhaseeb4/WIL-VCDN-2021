import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash/flash.dart';

class MobileProfile extends StatefulWidget {
  const MobileProfile({Key? key, required this.userModel, required this.refreshUI, required this.logOut}) : super(key: key);
  final UserModel userModel;
  final Function refreshUI;
  final Function logOut;

  @override
  _MobileProfileState createState() => _MobileProfileState();
}

class _MobileProfileState extends State<MobileProfile> {
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

  bool loader = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loader = true;
    });
    AuthServices.getUserModel(FirebaseAuth.instance.currentUser!.uid).then((value) {
      signupEmailController.text = FirebaseAuth.instance.currentUser!.email!;
      signupNameController.text = FirebaseAuth.instance.currentUser!.displayName!;
      signupContactController.text = value.contact;
      setState(() {
        loader = false;
      });
    });
  }

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bgSideMenu,
      child: loader ? Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),): Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppColor.bgColor,
        ),
        child: Container(
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
                      width: 300.0,
                      height: 500.0,
                      child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,)) : Column(
                        children: <Widget>[
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                            child: TextField(
                              enabled: false,
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
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,),
                        ),
                      ),
                      onPressed: () async {
                        if (signupContactController.text.isNotEmpty) {
                          StartLoader();
                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({'contact': signupContactController.text});
                          StopLoader();
                        }
                        if (signupNameController.text.isNotEmpty) {
                          StartLoader();
                          setState(() {
                            FirebaseAuth.instance.currentUser!.updateDisplayName(signupNameController.text);
                            widget.refreshUI(FirebaseAuth.instance.currentUser!);
                          });
                          StopLoader();
                        }

                        if (signupPasswordController.text.isNotEmpty && signupConfirmPasswordController.text.isNotEmpty) {
                          if (signupPasswordController.text == signupConfirmPasswordController.text) {
                            StartLoader();
                            User user = FirebaseAuth.instance.currentUser!;
                            user.updatePassword(signupPasswordController.text).then((_){
                              context.showSuccessBar(content: Text("Password chaged! Please log in again."), duration: Duration(seconds: 2));
                              Future.delayed(const Duration(seconds: 2), () async {
                                await widget.logOut();
                              });
                              StopLoader();
                            }).catchError((error){
                              print("Password can't be changed" + error.toString());
                            });
                          }
                        }
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
}
