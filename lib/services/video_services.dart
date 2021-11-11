import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pwot/models/articleModel.dart';
import 'package:pwot/models/videoModel.dart';

class VideoServices {
  static Future<bool> addVideo(String articleTitle, String articleDescription, String link) async {
    bool result = false;
    CollectionReference articlesCollection = FirebaseFirestore.instance.collection('videos');
    VideoModel article = VideoModel(
        id: "null",
        userID: FirebaseAuth.instance.currentUser!.uid,
        videoTitle: articleTitle,
        videoDescription: articleDescription,
        link: link,
        date: DateTime.now().toIso8601String()
    );
    await articlesCollection.add(article.toJson()).then((value) {
      result = true;
    });

    return result;
  }

  static Future<List<VideoModel>> extractAllVideos() async {
    List<VideoModel> result = [];
    await FirebaseFirestore.instance.collection("videos").get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        VideoModel article = VideoModel.fromJson(element.data());
        article.id = element.id;
        result.add(article);
      });
    });
    List<VideoModel> sortedList = [];
    // print("All posts found - (${posts.length})");
    result.sort((a, b) => a.date.compareTo(b.date));
    result.reversed.forEach((element) {
      sortedList.add(element);
    });
    return sortedList;
  }
}