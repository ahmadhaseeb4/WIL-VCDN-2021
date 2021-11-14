import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({Key? key, required this.link, required this.completer}) : super(key: key);
  final String link;
  final Completer completer;

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.link,
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: 450,
      width: double.infinity,
      child: Column(
        children: [
          YoutubePlayerIFrame(
            controller: _controller,
            aspectRatio: 16 / 9,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Container()
                ),
                Expanded(
                    child: Container()
                ),
                Expanded(
                    child: Container()
                ),
                Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.red.shade900
                      ),
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        child: const Text("Close"),
                        onPressed: () {
                          widget.completer.complete();
                        },
                      ),
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
