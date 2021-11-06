import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/commentModel.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';


class Comment extends StatefulWidget {
  const Comment({Key? key, required this.comments, required this.postID}) : super(key: key);
  final List<CommentModel> comments;
  final String postID;

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height * 0.5,
          child: ListView.builder(
              itemBuilder: (_, int i){
                return Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: loader ? Center(child: CircularProgressIndicator(),): Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Icon(Icons.person, color: AppColor.bgSideMenu,)),
                            Expanded(child: Text("${widget.comments[i].username}", style: TextStyle(fontWeight: FontWeight.bold),), flex: 22,),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    loader = true;
                                  });
                                  PostServices.deleteComment(postID: widget.postID, commentID: widget.comments[i].cid);
                                  setState(() {
                                    loader = false;
                                  });
                                },
                                  child: FirebaseAuth.instance.currentUser?.uid == widget.comments[i].userID ?
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
                            Expanded(child: Text("${widget.comments[i].text}"), flex: 22,),
                            Expanded(child: Container(), flex: 1,)
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }, itemCount: widget.comments.length,),
        ),
      ],
    );
  }
}
