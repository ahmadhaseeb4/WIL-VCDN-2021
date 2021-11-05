import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pwot/models/commentModel.dart';
import 'package:pwot/models/postModel.dart';

class PostServices {
  static Future<List<PostModel>> retrieveAllPosts() async {
    List<PostModel> posts = [];
    await FirebaseFirestore.instance.collection("posts").get().then((value) {
      value.docs.forEach((element) {
        PostModel postModel = PostModel.fromJson(element.data());
        postModel.pid = element.id;
        posts.add(postModel);
      });
    });
    print("All posts found - (${posts.length})");
    return posts;
  }

  static Future<List<CommentModel>> retrievePostComments(List<String> ids) async {
    List<CommentModel> comments = [];
    await FirebaseFirestore.instance.collection("comments").get().then((value) {
      value.docs.forEach((element) {
        CommentModel commentModel = CommentModel.fromJson(element.data());
        comments.add(commentModel);
      });
    });
    print("Comments found - (${comments.length})");
    return comments;
  }

  static Future<bool> addComment(String postID, String comment) async {
    return false;
  }
}