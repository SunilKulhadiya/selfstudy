import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayer extends StatefulWidget {
  final String VideoUrl;
  final int AutoPlay;
  final int PageNo;
  final BuildContext context;

  const YouTubePlayer({super.key,
    required this.VideoUrl,
    required this.AutoPlay,
    required this.PageNo,
    required this.context});

  @override
  State<StatefulWidget> createState() {
    return _MySpecificPageState();
  }
}

class _MySpecificPageState extends State<YouTubePlayer> {

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    '7mAceDY196A',
  ];

  @override
  void initState() {
    super.initState();
    if(widget.AutoPlay == 0) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.VideoUrl,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )
        ..addListener(listener);
      _idController = TextEditingController();
      _seekToController = TextEditingController();
      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    }else{
      _controller = YoutubePlayerController(
        initialVideoId: widget.VideoUrl,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )
        ..addListener(listener);
      _idController = TextEditingController();
      _seekToController = TextEditingController();
      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    }
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        print("---------------------_isPlayerReady : ${_isPlayerReady}");
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
        print("-----------************************************----------_playerState : ${_playerState}");
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      liveUIColor: Colors.amber,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      aspectRatio: widget.PageNo == 3 ? 7/9 : 4/9,
      onReady: () {
        _isPlayerReady = true;
        // _controller.play();
      },
    );
  }
}