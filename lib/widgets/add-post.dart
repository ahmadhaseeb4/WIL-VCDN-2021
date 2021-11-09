import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:pwot/models/commentModel.dart';
import 'package:pwot/models/image.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as HTML;
import 'package:firebase/firebase.dart' as FB;
import 'package:flash/flash.dart';



class AddPost extends StatefulWidget {
  const AddPost({Key? key, required this.completer, required this.refresh}) : super(key: key);
  final Completer completer;
  final Function refresh;


  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var commentTextController = TextEditingController();
  final FocusNode focusNodePost = FocusNode();
  HTML.File? file;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.3,
      width: double.infinity,
      child: loader == true ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),):
      Column(
          children: [
            Expanded(
          flex: 3,
          child:  Container(
            child: Column(
              children: [
                Expanded(
                    child: Card(
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
                              ),
                            ),
                            Container(
                              width: width * 0.4,
                              height: 5.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: AppColor.yellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          )),
            Expanded(
            child: Column(
              children: [
                file == null ? Text("No Image Selected!"): FittedBox(child: Text(file!.name)),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      color: AppColor.bgSideMenu
                  ),
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    child: FittedBox(
                        child: loader ? const Center(child: CircularProgressIndicator()):
                        const Text('Select Image', style: TextStyle(color: Colors.white, fontSize: 12)
                        )
                    ),
                    onPressed: () {
                      HTML.FileUploadInputElement picker = HTML.FileUploadInputElement()..accept = 'image/*';
                      picker.click();

                      picker.onChange.listen((event) {
                        setState(() {
                          file = picker.files?.first;
                        });
                        context.showSuccessBar(
                            content: Row(
                              children: [
                                const Text("Image selected successfully - "),
                                Text(file!.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            duration: Duration(seconds: 5)
                        );
                        final reader = HTML.FileReader();
                        reader.readAsDataUrl(file!);
                        reader.onLoadEnd.listen((event) {

                        });
                      });
                    },
                  ),
                ),
              ],
            ),
        ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.transparent
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.transparent
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: AppColor.bgSideMenu
                        ),
                        child: MaterialButton(
                          highlightColor: Colors.transparent,
                          child: Text("Post"),
                          onPressed: () async {
                            if (FirebaseAuth.instance.currentUser == null) {
                              context.showErrorBar(content: const Text("Please log in to add new post."));
                              return;
                            }
                            if (commentTextController.text == "" || commentTextController.text.isEmpty){
                              context.showErrorBar(content: const Text("Post can not be empty."));
                              return;
                            }
                            if (file == null){
                              context.showErrorBar(content: const Text("Please select an image."));
                              return;
                            }
                            PostImage image = await uploadImage();
                            print(image.id + " - " + image.url);
                            bool result = await uploadPost(image.url, commentTextController.text);
                            print(result);
                            widget.completer.complete();
                            widget.refresh();
                          },
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.red.shade900
                        ),
                        child: MaterialButton(
                          highlightColor: Colors.transparent,
                          child: Text("Cancel"),
                          onPressed: () {
                            widget.completer.complete();
                          },
                        ),
                      )
                  )
                ],
              ),
            )
          ]
      )
    );
  }

  Future<PostImage> uploadImage() async {
    String link = "";
    final datTime = DateTime.now().toIso8601String();
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final path = '$userID/$datTime';
    FB.UploadTaskSnapshot task = await FB.storage().refFromURL('gs://wilvcdn2021.appspot.com').child(path).put(file).future;
    Uri uri = await task.ref.getDownloadURL();
    link = uri.toString();
    PostImage image = PostImage(id: task.ref.name, url: link);
    return image;
  }

  Future<bool> uploadPost(String link, String text) async {
    bool task = false;
    PostModel post = PostModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        username: FirebaseAuth.instance.currentUser!.displayName!,
        pid: "null",
        profilePicture: "null",
        imageAddress: link,
        text: text,
        helpful: 0,
        helpfuls: [],
        comments: [],
        postedDate: DateTime.now().toIso8601String()
    );

    await FirebaseFirestore.instance.collection("posts").add(post.toJson()).then((value) async {
      task = true;
    }).onError((error, stackTrace) {
      print("There was an error. $error");
    });
    return task;
  }

  Future<void> deletePost(String postID) async {
    await FirebaseFirestore.instance.collection("posts").doc(postID).delete();
  }

}
