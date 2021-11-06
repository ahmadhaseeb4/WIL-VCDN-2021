import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pwot/pages/auth/widgets/snackbar.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();

  bool loader = false;

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
                  height: 400.0,
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
                              onTap: _toggleSignup,
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
                            _toggleSignUpButton();
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
                              onTap: _toggleSignup,
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
                            _toggleSignUpButton();
                          },
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                    StartLoader();
                    String result = await AuthServices.SignUp(signupEmailController.text, signupPasswordController.text, signupNameController.text);
                    StopLoader();
                    if (result != "Signed Up"){
                      context.showErrorBar(content: Text(result));
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

  void _toggleSignUpButton() {
    CustomSnackBar(context, const Text('SignUp button pressed'));
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
