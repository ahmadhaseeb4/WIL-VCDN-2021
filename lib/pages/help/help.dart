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
import 'package:pwot/models/userModel.dart';
import 'package:pwot/models/videoModel.dart';
import 'package:pwot/pages/help/widgets/add_article.dart';
import 'package:pwot/pages/help/widgets/articles_list.dart';
import 'package:pwot/services/article_services.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/services/video_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:pwot/widgets/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  late Future<List<ArticleModel>> articleFtr;
  late Future<List<VideoModel>> videoFtr;
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController1 = ScrollController();

  @override
  void initState() {
    setState(() {
      loader = true;
    });
    articleFtr = ArticleServices.extractAllArticles();
    videoFtr = VideoServices.extractAllVideos();
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
                            Expanded(child: VideosWidget(height, width)),
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
                              child: Accordion(
                                  maxOpenSections: 2,
                                  leftIcon: const Icon(
                                      Icons.question_answer_outlined,
                                      color: Colors.white),
                                  children: accordionSection),
                            ),
                          ],
                        ),
                      ),
                    ]),
            )),
            floatingActionButton: _getFloatingActionButton(height: height, width: width, resetOne: resetArticles)
    );
  }

  Widget _getFloatingActionButton({required double height, required double width, required Function resetOne}) {
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
            //if need to close menu after click
            _isShowDial = false;
            setState(() {});
          },
          backgroundColor: AppColor.bgSideMenu,
          foregroundColor: AppColor.bgColor,
        ),
        FloatingActionButton(
          tooltip: "Add FAQ",
          mini: true,
          child: Icon(Icons.question_answer_outlined),
          onPressed: () {
            //if need to close menu after click
            _isShowDial = false;
            setState(() {});
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
    print("Refresh Article List");
    setState(() {
      articleFtr = ArticleServices.extractAllArticles();
    });
  }

  void resetArticleUI() async {
    setState(() {
      articleLoader = true;
    });
    List<ArticleModel> data = await ArticleServices.extractAllArticles();
    ArticleModel articleModel = data[0];
    setState(() {
      articles.add(articleModel);
      articleLoader = false;
    });
  }

  void resetVideoUI(VideoModel videoModel) {
    setState(() {
      videos.add(videoModel);
    });
  }

  void resetFAQsUI() async {
    List<AccordionSection> data = await getAccordions();
    setState(() {
      accordionSection.clear();
      accordionSection = data;
    });
  }

  Widget ArticlesWidget() {
    return Column(
      children: [
        const Text(
          "Articles",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        FutureBuilder<List<ArticleModel>>(
            future: articleFtr,
            builder: (BuildContext context,
                AsyncSnapshot<List<ArticleModel>> snapshot) {
              if (snapshot.hasData) {
                articles = snapshot.data!;
                return snapshot.data!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          controller: _scrollController1,
                          itemBuilder: (_, i) {
                            return Card(
                                elevation: 2,
                                color: AppColor.white,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4),
                                            child: FittedBox(
                                              child: Text(
                                                snapshot.data![i].articleTitle,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4),
                                            child: FittedBox(
                                                child: Text(snapshot.data![i]
                                                    .articleDescription)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () {
                                          HTML.window.open(
                                              snapshot.data![i].link,
                                              snapshot.data![i].articleTitle);
                                        },
                                        child: FittedBox(
                                            child: Text(
                                          "Visit",
                                          style: TextStyle(
                                              color: AppColor.bgColor),
                                        )),
                                        color: Colors.red.shade900,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30),
                                      ),
                                    )
                                  ],
                                ));
                          },
                          itemCount: snapshot.data!.length,
                        ),
                      )
                    : const Expanded(
                        child: Center(
                        child: Text("No articles available"),
                      ));
              } else {
                return Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.yellow,
                  ),
                ));
              }
            })
      ],
    );
  }

  Widget VideosWidget(var height, var width) {
    return Column(
      children: [
        const Text(
          "Videos",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        FutureBuilder<List<VideoModel>>(
            future: videoFtr,
            builder: (BuildContext context,
                AsyncSnapshot<List<VideoModel>> snapshot) {
              if (snapshot.hasData) {
                videos = snapshot.data!;
                return snapshot.data!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          controller: _scrollController2,
                          itemBuilder: (_, i) {
                            return Card(
                                elevation: 2,
                                color: AppColor.white,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4),
                                            child: FittedBox(
                                              child: Text(
                                                snapshot.data![i].videoTitle,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4),
                                            child: FittedBox(
                                                child: Text(snapshot.data![i]
                                                    .videoDescription)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () {
                                          String? id = "";
                                          Completer completer = Completer();
                                          try {
                                            id = YoutubePlayer.convertUrlToId(
                                                snapshot.data![i].link);
                                            print('this is ' + id!);
                                          } on Exception catch (exception) {
                                            // only executed if error is of type Exception
                                            print('exception');
                                          } catch (error) {
                                            // executed for errors of all types other than Exception
                                            print('catch error');
                                            //  videoIdd="error";

                                          }
                                          context.showFlashDialog(
                                            dismissCompleter: completer,
                                            barrierDismissible: false,
                                            backgroundColor: AppColor.bgColor,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: width * 0.2),
                                            persistent: true,
                                            title: const Text("Add a new FAQ"),
                                            content: CustomVideoPlayer(
                                              link: id!,
                                              completer: completer,
                                            ),
                                          );
                                        },
                                        child: const FittedBox(
                                            child: Icon(
                                          Icons.play_arrow,
                                          size: 56,
                                        )),
                                        color: Color(
                                                (MATH.Random().nextDouble() *
                                                        0xBF9000)
                                                    .toInt())
                                            .withOpacity(0.2),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 100),
                                      ),
                                    )
                                  ],
                                ));
                          },
                          itemCount: snapshot.data!.length,
                        ),
                      )
                    : const Expanded(
                        child: Center(
                        child: Text("No videos available"),
                      ));
              } else {
                return Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.yellow,
                  ),
                ));
              }
            })
      ],
    );
  }

  // void refreshUIAfterFAQAdd() async {
  //   setState(() {
  //     loader = true;
  //   });
  //   List<FAQsModel> list = await FAQServices.extractAllFAQs();
  //   faqs = list;
  //   setState(() {
  //     loader = false;
  //   });
  //
  // }

  Future<List<AccordionSection>> getAccordions() async {
    setState(() {
      loader = true;
    });
    List<AccordionSection> data = [];
    FAQServices.extractAllFAQs().then((value) {
      int counter = 0;

      for (int i = 0; i < value.length; i++) {
        counter++;
        data.add(
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
    return data;
  }
}
