import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/pages/feed/widgets/mobile/m_post.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';
import 'package:pwot/widgets/add-post.dart';


class MobileFeed extends StatefulWidget {
  const MobileFeed({Key? key, required this.data}) : super(key: key);
  final List<PostModel> data;

  @override
  _MobileFeedState createState() => _MobileFeedState(posts: data);
}

class _MobileFeedState extends State<MobileFeed> {
  _MobileFeedState({required this.posts});
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
      userModel = UserModel(uid: "null", admin: false, contact: "Not available", name: '', pic: '');
    }
    initScrollController();
    getAllPostsFromDB();
    super.initState();
  }

  void initScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {

        });
      });
  }

  void getAllPostsFromDB() {
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
    return Scaffold(
      body: Container(
        color: AppColor.bgSideMenu,
        child: loader ? Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),): Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: AppColor.bgColor,
          ),
          child: posts.isEmpty ? const Center(child: Text("No data available")): ListView.builder(
            controller: _scrollController,
            itemBuilder: (c, i) {
              return MobilePost(post: posts[i], updateFeed: updateFeed, userModel: userModel,);
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
          margin: EdgeInsets.symmetric(horizontal: double.infinity),
          persistent: true,
          title: const Text("Add a new post"),
          content: AddPost(completer: completer, refresh: refreshPostList,),
        );
      }, child: Icon(Icons.add, color: AppColor.bgColor,), backgroundColor: AppColor.yellow,),
    );
  }

  refreshPostList() async {
    List<PostModel> data = await PostServices.retrieveAllPosts();
    print("Refreshing list...");
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
