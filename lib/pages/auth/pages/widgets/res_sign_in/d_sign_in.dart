import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pwot/models/authDataModel.dart';
import 'package:pwot/pages/auth/widgets/snackbar.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';

class DesktopSignIn extends StatefulWidget {
  const DesktopSignIn({Key? key, required this.pageController, required this.refreshUI}) : super(key: key);
  final PageController pageController;
  final Function refreshUI;

  @override
  _DesktopSignInState createState() => _DesktopSignInState();
}

class _DesktopSignInState extends State<DesktopSignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;
  bool loader = false;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
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
                  height: 190.0,
                  child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),): Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodeEmail,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: AppColor.bgSideMenu),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: AppColor.bgSideMenu,
                              size: 22.0,
                            ),
                            hintText: 'Email Address',
                            hintStyle: TextStyle(color: AppColor.bgSideMenu),
                          ),
                          onSubmitted: (_) {
                            focusNodePassword.requestFocus();
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
                          controller: loginPasswordController,
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
                              onTap: _toggleLogin,
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
                          },
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 170.0),
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
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,),
                    ),
                  ),
                  onPressed: () async {
                    if (loginEmailController.text == "" || loginEmailController.text.isEmpty){
                      context.showErrorBar(content: const Text("Email can not be empty"));
                      return;
                    }
                    if (loginPasswordController.text == "" || loginPasswordController.text.isEmpty){
                      context.showErrorBar(content: const Text("Password can not be empty"));
                      return;
                    }
                    StartLoader();
                    AuthData result = await AuthServices.SignIn(loginEmailController.text, loginPasswordController.text);
                    StopLoader();
                    if (result.message != "Signed In"){
                      context.showErrorBar(content: Text(result.message));
                      return;
                    } else if (result.message == "Signed In") {
                      widget.refreshUI(result.user);
                      widget.pageController.jumpToPage(0);
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


  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}
