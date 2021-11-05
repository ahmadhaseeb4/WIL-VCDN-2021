import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:pwot/widgets/post.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<PostModel> posts = [];
  bool loader = false;
  late ScrollController _scrollController;

  @override
  void initState() {
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
    return Container(
      color: AppColor.bgColor,
      child: loader ? Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),): SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 50),
          controller: _scrollController,
          itemBuilder: (c, i) {
            return width < 850 ?
            SizedBox(child: Post(post: posts[i]), height: height,):
            SizedBox(child: Post(post: posts[i]), height: height * 0.5);
          },
          itemCount: posts.length,
        ),
      ),
    );
  }

  void _onRefresh() async {
    print("Refreshed!");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //posts.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
}
