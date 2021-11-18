import 'package:flutter/material.dart';
import 'package:pwot/pages/auth/pages/widgets/res_sign_up/d_sign_up.dart';
import 'package:pwot/pages/auth/pages/widgets/res_sign_up/m_sign_up.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.pageController, required this.refreshUI}) : super(key: key);
  final PageController pageController;
  final Function refreshUI;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return width < 850 ? MobileSignUp(pageController: widget.pageController, refreshUI: widget.refreshUI):
    DesktopSignUp(pageController: widget.pageController, refreshUI: widget.refreshUI);
  }
}
