import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/models/videoModel.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/services/video_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'dart:html' as HTML;
import 'package:flash/flash.dart';
import 'package:pwot/widgets/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class VideoList extends StatefulWidget {
  const VideoList({Key? key, required this.extractedVideos, required this.resetVideosUI}) : super(key: key);
  final List<VideoModel> extractedVideos;
  final Function resetVideosUI;

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<VideoModel> extractedVideos = [];
  final ScrollController _scrollController = ScrollController();
  bool loader = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        loader = true;
      });
      AuthServices.getUserModel(FirebaseAuth.instance.currentUser!.uid).then((value) {
        user = value;
        setState(() {
          loader = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: loader
              ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),)
              : ListView.builder(
            controller: _scrollController,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      widget.extractedVideos[i].videoTitle,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                    flex: 10,
                                  ),
                                  if (user != null && user!.admin)
                                  Expanded(
                                    child: InkWell(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade900,
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          loader = true;
                                        });
                                        List<VideoModel> data = await VideoServices.deleteArticle(widget.extractedVideos[i].id);
                                        widget.extractedVideos.clear();
                                        data.forEach((element) {
                                          widget.extractedVideos.add(element);
                                        });
                                        setState(() {
                                          loader = false;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: FittedBox(child: Text(widget.extractedVideos[i].videoDescription)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            String id = "";
                            id = extractIDFromVideo(link: widget.extractedVideos[i].link);
                            Completer completer = Completer();
                            context.showFlashDialog(
                              dismissCompleter: completer,
                              barrierDismissible: false,
                              backgroundColor: AppColor.bgColor,
                              margin: EdgeInsets.symmetric(horizontal: width * 0.2),
                              persistent: true,
                              title: Text(widget.extractedVideos[i].videoTitle),
                              content: CustomVideoPlayer(
                                link: id,
                                completer: completer,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const Icon(Icons.play_arrow),
                              Text("Play",
                                style: TextStyle(color: AppColor.bgColor),),
                            ],
                          ),
                          color: Colors.greenAccent.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                        ),
                      )
                    ],
                  )
              );
            }, itemCount: widget.extractedVideos.length,),
        )
      ],
    );
  }

  String extractIDFromVideo({required String link}) {
    String? id = "";
    try {
      id = YoutubePlayer.convertUrlToId(link);
      print('this is ' + id!);
    } on Exception catch (exception) {
      // only executed if error is of type Exception
      print('exception');
    } catch (error) {
      // executed for errors of all types other than Exception
      print('catch error');
      //  videoIdd="error";

    }
    return id!;
  }
}
