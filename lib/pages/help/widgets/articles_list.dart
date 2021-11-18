import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:html' as HTML;

import 'package:pwot/models/articleModel.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/services/article_services.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/utility/app_colors.dart';


class ArticlesList extends StatefulWidget {
  const ArticlesList({Key? key, required this.extractedArticles, required this.resetArticlesUI}) : super(key: key);
  final List<ArticleModel> extractedArticles;
  final Function resetArticlesUI;
  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  List<ArticleModel> extractedArticles = [];
  final ScrollController _scrollController1 = ScrollController();
  bool loader = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        loader = true;
      });
      AuthServices.getUserModel(FirebaseAuth.instance.currentUser!.uid).then((value) {
        user = value;
        setState(() {
          loader = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: loader
              ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),)
              : ListView.builder(
            controller: _scrollController1,
            itemBuilder: (_, i) {
              return Card(
                  elevation: 2,
                  color: AppColor.white,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                        widget.extractedArticles[i].articleTitle,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                    flex: 10,
                                  ),
                                  if (user != null && user!.admin)
                                  Expanded(
                                    child: InkWell(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade900,
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          loader = true;
                                        });
                                        List<ArticleModel> data = await ArticleServices.deleteArticle(widget.extractedArticles[i].id);
                                        widget.extractedArticles.clear();
                                        data.forEach((element) {
                                          widget.extractedArticles.add(element);
                                        });
                                        setState(() {
                                          loader = false;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: FittedBox(child: Text(
                                  widget.extractedArticles[i].articleDescription)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            HTML.window.open(widget.extractedArticles[i].link,
                                widget.extractedArticles[i].articleTitle);
                          },
                          child: Column(
                            children: [
                              const Icon(Icons.menu_book_outlined),
                              Text("Read",
                                style: TextStyle(color: AppColor.bgColor),),
                            ],
                          ),
                          color: AppColor.yellow,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                        ),
                      )
                    ],
                  )
              );
            }, itemCount: widget.extractedArticles.length,),
        )
      ],
    );
  }

}
