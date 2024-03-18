import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:video_player/video_player.dart';

class VideoPlayerWithUrl extends StatefulWidget {
  final String VideoUrl;
  final BuildContext context;

  const VideoPlayerWithUrl({super.key,
    required this.VideoUrl,
    required this.context});

  @override
  State<StatefulWidget> createState() {
    return _MySpecificPageState();
  }
}

class _MySpecificPageState extends State<VideoPlayerWithUrl> {
  late SharedPreferences prefs;
  VideoPlayerController? controller;
  late VoidCallback listener;
  int UserID = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    prefs = await SharedPreferences.getInstance();
    UserID = prefs.getInt('Userid')!;

    //controller = VideoPlayerController.file(widget.VideoUrl!)
    print("=============================VideoPlayerWithUrl : ${widget.VideoUrl}");
    controller = VideoPlayerController.network(widget.VideoUrl!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void _playPause(){
    if (controller!.value.isPlaying) {
      controller!.pause();
    } else {
      controller!.play();
    }
  }

  void videoHandler() {
    print("----------------${controller}");
    if (controller == null) {
      //controller = VideoPlayerController.file(widget.VideoUrl!)
      controller = VideoPlayerController.network(widget.VideoUrl)
        ..addListener(listener)
        ..setVolume(0.5)
        ..initialize()
        ..pause();
    }
    else {
      if (controller!.value.isPlaying) {
        controller!.pause();
      } else {
        controller!.play();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: controller!.value.isInitialized
          ? Stack(
          children:[ AspectRatio(
              aspectRatio: 6/9,
              child: Center(
                  child:GestureDetector(
                    onTap: _playPause,
                    child:VideoPlayer(controller!),)

              )
          ),
          ]

      )
          : Container(),

    );
  }
}