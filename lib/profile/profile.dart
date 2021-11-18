import 'package:flutter/material.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/profile/widgets/d_profile.dart';
import 'package:pwot/profile/widgets/m_profile.dart';



class Profile extends StatefulWidget {
  const Profile({Key? key, required this.userModel, required this.refreshUI, required this.logOut}) : super(key: key);
  final UserModel userModel;
  final Function refreshUI;
  final Function logOut;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return width < 850 ?  MobileProfile(userModel: widget.userModel, refreshUI: widget.refreshUI, logOut: widget.logOut,):
    DesktopProfile(userModel: widget.userModel, refreshUI: widget.refreshUI, logOut: widget.logOut,);
  }

}
