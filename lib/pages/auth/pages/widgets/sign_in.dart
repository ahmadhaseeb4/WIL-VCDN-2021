import 'package:flutter/material.dart';
import 'package:pwot/pages/auth/pages/widgets/res_sign_in/d_sign_in.dart';
import 'package:pwot/pages/auth/pages/widgets/res_sign_in/m_sign_in.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.pageController, required this.refreshUI}) : super(key: key);
  final PageController pageController;
  final Function refreshUI;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return width < 850 ? MobileSignIn(pageController: widget.pageController, refreshUI: widget.refreshUI,): DesktopSignIn(pageController: widget.pageController, refreshUI: widget.refreshUI);
  }
}
