import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:pwot/widgets/add-post.dart';
import 'package:pwot/widgets/post.dart';
import 'package:flash/flash.dart';

class DesktopFeed extends StatefulWidget {
  const DesktopFeed({Key? key, required this.data}) : super(key: key);
  final List<PostModel> data;

  @override
  _DesktopFeedState createState() => _DesktopFeedState(posts: data);
}

class _DesktopFeedState extends State<DesktopFeed> {
  _DesktopFeedState({required this.posts});
  List<PostModel> posts;
  bool loader = false;
  late ScrollController _scrollController;
  late UserModel userModel;

  //INITIALIZERS
  @override
  void initState() {
    setState(() {
      loader = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      AuthServices.getUserModel(FirebaseAuth.instance.currentUser!.uid).then((value) {
        userModel = value;
      });
    } else {
      userModel = UserModel(uid: "null", admin: false, contact: "Not available", pic: '', name: '');
    }
    scrollControllerInitial_init();
    postRetrieval_init();
    super.initState();
  }

  void scrollControllerInitial_init() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {

        });
      });
  }

  void postRetrieval_init() {
    setState(() {
      loader = true;
    });
    //retrieve all posts
    PostServices.retrieveAllPosts().then((value) {
      posts = value;
      setState(() {
        loader = false;
      });
    });
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
    return Scaffold(
      body: Container(
        color: AppColor.bgSideMenu,
        child: loader ? Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),): Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: AppColor.bgColor,
          ),
          child: posts.isEmpty ? const Center(child: Text("No data available")): ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            controller: _scrollController,
            itemBuilder: (c, i) {
              return width < 850 ?
              SizedBox(child: Post(post: posts[i], updateFeed: updateFeed, userModel: userModel, ), height: height,):
              SizedBox(child: Post(post: posts[i], updateFeed: updateFeed, userModel: userModel,), height: height * 0.5);
            },
            itemCount: posts.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton( onPressed: () {
        Completer completer = Completer();
        context.showFlashDialog(
          dismissCompleter: completer,
          barrierDismissible: false,
          backgroundColor: AppColor.bgColor,
          margin: EdgeInsets.symmetric(horizontal: width * 0.2),
          persistent: true,
          title: const Text("Add a new post"),
          content: AddPost(completer: completer, refresh: refreshPostList,),
        );
      }, child: Icon(Icons.add, color: AppColor.bgColor,), backgroundColor: AppColor.yellow,),
    );
  }

  refreshPostList() async {
    List<PostModel> data = await PostServices.retrieveAllPosts();
    setState(() {
      posts = data;
    });
  }

  void updateFeed(List<PostModel> list) {
    setState(() {
      posts = list;
    });
  }
}
