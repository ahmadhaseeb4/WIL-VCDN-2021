import 'package:flutter/material.dart';
import 'package:pwot/models/commentModel.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Comment extends StatefulWidget {
  const Comment({Key? key, required this.comments}) : super(key: key);
  final List<CommentModel> comments;

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  TextEditingController postTextController = TextEditingController();

  final FocusNode focusNodePost = FocusNode();

  @override
  void dispose() {
    focusNodePost.dispose();
    super.dispose();
  }

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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Icon(Icons.person, color: AppColor.bgSideMenu,)),
                            Expanded(child: Text("${widget.comments[i].username}", style: TextStyle(fontWeight: FontWeight.bold),), flex: 22,),
                            Expanded(child: Icon(Icons.delete, color: Colors.red.shade900,), flex: 1,)
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    focusNode: focusNodePost,
                    controller: postTextController,
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
                  ),
                ),
                Container(
                  width: width * 0.5,
                  height: 5.0,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: AppColor.yellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
