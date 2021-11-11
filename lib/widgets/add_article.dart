import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/articleModel.dart';
import 'package:pwot/models/faqsModel.dart';
import 'package:pwot/services/article_services.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash/flash.dart';


class AddArticle extends StatefulWidget {
  const AddArticle({Key? key, required this.completer, required this.resetUI}) : super(key: key);
  final Completer completer;
  final Function resetUI;

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController urlTextController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode urlFocusNode = FocusNode();
  bool loader = false;
  List<ArticleModel> articles = [];

  @override
  void dispose() {
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: loader ? Center(child: CircularProgressIndicator(),): Column(
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
                      focusNode: titleFocusNode,
                      controller: titleTextController,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: AppColor.bgSideMenu),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.pencilAlt,
                          color: AppColor.bgSideMenu,
                          size: 22.0,
                        ),
                        hintText: 'Enter article title here...',
                        hintStyle: TextStyle(color: AppColor.bgSideMenu),
                      ),
                      onSubmitted: (_) {
                        titleFocusNode.requestFocus();
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
                      focusNode: descriptionFocusNode,
                      controller: descriptionTextController,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: AppColor.bgSideMenu),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.discourse,
                          color: AppColor.bgSideMenu,
                          size: 22.0,
                        ),
                        hintText: 'Enter article description here...',
                        hintStyle: TextStyle(color: AppColor.bgSideMenu),
                      ),
                      onSubmitted: (_) {
                        descriptionFocusNode.requestFocus();
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

          //url field
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
                      focusNode: urlFocusNode,
                      controller: urlTextController,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: AppColor.bgSideMenu),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.link,
                          color: AppColor.bgSideMenu,
                          size: 22.0,
                        ),
                        hintText: 'Enter article URL here...',
                        hintStyle: TextStyle(color: AppColor.bgSideMenu),
                      ),
                      onSubmitted: (_) {
                        urlFocusNode.requestFocus();
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
                      child: const Text('Add Article', style: TextStyle(color: Colors.white)),
                    ),
                    onPressed: () async {
                      if (loader) return;
                      if (FirebaseAuth.instance.currentUser == null) {
                        context.showErrorBar(content: const Text("Please log in to add article"));
                        return;
                      }
                      if (titleTextController.text == "" || titleTextController.text.isEmpty){
                        context.showErrorBar(content: const Text("Title can not be empty"));
                        return;
                      }
                      if (descriptionTextController.text == "" || descriptionTextController.text.isEmpty){
                        context.showErrorBar(content: const Text("Description can not be empty"));
                        return;
                      }
                      if (urlTextController.text == "" || urlTextController.text.isEmpty){
                        context.showErrorBar(content: const Text("Article link can not be empty"));
                        return;
                      }
                      setState(() {
                        loader = true;
                      });
                      bool result = await ArticleServices.addArticle(titleTextController.text, descriptionTextController.text, urlTextController.text);
                      ArticleModel articleModel = ArticleModel(
                          id: "",
                          userID: FirebaseAuth.instance.currentUser!.uid,
                          articleTitle: titleTextController.text,
                          articleDescription: descriptionTextController.text,
                          link: urlTextController.text,
                          date: DateTime.now().toIso8601String()
                      );
                      widget.resetUI(articleModel);
                      //reset list & clear the field is comment was successful
                      if (result == true) {
                        titleTextController.clear();
                        descriptionTextController.clear();
                        urlTextController.clear();
                        widget.completer.complete();
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
