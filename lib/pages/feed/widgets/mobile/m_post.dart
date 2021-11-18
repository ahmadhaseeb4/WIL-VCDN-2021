import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pwot/models/commentModel.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:pwot/widgets/post.dart';
import 'package:readmore/readmore.dart';
import 'package:flash/flash.dart';


class MobilePost extends StatefulWidget {
  const MobilePost({Key? key, required this.post, required this.updateFeed, required this.userModel}) : super(key: key);
  final PostModel post;
  final Function updateFeed;
  final UserModel userModel;

  @override
  _MobilePostState createState() => _MobilePostState();
}

class _MobilePostState extends State<MobilePost> {
  late ScrollController _scrollController;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      child: Card(
        elevation: 5,
        shadowColor: AppColor.bgSideMenu,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColor.white,),
          height: height,
          child: loader
              ? Center(
              child: CircularProgressIndicator(color: AppColor.yellow,)
          )
              : Column(
            children: [
              firstHalf(),
              secondHalf(),
              thirdHalf()
            ],
          ),
        ),
      ),
    );
  }

  Widget firstHalf() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: Icon(Icons.supervised_user_circle_sharp, color: AppColor.bgSideMenu,)),
                Expanded(flex: 8, child: Text(" ${widget.post.username}")),
                Expanded(
                  child: FirebaseAuth.instance.currentUser?.uid == widget.post.uid ? InkWell(
                    child: Icon(Icons.delete,
                      color: Colors.red.shade900,
                    ),
                    onTap: () async {
                      StartLoader();
                      List<PostModel> data = await PostServices.deletePost(widget.post.pid);
                      StopLoader();
                      widget.updateFeed(data);
                    },
                  ): widget.userModel.admin ? InkWell(
                    child: Icon(Icons.delete,
                      color: Colors.red.shade900,
                    ),
                    onTap: () async {
                      StartLoader();
                      List<PostModel> data = await PostServices.deletePost(widget.post.pid);
                      StopLoader();
                      widget.updateFeed(data);
                    },
                  ): Container(),
                )
              ],
            ),
          ),
          Expanded(
              child: Row(
                children: [
                  Expanded(child: Icon(Icons.date_range, color: AppColor.bgSideMenu)),
                  Expanded(flex: 8, child: Text(" ${widget.post.postedDate}")),
                ],
              ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: double.infinity,
              child: Card(
                color: AppColor.bgColor,
                elevation: 2,
                child: OctoImage(
                  image: NetworkImage(widget.post.imageAddress),
                  progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),
                  errorBuilder: OctoError.icon(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondHalf() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: ReadMoreText(
        widget.post.text,
        style: Theme.of(context).textTheme.bodyText2,
        trimLines: 2,
        colorClickableText: Colors.yellow,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Show more',
        trimExpandedText: 'Show less',
        moreStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.yellow),
        lessStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.yellow),
      ),
    );
  }

  Widget thirdHalf() {
    return Row(
        children: [
          Expanded(
              child: InkWell(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.post.helpfuls.contains(FirebaseAuth.instance.currentUser?.uid) ? Icon(
                        Icons.thumb_up_alt_outlined,
                        color: AppColor.yellow,
                      )
                          : Icon(
                        Icons.thumb_up_alt_outlined,
                        color: AppColor.bgSideMenu,
                      ),
                      widget.post.helpfuls.contains(FirebaseAuth.instance.currentUser?.uid) ? Row(
                        children: [
                          Text(" Awesome",
                              style: TextStyle(
                                  color: AppColor.yellow)),
                          Text(
                              " - ${widget.post.helpfuls.length}")
                        ],
                      )
                          : Row(
                        children: [
                          Text(" Awesome",
                              style: TextStyle(
                                  color:
                                  AppColor.bgSideMenu)),
                          Text(
                              " - ${widget.post.helpfuls.length}")
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    context.showErrorBar(
                        content: const Text(
                            "Please log in to continue..."));
                    return;
                  }
                  StartLoader();
                  String currentPostID = widget.post.pid;
                  CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');

                  //if not liked, like it
                  if (!widget.post.helpfuls.contains(FirebaseAuth.instance.currentUser?.uid)) {
                    widget.post.helpfuls.add(FirebaseAuth.instance.currentUser!.uid);
                    postCollection.doc(currentPostID).update(widget.post.toJson()).then((value) {
                      StopLoader();
                    });
                  } else {
                    //remove the like
                    widget.post.helpfuls.remove(
                        FirebaseAuth.instance.currentUser!.uid);
                    postCollection
                        .doc(currentPostID)
                        .update(widget.post.toJson())
                        .then((value) {
                      StopLoader();
                    });
                  }
                },
              ),),
          Expanded(
              child: InkWell(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment,
                          color: AppColor.bgSideMenu,
                        ),
                        Text(
                          " Comment",
                          style: TextStyle(color: AppColor.bgSideMenu),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    StartLoader();
                    PostModel post = await PostServices.extractPostInfo(widget.post.pid);
                    List<CommentModel> comments = await PostServices.retrievePostComments(post.comments);
                    StopLoader();
                    Completer completer = Completer();
                    //once comments have been found, show comment dialog
                    context.showFlashDialog(
                        barrierDismissible: false,
                        dismissCompleter: completer,
                        backgroundColor: AppColor.bgColor,
                        persistent: true,
                        title: const Text('Comments'),
                        content: CommentView(post: widget.post, comments: comments, completer: completer,)
                    );}
              ),),
        ],
    );
  }

  void StopLoader() {
    setState(() {
      loader = false;
    });
  }

  void StartLoader() {
    setState(() {
      loader = true;
    });
  }

}
