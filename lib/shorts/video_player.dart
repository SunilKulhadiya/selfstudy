import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  //final String VideoUrl;
  final File? VideoUrl;
  final BuildContext context;

  const MyVideoPlayer({super.key,
    required this.VideoUrl,
    required this.context});

  @override
  State<StatefulWidget> createState() {
    return _MySpecificPageState();
  }
}

class _MySpecificPageState extends State<MyVideoPlayer> {
  VideoPlayerController? controller;
  late VoidCallback listener;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    //controller = VideoPlayerController.network(widget.VideoUrl)
    controller = VideoPlayerController.file(widget.VideoUrl!)
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
      //controller = VideoPlayerController.network(widget.VideoUrl)
      controller = VideoPlayerController.file(widget.VideoUrl!)
        ..addListener(listener)
        ..setVolume(0.5)
        ..initialize()
        ..play();
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


// class VideoProvider extends StatelessWidget {
//   final VideoPlayerController controller;
//
//   VideoProvider(this.controller);
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 6 / 9,
//       child: VideoPlayer(
//           controller
//       ),
//     );
//   }
//
// }