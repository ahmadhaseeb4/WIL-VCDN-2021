import 'package:cloud_firestore/cloud_firestore.dart';
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
    List<PostModel> sortedList = [];
    // print("All posts found - (${posts.length})");
    posts.sort((a, b) => a.postedDate.compareTo(b.postedDate));
    posts.reversed.forEach((element) {
      sortedList.add(element);
    });
    return sortedList;
  }

  static Future<List<CommentModel>> retrievePostComments(List<String> ids) async {
    List<CommentModel> comments = [];
    await FirebaseFirestore.instance.collection("comments").get().then((value) {
      value.docs.forEach((element) {
        if (ids.contains(element.id)){
          CommentModel commentModel = CommentModel.fromJson(element.data());
          commentModel.cid = element.id;
          comments.add(commentModel);
        }
      });
    });
    print("Comments found - (${comments.length})");
    return comments;
  }

  static Future<bool> addComment(String comment, String userID, String user_name, String postID) async {
    bool status = false;
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    CommentModel commentModel = CommentModel(
        commentDate: DateTime.now().toIso8601String(),
        commentNo: 0,
        text: comment,
        userID: userID,
        username: user_name
    );

    //adding comment
    await FirebaseFirestore.instance.collection("comments").add(commentModel.toJson()).then((value) async {
      //extracting post with postID
      DocumentSnapshot postRef = await posts.doc(postID).get();
      Map<String, dynamic> postMap = postRef.data() as Map<String, dynamic>;
      PostModel postModel = PostModel.fromJson(postMap);
      postModel.comments.add(value.id);
      await posts.doc(postID).update(postModel.toJson()).then((value) => status = true);
    }).onError((error, stackTrace) {
      print("There was an error. $error");
    });

    return status;
  }

  static Future<bool> deleteComment({required String postID, required String commentID}) async {
    print("POST ID $postID - COMMENT ID $commentID");
    bool status = false;
    CollectionReference commentsCR = FirebaseFirestore.instance.collection('comments');
    CollectionReference postsCR = FirebaseFirestore.instance.collection('posts');

    await commentsCR.doc(commentID).delete().then((value) async {
      print("Comment deleted.");
      DocumentSnapshot postRef = await postsCR.doc(postID).get();
      Map<String, dynamic> postMap = postRef.data() as Map<String, dynamic>;
      PostModel postModel = PostModel.fromJson(postMap);
      postModel.comments.remove(commentID);
      await postsCR.doc(postID).update(postModel.toJson()).then((value) => status = true);
      print("Post updated after comment deleted.");
    }).onError((error, stackTrace) {
      print("Something went wrong while deleting comment.");
    });
    return status;
  }

  static Future<PostModel> extractPostInfo(String postID) async {
    //once you add the comment, use the selected post's ID and re-download it data so that the re-downloaded data
    //reflects the newly added comment ID
    List<PostModel> posts = await retrieveAllPosts();
    late PostModel post;
    posts.forEach((element) {
      if (element.pid == postID){
        post = element;
      }
    });
    return post;
  }
}