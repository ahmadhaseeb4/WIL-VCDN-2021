import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/faqsModel.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash/flash.dart';


class AddFAQ extends StatefulWidget {
  const AddFAQ({Key? key, required this.completer, required this.resetFAQUI}) : super(key: key);
  final Completer completer;
  final Function resetFAQUI;

  @override
  _AddFAQState createState() => _AddFAQState();
}

class _AddFAQState extends State<AddFAQ> {
  TextEditingController questionTextController = TextEditingController();
  TextEditingController answerTextController = TextEditingController();
  final FocusNode questionFocusNode = FocusNode();
  final FocusNode answerFocusNode = FocusNode();
  bool loader = false;
  List<FAQsModel> faqs = [];

  @override
  void dispose() {
    questionFocusNode.dispose();
    answerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),): Column(
        children: [
          //question field
          Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      focusNode: questionFocusNode,
                      controller: questionTextController,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: AppColor.bgSideMenu),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.question,
                          color: AppColor.bgSideMenu,
                          size: 22.0,
                        ),
                        hintText: 'Enter your question here...',
                        hintStyle: TextStyle(color: AppColor.bgSideMenu),
                      ),
                      onSubmitted: (_) {
                        questionFocusNode.requestFocus();
                      },
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 256,
                      enabled: loader ? false: true,
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    height: 5.0,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: AppColor.yellow,
                    ),
                  )
                ],
              ),
            ),
          ),

          //answer field
          Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      focusNode: answerFocusNode,
                      controller: answerTextController,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: AppColor.bgSideMenu),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.checkCircle,
                          color: AppColor.bgSideMenu,
                          size: 22.0,
                        ),
                        hintText: 'Enter your answer here...',
                        hintStyle: TextStyle(color: AppColor.bgSideMenu),
                      ),
                      onSubmitted: (_) {
                        answerFocusNode.requestFocus();
                      },
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 256,
                      enabled: loader ? false: true,
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    height: 5.0,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: AppColor.yellow,
                    ),
                  )
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5.0)),
                      color: AppColor.bgSideMenu),
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01,
                          horizontal: width * 0.03),
                      child: const Text('Add FAQ', style: TextStyle(color: Colors.white)),
                    ),
                    onPressed: () async {
                      if (loader) return;
                      if (FirebaseAuth.instance.currentUser == null) {
                        context.showErrorBar(content: const Text("Please log in to add FAQ"));
                        return;
                      }
                      if (questionTextController.text == "" || questionTextController.text.isEmpty){
                        context.showErrorBar(content: const Text("Question can not be empty"));
                        return;
                      }
                      if (answerTextController.text == "" || answerTextController.text.isEmpty){
                        context.showErrorBar(content: const Text("Answer can not be empty"));
                        return;
                      }
                      setState(() {
                        loader = true;
                      });
                      bool result = await FAQServices.addFAQ(questionTextController.text, answerTextController.text);
                      widget.resetFAQUI();
                      //reset list & clear the field is comment was successful
                      if (result == true) {
                        questionTextController.clear();
                        answerTextController.clear();
                        widget.completer.complete();
                        widget.resetFAQUI();
                        setState(() {
                          loader = false;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 5,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.red.shade900
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                            horizontal: width * 0.03
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ), onPressed: () async {
                    if (loader) return;
                    widget.completer.complete();
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
