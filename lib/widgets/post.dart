import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pwot/models/commentModel.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:pwot/widgets/comment.dart';
import 'package:readmore/readmore.dart';
import 'package:flash/flash.dart';


class Post extends StatefulWidget {
  const Post({Key? key, required this.post}) : super(key: key);
  final PostModel post;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {

  late ScrollController _scrollController;
  bool loader = false;
  int likes = 0;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {

        });
      });
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    likes = widget.post.helpfuls.length;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(side: BorderSide(color: AppColor.bgSideMenu, width: 0.5)),
      shadowColor: AppColor.bgSideMenu,
      child: Container(
        height: height,
        color: AppColor.white,
        child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,)): Row(
          children: [
            Expanded(child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: OctoImage(
                      image: NetworkImage(widget.post.imageAddress),
                      progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),
                      errorBuilder: OctoError.icon(color: Colors.red),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.post.helpfuls.contains(FirebaseAuth.instance.currentUser?.uid) ?
                            Icon(Icons.thumb_up_alt_outlined, color: AppColor.yellow,):
                            Icon(Icons.thumb_up_alt_outlined, color: AppColor.bgSideMenu,),
                            widget.post.helpfuls.contains(FirebaseAuth.instance.currentUser?.uid) ?
                            Row(
                              children: [
                                Text("Awesome", style: TextStyle(color: AppColor.yellow)),
                                Text(" - ${widget.post.helpfuls.length}")
                              ],
                            ):
                            Row(
                              children: [
                                Text("Awesome", style: TextStyle(color: AppColor.bgSideMenu)),
                                Text(" - ${widget.post.helpfuls.length}")
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      setState(() {
                        loader = true;
                      });
                      String currentPostID = widget.post.pid;
                      CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');
                      DocumentSnapshot data = await postCollection.doc(currentPostID).get();

                      //if not liked, like it
                      if (!widget.post.helpfuls.contains(FirebaseAuth.instance.currentUser?.uid)){
                        widget.post.helpfuls.add(FirebaseAuth.instance.currentUser!.uid);
                        postCollection.doc(currentPostID).update(widget.post.toJson()).then((value) {
                          setState(() {
                            loader = false;
                          });
                        });
                      } else {
                        //remove the like
                        widget.post.helpfuls.remove(FirebaseAuth.instance.currentUser!.uid);
                        postCollection.doc(currentPostID).update(widget.post.toJson()).then((value) {
                          setState(() {
                            loader = false;
                          });
                        });
                      }
                    },
                  ),
                ),
              ],)
            ),
            Expanded(child: columnTwo(height, width))
          ],
        ),
      ),
    );
  }

  Widget columnTwo(var height, var width){
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.01),
            child: PostText(),
          ),
        ),
        Expanded(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.015),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.comment, color: AppColor.bgSideMenu,),
                      Text("Comment", style: TextStyle(color: AppColor.bgSideMenu),),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                List<CommentModel> comments = await PostServices.retrievePostComments(widget.post.comments);
                context.showFlashDialog(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.2,),
                  backgroundColor: AppColor.bgColor,
                    persistent: true,
                    title: const Text('Comments'),
                    content: Comment(comments: comments,),
                    negativeActionBuilder: (context, controller, _) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all( Radius.circular(5.0)),
                            color: AppColor.bgSideMenu
                        ),
                        child: MaterialButton(
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.03),
                            child: const Text('Comment', style: TextStyle(color: Colors.white)),
                          ),
                          onPressed: () async {

                          },
                        ),
                      );
                    },
                    positiveActionBuilder: (context, controller, _) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all( Radius.circular(5.0)),
                            color: Colors.red.shade800
                        ),
                        child: MaterialButton(
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.03),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white),),
                          ),
                          onPressed: () async {
                            controller.dismiss();
                          },
                        ),
                      );
                    });
              },
            ),
        ),
      ],
    );
  }

  Widget PostText() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.supervised_user_circle, color: AppColor.bgSideMenu,),
              Text(widget.post.username, style: TextStyle(color: AppColor.bgSideMenu)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Icon(Icons.date_range, color: AppColor.bgSideMenu,),
              Text(widget.post.postedDate, style: TextStyle(color: AppColor.bgSideMenu),),
            ],
          ),
          const SizedBox(height: 20,),
          Expanded(child: SingleChildScrollView(
            controller: _scrollController,
            child: ReadMoreText(
              widget.post.text,
              style: Theme.of(context).textTheme.bodyText2,
              trimLines: 2,
              colorClickableText: Colors.yellow,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColor.yellow),
              lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColor.yellow),
            ),
          ))
        ],
      ),
    );
  }

  // Future<void> addComment() async {
  //   CommentModel comment = CommentModel(
  //       commentDate: DateTime.now().toIso8601String(),
  //       commentNo: 1,
  //       text: text,
  //       userID: FirebaseAuth.instance.currentUser!.uid,
  //       username: username
  //   )
  //   CollectionReference comments = FirebaseFirestore.instance.collection('comments');
  //   comments.add().then((value) {
  //     print("Comment Added!");
  //   });
  // }
}
