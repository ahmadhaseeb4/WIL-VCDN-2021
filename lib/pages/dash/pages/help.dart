import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pwot/models/postModel.dart';
import 'package:pwot/pages/auth/pages/widgets/sign_in.dart';
import 'package:pwot/pages/auth/pages/widgets/sign_up.dart';
import 'package:pwot/pages/auth/utils/bubble_indicator_painter.dart';
import 'package:pwot/pages/dash/pages/widgets/screen_1.dart';
import 'package:pwot/pages/dash/pages/widgets/screen_2.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:pwot/pages/help/widgets/add_article.dart';

class HelpPanel extends StatefulWidget {
  const HelpPanel({Key? key, required this.completer, required this.resetArticleUI, required this.resetVideoUI, required this.resetFAQsUI}) : super(key: key);
  final Completer completer;
  final Function resetArticleUI;
  final Function resetVideoUI;
  final Function resetFAQsUI;

  @override
  _HelpPanelState createState() => _HelpPanelState();
}

class _HelpPanelState extends State<HelpPanel> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  List<PostModel> posts = [];
  List<PostModel> articles = [];
  List<PostModel> videos = [];
  List<PostModel> faqs = [];
  Color one = Colors.black;
  Color two = Colors.white;
  Color three = Colors.white;
  Color four = Colors.white;


  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: GestureDetector(
            onTap: () {
            },
            child: Container(
              color: AppColor.bgColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (int i) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (i == 0) {
                          setState(() {
                            one = Colors.black;
                            two = Colors.white;
                            three = Colors.white;
                            four = Colors.white;
                          });
                        } else if (i == 1) {
                          setState(() {
                            one = Colors.white;
                            two = Colors.black;
                            three = Colors.white;
                            four = Colors.white;
                          });
                        } else if (i == 2) {
                          setState(() {
                            one = Colors.white;
                            two = Colors.white;
                            three = Colors.black;
                            four = Colors.white;
                          });
                        } else if (i == 3) {
                          setState(() {
                            one = Colors.white;
                            two = Colors.white;
                            three = Colors.white;
                            four = Colors.black;
                          });
                        }
                      },
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: Container(),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: ScreenTwo(),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: ScreenOne(),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: ScreenTwo(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildMenuBar(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: 400.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: AppColor.bgSideMenu,
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: _pageController, dxTarget: 75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onPostsButtonPress,
                child: Text(
                  'Posts',
                  style: TextStyle(
                      color: one,),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onArticlesButtonPress,
                child: Text(
                  'Articles',
                  style: TextStyle(
                      color: two,),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onVideosButtoPress,
                child: Text(
                  'Videos',
                  style: TextStyle(
                    color: three,),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onFAQsButtoPress,
                child: Text(
                  'FAQs',
                  style: TextStyle(
                    color: four,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPostsButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onArticlesButtonPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onVideosButtoPress() {
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onFAQsButtoPress() {
    _pageController.animateToPage(3,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
