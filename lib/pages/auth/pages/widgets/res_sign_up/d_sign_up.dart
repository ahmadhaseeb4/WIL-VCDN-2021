import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pwot/models/authDataModel.dart';
import 'package:pwot/pages/auth/widgets/snackbar.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';

class DesktopSignUp extends StatefulWidget {
  const DesktopSignUp({Key? key, required this.pageController, required this.refreshUI}) : super(key: key);
  final PageController pageController;
  final Function refreshUI;

  @override
  _DesktopSignUpState createState() => _DesktopSignUpState();
}

class _DesktopSignUpState extends State<DesktopSignUp> {
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeContact = FocusNode();
  final FocusNode focusNodeCode = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();
  TextEditingController signupContactController = TextEditingController();
  TextEditingController signupCodeController = TextEditingController();

  bool loader = false;

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    focusNodeContact.dispose();
    focusNodeCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
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
                  height: 400.0,
                  child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,)) : Column(
                    children: <Widget>[
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
                                    focusNode: focusNodeContact,
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
                          Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      focusNode: focusNodeCode,
                                      controller: signupCodeController,
                                      style: TextStyle(color: AppColor.bgSideMenu),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.phoneAlt,
                                          size: 22.0,
                                          color: AppColor.bgSideMenu,
                                        ),
                                        hintText: 'Therapist Code*',
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
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Text("*If you don't have a Therapist Code, you may skip it")
                    ],
                  ),
                ),
              ),
              loader ? Container(): Container(
                margin: const EdgeInsets.only(top: 370.0),
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
                      'Sign Up',
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

                    StartLoader();
                    AuthData result = await AuthServices.SignUp(signupEmailController.text, signupPasswordController.text, signupNameController.text, signupContactController.text, signupCodeController.text);
                    StopLoader();
                    if (result.message == "Signed Up" || result.message == "Signed Up! Admin") {
                      widget.refreshUI(result.user);
                      widget.pageController.jumpToPage(0);
                    }
                     else if (result.message == "The code you entered is invalid"){
                      context.showErrorBar(content: Text(result.message));
                      return;
                    } else if (result.message != "Signed Up"){
                      context.showErrorBar(content: Text(result.message));
                      return;
                    }
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColor.bgSideMenu,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),

        ],
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

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
