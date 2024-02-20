import 'dart:io';

import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/lectureplayer.dart';
import 'package:video_player/video_player.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late VideoPlayerController controller;
  late Future<void> initializedController;
  LecturePlayer lecturePlayer = LecturePlayer(
      code: 0,
      tocMaterial: TocMaterial(
          tocId: 0,
          title: '',
          description: '',
          videoLength: 0,
          complete: 0,
          timeProcess: 0,
          materialType: '',
          materialUrl: ''),
      comment: []);

  @override
  void initState() {
    LecturePlayerData.getInfo(1).then((value) {
      setState(() {
        lecturePlayer = value;
      });
    });
    controller =
        // VideoPlayerController.asset('assets/videos/movie_for_coding_2.mp4');
        VideoPlayerController.network(
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    initializedController = controller.initialize().then((value) {
      setState(() {});
      controller.play();
    }).catchError((onError) {
      print('초기화 에러');
    });
    controller.play();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializedController,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              });
            },
            child: VideoPlayer(controller),
          ),
        );
      },
    );
  }
}
