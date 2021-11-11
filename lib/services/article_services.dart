import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pwot/models/articleModel.dart';

class ArticleServices {
  static Future<bool> addArticle(String articleTitle, String articleDescription, String link) async {
    bool result = false;
    CollectionReference articlesCollection = FirebaseFirestore.instance.collection('articles');
    ArticleModel article = ArticleModel(
        id: "null",
        userID: FirebaseAuth.instance.currentUser!.uid,
        articleTitle: articleTitle,
        articleDescription: articleDescription,
        link: link,
        date: DateTime.now().toIso8601String()
    );
    await articlesCollection.add(article.toJson()).then((value) {
      result = true;
    });

    return result;
  }

  static Future<List<ArticleModel>> extractAllArticles() async {
    List<ArticleModel> result = [];
    await FirebaseFirestore.instance.collection("articles").get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        ArticleModel article = ArticleModel.fromJson(element.data());
        article.id = element.id;
        result.add(article);
      });
    });
    List<ArticleModel> sortedList = [];
    // print("All posts found - (${posts.length})");
    result.sort((a, b) => a.date.compareTo(b.date));
    result.reversed.forEach((element) {
      sortedList.add(element);
    });
    return sortedList;
  }
}