import 'package:flutter/material.dart';
import 'package:pwot/utility/app_colors.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool loader = false;

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
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Row(
              children: [
                Expanded(child: Container(color: Colors.red,)),
                Expanded(flex: 3, child: Container(color: Colors.yellow,)),
              ],
            ),
          ),
        ),
    );
  }
}
