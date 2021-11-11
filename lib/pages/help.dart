import 'dart:async';
import 'dart:html' as HTML;
import 'dart:math' as MATH;
import 'package:accordion/accordion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/articleModel.dart';
import 'package:pwot/models/faqsModel.dart';
import 'package:pwot/models/videoModel.dart';
import 'package:pwot/services/article_services.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/services/video_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash/flash.dart';
import 'package:pwot/widgets/add-faq.dart';
import 'package:flash/flash.dart';
import 'package:pwot/widgets/add_article.dart';
import 'package:pwot/widgets/add_video.dart';
import 'package:pwot/widgets/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class Help extends StatefulWidget {
  const Help({Key? key,}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool loader = false;
  bool helperLoader = false;
  late List<AccordionSection> accordionSection = [];
  List<ArticleModel> articles = [];
  List<VideoModel> videos = [];
  late Future<List<ArticleModel>> articleFtr;
  late Future<List<VideoModel>> videoFtr;
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  void initState() {
    setState(() {
      loader = true;
    });
    articleFtr = ArticleServices.extractAllArticles();
    videoFtr = VideoServices.extractAllVideos();
    FAQServices.extractAllFAQs().then((value) {
      int counter = 0;

      for (int i=0; i<value.length; i++){
        counter++;
        accordionSection.add(
          AccordionSection(
              headerBackgroundColor: AppColor.bgSideMenu,
              contentBorderColor: AppColor.bgSideMenu,
              isOpen: false,
              header: Text(value[i].question, style: const TextStyle(color: Colors.white, fontSize: 17)),
              content: helperLoader == true ? const SizedBox(child: Center(child: CircularProgressIndicator(),), height: 50,): Column(
                children: [
                  Text(value[i].answer, style: const TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Did you find this answer helpful?"),
                      const SizedBox(width: 5,),
                      MaterialButton(
                        onPressed: () async {
                          CollectionReference postCollection = FirebaseFirestore.instance.collection('faqs');
                          value[i].helpful++;
                          postCollection.doc(value[i].id).update(value[i].toJson()).then((value) {
                            context.showSuccessBar(content: Row(
                              children: const [
                                Text("FAQ marked as - "),
                                Text("Helpful", style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ));
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.thumb_up, color: Colors.green.shade900, size: 16,),
                            const SizedBox(width: 5,),
                            Text('Helpful ', style: TextStyle(
                                color: Colors.green.shade900
                            )
                            ),
                          ],
                        ),
                        textColor: Colors.green.shade900,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.green.shade900,
                            width: 1,
                            style: BorderStyle.solid
                        ), borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(width: 5,),
                      MaterialButton(
                        onPressed: () async {
                          context.showSuccessBar(content: Row(
                            children: const [
                              Text("FAQ marked as - "),
                              Text("Not Helpful", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ));
                          CollectionReference postCollection = FirebaseFirestore.instance.collection('faqs');
                          value[i].notHelpful++;
                          postCollection.doc(value[i].id).update(value[i].toJson()).then((value) {
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.thumb_down, color: Colors.red.shade900, size: 16,),
                            const SizedBox(width: 5,),
                            Text('Not Helpful ', style: TextStyle(
                                color: Colors.red.shade900
                            )
                            ),
                          ],
                        ),
                        textColor: Colors.red.shade900,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.red.shade900,
                            width: 1,
                            style: BorderStyle.solid
                        ), borderRadius: BorderRadius.circular(5)),
                      )

                    ],
                  )
                ],
              )
          ),
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
        color: AppColor.bgSideMenu,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: AppColor.bgColor,
          ),
          child: loader == true ? Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),): Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: ArticlesWidget()
                    ),
                    Expanded(
                        child: VideosWidget(height, width)
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text("Frequently Asked Questions.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    Accordion(
                        maxOpenSections: 2,
                        leftIcon: const Icon(Icons.question_answer_outlined, color: Colors.white),
                        children: accordionSection
                    ),
                  ],
                ),
              ),
            ]
        ),
      )
    ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: AppColor.bgColor,),
        backgroundColor: AppColor.yellow,
        onPressed: () {
          Completer completer = Completer();
          context.showFlashDialog(
            dismissCompleter: completer,
            barrierDismissible: false,
            backgroundColor: AppColor.bgColor,
            margin: EdgeInsets.symmetric(horizontal: width * 0.2),
            persistent: true,
            title: const Text("Add a new FAQ"),
            content: AddVideo(completer: completer, resetVideoUI: resetVideoUI),
          );
        },
      ),
    );
  }

  void resetHelpUI(ArticleModel articleModel) {
    setState(() {
      articles.add(articleModel);
    });
  }

  void resetVideoUI(VideoModel videoModel) {
    setState(() {
      videos.add(videoModel);
    });
  }

  Widget ArticlesWidget() {
    return Column(
      children: [
        const Text("Articles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        FutureBuilder<List<ArticleModel>>(
            future: articleFtr,
            builder: (BuildContext context, AsyncSnapshot<List<ArticleModel>> snapshot) {
              if (snapshot.hasData) {
                articles = snapshot.data!;
                return snapshot.data!.isNotEmpty ? Expanded(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                      child: FittedBox(
                                        child: Text(snapshot.data![i].articleTitle,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                      child: FittedBox(child: Text(snapshot.data![i].articleDescription)),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    HTML.window.open(snapshot.data![i].link, snapshot.data![i].articleTitle);
                                  },
                                  child: FittedBox(child: Text("Visit", style: TextStyle(color: AppColor.bgColor),)),
                                  color: Colors.red.shade900,
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                ),
                              )
                            ],
                          )
                      );
                    }, itemCount: snapshot.data!.length,),
                ):
                const Expanded(child: Center(child: Text("No articles available"),))
                ;
              } else {
                return Expanded(child: Center(child: CircularProgressIndicator(color: AppColor.yellow,),));
              }
            })
      ],
    );
  }

  Widget VideosWidget(var height, var width) {
    return Column(
      children: [
        const Text("Videos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        FutureBuilder<List<VideoModel>>(
            future: videoFtr,
            builder: (BuildContext context, AsyncSnapshot<List<VideoModel>> snapshot) {
              if (snapshot.hasData) {
                videos = snapshot.data!;
                return snapshot.data!.isNotEmpty ? Expanded(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                      child: FittedBox(
                                        child: Text(snapshot.data![i].videoTitle,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                      child: FittedBox(child: Text(snapshot.data![i].videoDescription)),
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
                                      id = YoutubePlayer.convertUrlToId(snapshot.data![i].link);
                                      print('this is '+ id!);

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
                                      margin: EdgeInsets.symmetric(horizontal: width * 0.2),
                                      persistent: true,
                                      title: const Text("Add a new FAQ"),
                                      content: CustomVideoPlayer(link: id!, completer: completer,),
                                    );
                                  },
                                  child: const FittedBox(
                                      child: Icon(Icons.play_arrow, size: 56,)
                                  ),
                                  color: Color((MATH.Random().nextDouble() * 0xBF9000).toInt()).withOpacity(0.2),
                                  padding: const EdgeInsets.symmetric(vertical: 100),
                                ),
                              )
                            ],
                          )
                      );
                    }, itemCount: snapshot.data!.length,),
                ):
                const Expanded(child: Center(child: Text("No videos available"),))
                ;
              } else {
                return Expanded(child: Center(child: CircularProgressIndicator(color: AppColor.yellow,),));
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
}
