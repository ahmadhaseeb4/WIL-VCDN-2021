import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool loader_1 = false;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
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
    return Card(
      elevation: 5,
      shadowColor: AppColor.bgSideMenu,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColor.white,),
        height: height,
        child: loader_1
            ? Center(
                child: CircularProgressIndicator(
                color: AppColor.yellow,
              ))
            : Row(
                children: [
                  Expanded(child: columnOne()),
                  Expanded(child: columnTwo())
                ],
              ),
      ),
    );
  }
  Widget columnOne() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Image(),
        Awesome(height, width)
      ],
    );
  }

  Widget Image() {
    return Expanded(
      flex: 8,
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
    );
  }

  Widget Awesome(var height, var width) {
    return Expanded(
      child: InkWell(
        child: Container(
          padding:
          EdgeInsets.symmetric(vertical: height * 0.015),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.post.helpfuls.contains(FirebaseAuth
                    .instance.currentUser?.uid)
                    ? Icon(
                  Icons.thumb_up_alt_outlined,
                  color: AppColor.yellow,
                )
                    : Icon(
                  Icons.thumb_up_alt_outlined,
                  color: AppColor.bgSideMenu,
                ),
                widget.post.helpfuls.contains(FirebaseAuth
                    .instance.currentUser?.uid)
                    ? Row(
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
        ),
        onTap: () async {
          if (FirebaseAuth.instance.currentUser == null) {
            context.showErrorBar(
                content: const Text(
                    "Please log in to continue..."));
            return;
          }
          StrL1();
          String currentPostID = widget.post.pid;
          CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');

          //if not liked, like it
          if (!widget.post.helpfuls.contains(FirebaseAuth.instance.currentUser?.uid)) {
            widget.post.helpfuls.add(FirebaseAuth.instance.currentUser!.uid);
            postCollection.doc(currentPostID).update(widget.post.toJson()).then((value) {
              StpL1();
            });
          } else {
            //remove the like
            widget.post.helpfuls.remove(
                FirebaseAuth.instance.currentUser!.uid);
            postCollection
                .doc(currentPostID)
                .update(widget.post.toJson())
                .then((value) {
              StpL1();
            });
          }
        },
      ),
    );
  }

  Widget columnTwo() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        PostText(height, width),
        CommentButton(height, width)
      ],
    );
  }

  Widget PostText(var height, var width) {
    return Expanded(
      flex: 8,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.02, horizontal: width * 0.01),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.supervised_user_circle,
                    color: AppColor.bgSideMenu,
                  ),
                  Text(widget.post.username,
                      style: TextStyle(color: AppColor.bgSideMenu)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: AppColor.bgSideMenu,
                  ),
                  Text(
                    widget.post.postedDate,
                    style: TextStyle(color: AppColor.bgSideMenu),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: SingleChildScrollView(
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
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget CommentButton(var height, var width) {
    return Expanded(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.015),
          child: FittedBox(
            fit: BoxFit.cover,
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
        ),
        onTap: () async {
          StrL1();
          PostModel post = await PostServices.extractPostInfo(widget.post.pid);
          List<CommentModel> comments = await PostServices.retrievePostComments(post.comments);
          StpL1();
          //once comments have been found, show comment dialog
          context.showFlashDialog(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.2,
              ),
              backgroundColor: AppColor.bgColor,
              persistent: true,
              title: const Text('Comments'),
              content: CommentView(post: widget.post, comments: comments,)
          );}
      ),
    );
  }

  void StrL1() {
    setState(() {
      loader_1 = true;
    });
  }

  void StpL1() {
    setState(() {
      loader_1 = false;
    });
  }
}//END

//this is the home widget that gets attached to the flash dialog above
class CommentView extends StatefulWidget {
  const CommentView({Key? key, required this.comments, required this.post}) : super(key: key);
  final List<CommentModel> comments;
  final PostModel post;

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  TextEditingController commentTextController = TextEditingController();
  final FocusNode focusNodePost = FocusNode();
  List<CommentModel> comments = [];
  bool loader = false;

  @override
  void dispose() {
    focusNodePost.dispose();
    super.dispose();
  }

  @override
  void initState() {
    comments = widget.comments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: [
          Column(
          children: [
          SizedBox(
          height: height * 0.5,
            child: loader ? Center(child: CircularProgressIndicator(),):ListView.builder(
              itemBuilder: (_, int i){
                return Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Icon(Icons.person, color: AppColor.bgSideMenu,)),
                            Expanded(child: Text(comments[i].username, style: const TextStyle(fontWeight: FontWeight.bold),), flex: 22,),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      loader = true;
                                    });
                                    bool result = await PostServices.deleteComment(postID: widget.post.pid, commentID: widget.comments[i].cid);
                                    //reset list & clear the field is comment was successful
                                    if (result == true) {
                                      PostModel post = await PostServices.extractPostInfo(widget.post.pid);
                                      List<CommentModel> newComments =  await PostServices.retrievePostComments(post.comments);
                                      comments = newComments;
                                      setState(() {
                                        loader = false;
                                      });
                                    }
                                  },
                                  child: FirebaseAuth.instance.currentUser?.uid == comments[i].userID ?
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red.shade900,
                                  ): Container()
                              ), flex: 1,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Container()),
                            Expanded(child: Text(comments[i].text), flex: 22,),
                            Expanded(child: Container(), flex: 1,)
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }, itemCount: comments.length,),
          ),
          ],
        ),
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
                    focusNode: focusNodePost,
                    controller: commentTextController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: AppColor.bgSideMenu),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.pencilAlt,
                        color: AppColor.bgSideMenu,
                        size: 22.0,
                      ),
                      hintText: 'Enter your post here...',
                      hintStyle: TextStyle(color: AppColor.bgSideMenu),
                    ),
                    onSubmitted: (_) {
                      focusNodePost.requestFocus();
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
                    child: const Text('Comment', style: TextStyle(color: Colors.white)),
                  ),
                  onPressed: () async {
                    if (loader) return;
                    if (FirebaseAuth.instance.currentUser == null) {
                      context.showErrorBar(content: const Text("Please log in to comment"));
                      return;
                    }
                    if (commentTextController.text == "" || commentTextController.text.isEmpty){
                      context.showErrorBar(content: const Text("Comment can not be empty"));
                      return;
                    }
                    setState(() {
                      loader = true;
                    });
                    bool result = await PostServices.addComment(
                        commentTextController.text,
                        FirebaseAuth.instance.currentUser!.uid,
                        FirebaseAuth.instance.currentUser!.displayName!,
                        widget.post.pid
                    );
                    //reset list & clear the field is comment was successful
                    if (result == true) {
                      commentTextController.clear();
                      PostModel post = await PostServices.extractPostInfo(widget.post.pid);
                      List<CommentModel> newComments =  await PostServices.retrievePostComments(post.comments);
                      comments = newComments;
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

                }),
              )
            ],
          ),
        )
      ],
    );
  }
}

