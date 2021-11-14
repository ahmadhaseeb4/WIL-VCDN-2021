import 'dart:async';
import 'dart:html' as HTML;
import 'dart:math' as MATH;
import 'package:accordion/accordion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:pwot/models/articleModel.dart';
import 'package:pwot/models/faqsModel.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/models/videoModel.dart';
import 'package:pwot/pages/help/widgets/add-faq.dart';
import 'package:pwot/pages/help/widgets/add_article.dart';
import 'package:pwot/pages/help/widgets/add_video.dart';
import 'package:pwot/pages/help/widgets/articles_list.dart';
import 'package:pwot/pages/help/widgets/faqs_list.dart';
import 'package:pwot/pages/help/widgets/videos_list.dart';
import 'package:pwot/services/article_services.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/services/video_services.dart';
import 'package:pwot/utility/app_colors.dart';

class Help extends StatefulWidget {
  const Help({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool loader = false;
  bool articleLoader = false;
  bool helperLoader = false;
  bool _isShowDial = false;
  late List<AccordionSection> accordionSection = [];
  List<ArticleModel> articles = [];
  List<VideoModel> videos = [];
  List<VideoModel> faqs = [];
  late Future<List<ArticleModel>> articleFtr;
  late Future<List<VideoModel>> videoFtr;
  late Future<List<FAQsModel>> faqsFtr;
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController1 = ScrollController();

  @override
  void initState() {
    setState(() {
      loader = true;
    });
    articleFtr = ArticleServices.extractAllArticles();
    videoFtr = VideoServices.extractAllVideos();
    faqsFtr = FAQServices.extractAllFAQs();
    FAQServices.extractAllFAQs().then((value) {
      int counter = 0;

      for (int i = 0; i < value.length; i++) {
        counter++;
        accordionSection.add(
          AccordionSection(
              headerBackgroundColor: AppColor.bgSideMenu,
              contentBorderColor: AppColor.bgSideMenu,
              isOpen: false,
              header: Text(value[i].question,
                  style: const TextStyle(color: Colors.white, fontSize: 17)),
              content: helperLoader == true
                  ? const SizedBox(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                      height: 50,
                    )
                  : Column(
                      children: [
                        Text(
                          value[i].answer,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Did you find this answer helpful?"),
                            const SizedBox(
                              width: 5,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                CollectionReference postCollection =
                                    FirebaseFirestore.instance
                                        .collection('faqs');
                                value[i].helpful++;
                                postCollection
                                    .doc(value[i].id)
                                    .update(value[i].toJson())
                                    .then((value) {
                                  context.showSuccessBar(
                                      content: Row(
                                    children: const [
                                      Text("FAQ marked as - "),
                                      Text(
                                        "Helpful",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ));
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.green.shade900,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('Helpful ',
                                      style: TextStyle(
                                          color: Colors.green.shade900)),
                                ],
                              ),
                              textColor: Colors.green.shade900,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.green.shade900,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                context.showSuccessBar(
                                    content: Row(
                                  children: const [
                                    Text("FAQ marked as - "),
                                    Text(
                                      "Not Helpful",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ));
                                CollectionReference postCollection =
                                    FirebaseFirestore.instance
                                        .collection('faqs');
                                value[i].notHelpful++;
                                postCollection
                                    .doc(value[i].id)
                                    .update(value[i].toJson())
                                    .then((value) {});
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_down,
                                    color: Colors.red.shade900,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('Not Helpful ',
                                      style: TextStyle(
                                          color: Colors.red.shade900)),
                                ],
                              ),
                              textColor: Colors.red.shade900,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.red.shade900,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(5)),
                            )
                          ],
                        )
                      ],
                    )),
        );
      }

      if (counter == value.length) {
        setState(() {
          loader = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
          height: height,
            width: width,
            color: AppColor.bgSideMenu,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: AppColor.bgColor,
              ),
              child: loader == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.bgSideMenu,
                      ),
                    )
                  : Column(children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Articles",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: FutureBuilder<List<ArticleModel>>(
                                        future: articleFtr,
                                        builder: (BuildContext context, AsyncSnapshot<List<ArticleModel>> snapshot) {
                                          if (snapshot.hasData) {
                                            return ArticlesList(extractedArticles: snapshot.data!, resetArticlesUI: resetArticles, );
                                          } else if (snapshot.hasError) {
                                            return const Center(child: Text("We have encountered a problem. It's not you, please try again later", softWrap: true,),);
                                          } else {
                                            return Center(child: CircularProgressIndicator(color: AppColor.yellow,),);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                            Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Videos",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: FutureBuilder<List<VideoModel>>(
                                        future: videoFtr,
                                        builder: (BuildContext context, AsyncSnapshot<List<VideoModel>> snapshot) {
                                          if (snapshot.hasData) {
                                            return VideoList(extractedVideos: snapshot.data!, resetVideosUI: resetArticles, );
                                          } else if (snapshot.hasError) {
                                            return const Center(child: Text("We have encountered a problem. It's not you, please try again later", softWrap: true,),);
                                          } else {
                                            return Center(child: CircularProgressIndicator(color: AppColor.yellow,),);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Frequently Asked Questions.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            Expanded(
                              child: FutureBuilder<List<FAQsModel>>(
                                future: faqsFtr,
                                builder: (BuildContext context, AsyncSnapshot<List<FAQsModel>> snapshot) {
                                  if (snapshot.hasData) {
                                    return FAQsList(extractedFAQs: snapshot.data!, resetArticlesUI: resetFAQs);
                                  } else if (snapshot.hasError) {
                                    return const Center(child: Text("We have encountered a problem. It's not you, please try again later", softWrap: true,),);
                                  } else {
                                    return Center(child: CircularProgressIndicator(color: AppColor.yellow,),);
                                  }
                              },
                              )
                            ),
                          ],
                        ),
                      ),
                    ]),
            )),
            floatingActionButton: _getFloatingActionButton(height: height, width: width, resetOne: resetArticles, resetTwo: resetVideos, resetThree: resetFAQs)
    );
  }

  Widget _getFloatingActionButton({required double height, required double width, required Function resetOne, required Function resetTwo, required Function resetThree}) {
    return SpeedDialMenuButton(
      isShowSpeedDial: _isShowDial,
      updateSpeedDialStatus: (isShow) {
        this._isShowDial = isShow;
      },
      //general init
      isMainFABMini: false,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
          mini: false,
          backgroundColor: AppColor.yellow,
          foregroundColor: AppColor.bgColor,
          child: const Icon(Icons.add),
          onPressed: () {},
          closeMenuChild: const Icon(Icons.close),
          closeMenuForegroundColor: AppColor.bgColor,
          closeMenuBackgroundColor: Colors.red.shade900
      ),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
        FloatingActionButton(
          tooltip: "Add Article",
          mini: true,
          child: const Icon(Icons.edit),
          onPressed: () {
            _isShowDial = false;
            setState(() { });
            Completer completer = Completer();
            context.showFlashDialog(
              dismissCompleter: completer,
              barrierDismissible: false,
              backgroundColor: AppColor.bgColor,
              margin: EdgeInsets.symmetric(horizontal: width * 0.2),
              persistent: true,
              title: const Text("Add a new article",),
              content: AddArticle(
                  completer: completer,
                  resetArticleUI: resetOne
              ),
            );
            //setState(() {});
          },
          backgroundColor: AppColor.bgSideMenu,
          foregroundColor: AppColor.bgColor,
        ),
        FloatingActionButton(
          tooltip: "Add Video",
          mini: true,
          child: Icon(Icons.video_call),
          onPressed: () {
            _isShowDial = false;
            setState(() { });
            Completer completer = Completer();
            context.showFlashDialog(
              dismissCompleter: completer,
              barrierDismissible: false,
              backgroundColor: AppColor.bgColor,
              margin: EdgeInsets.symmetric(horizontal: width * 0.2),
              persistent: true,
              title: const Text("Add a new video",),
              content: AddVideo(
                  completer: completer,
                  resetVideoUI: resetTwo
              ),
            );
          },
          backgroundColor: AppColor.bgSideMenu,
          foregroundColor: AppColor.bgColor,
        ),
        FloatingActionButton(
          tooltip: "Add FAQ",
          mini: true,
          child: Icon(Icons.question_answer_outlined),
          onPressed: () {
            _isShowDial = false;
            setState(() {});
            Completer completer = Completer();
            context.showFlashDialog(
              dismissCompleter: completer,
              barrierDismissible: false,
              backgroundColor: AppColor.bgColor,
              margin: EdgeInsets.symmetric(horizontal: width * 0.2),
              persistent: true,
              title: const Text("Add a new FAQ",),
              content: AddFAQ(completer: completer, resetFAQUI: resetThree)
            );
          },
          backgroundColor: AppColor.bgSideMenu,
          foregroundColor: AppColor.bgColor,
        ),
      ],
      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 30.0,
    );
  }

  resetArticles() async {
    print("Refresh Articles List");
    setState(() {
      articleFtr = ArticleServices.extractAllArticles();
    });
  }

  resetVideos() async {
    print("Refresh Videos List");
    setState(() {
      videoFtr = VideoServices.extractAllVideos();
    });
  }
  
  resetFAQs() async {
    print("Refresh FAQs List");
    setState(() {
      faqsFtr = FAQServices.extractAllFAQs();
    });
  }
  
}
