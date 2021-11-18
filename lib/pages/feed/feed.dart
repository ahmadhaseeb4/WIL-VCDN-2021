import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/pages/feed/widgets/d_feed.dart';
import 'package:pwot/pages/feed/widgets/m_feed.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:pwot/widgets/add-post.dart';
import 'package:pwot/widgets/post.dart';
import 'package:flash/flash.dart';


class Feed extends StatefulWidget {
  const Feed({Key? key, required this.data,}) : super(key: key);
  final List<PostModel> data;

  @override
  _FeedState createState() => _FeedState(posts: data);
}

class _FeedState extends State<Feed> {
  _FeedState({required this.posts});
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<PostModel> posts;
  bool loader = false;
  late ScrollController _scrollController;
  late UserModel userModel;

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return width < 850 ?
        MobileFeed(data: widget.data):
        DesktopFeed(data: widget.data,);
  }


}
