import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/lecturedetail.dart';
import 'package:porkpoint_project/DataBase/lectureplayer.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lecturequestionlist.dart';
import 'package:porkpoint_project/qnapost.dart';
import 'package:video_player/video_player.dart';

class EachLecture extends StatefulWidget {
  final int tocId;
  final int nowLecture;
  final List<LectureToc> lectureList; //강의 리스트 전 페이지에서 받기
  const EachLecture(this.tocId, this.lectureList, this.nowLecture, {super.key});

  @override
  State<EachLecture> createState() => _EachLectureState();
}

class _EachLectureState extends State<EachLecture> {
  late VideoPlayerController controller;

  late Future<void> initializedController;
  late List<LectureToc> lectureList;
  late int nowTocId;
  late int nowLecture;

  LecturePlayer lecturePlayer = LecturePlayer(
      code: 0,
      comment: [],
      tocMaterial: TocMaterial(
          tocId: 0,
          title: '',
          description: '',
          videoLength: 0,
          complete: 0,
          timeProcess: 0,
          materialType: '',
          materialUrl: ''));

  @override
  void initState() {
    super.initState();
    LecturePlayerData.getInfo(widget.tocId).then((value) {
      setState(() {
        lecturePlayer = value;
        nowTocId = widget.tocId;
        nowLecture = widget.nowLecture;
      });
    });
    lectureList = widget.lectureList;
    //initState 내부에서 데이터 받기와 동영상 초기화를 동시에 해야 할 확률이 높을듯. 이 경우 데이터 초기화 후 동영상 초기화, then도 써야 할 듯
    controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'); //네트워크 영상 출력
    initializedController = controller.initialize();
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    TextEditingController lectureComment = TextEditingController();

    return lecturePlayer.tocMaterial.title.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
              title: const Text('강의 페이지'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: initializedController,
                      builder: (_, snapshot) {
                        return AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
                              }
                            }),
                            child: VideoPlayer(controller),
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      lecturePlayer.tocMaterial.title,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/blank-profile-picture-973460_640.png',
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      Flexible(
                        child: TextField(
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "강의에 대해 논의해주세요",
                          ),
                          maxLines: null,
                          controller: lectureComment,
                        ),
                      ),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        ElevatedButton(
                          onPressed: () {
                            TransferMap(context, LectureQuestionList(nowLecture, ''));
                          },
                          child: const Text('질문하기'),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (lectureComment.text.isEmpty) {
                                return;
                              }

                              AddLectureComment addComment = await AddLectureCommentData.getInfo(
                                  loginUser.userInfo.userId, nowTocId, lectureComment.text);

                              if (addComment.code == 200) {
                                LecturePlayerData.getInfo(nowTocId).then((value) {
                                  setState(() {
                                    lecturePlayer = value;
                                  });
                                });
                                setState(() {});
                              } else {
                                Fluttertoast.showToast(msg: '코멘트 입력 실패.');
                              }
                            },
                            child: const Text('send')),
                      ]),
                    ],
                  ),
                  //showModalBottomSheet(context: context, builder: builder)
                  //코멘트
                  lecturePlayer.comment.isNotEmpty
                      ? ListView.builder(
                          itemCount: lecturePlayer.comment.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.asset(
                                'assets/img/lecture.png',
                              ),
                              title: Row(
                                children: [
                                  Text(lecturePlayer.comment[index].userId),
                                  Expanded(
                                      child: Text(
                                    lecturePlayer.comment[index].inputTime
                                        .toString()
                                        .substring(0, 11),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                ],
                              ),
                              subtitle: Text(lecturePlayer.comment[index].commentInfo),
                            );
                          })
                      : const Column(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.arrow_back_ios), label: 'Prev'),
                BottomNavigationBarItem(icon: Icon(Icons.dehaze_rounded), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.arrow_forward_ios), label: 'Next')
              ],
              currentIndex: currentIndex,
              onTap: (value) {
                setState(() {
                  currentIndex = value;
                });
                //전체 강의 목록을 불러와야 설정이 가능할듯
                if (currentIndex == 0 && nowLecture != lectureList[0].tocId) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EachLecture(
                              lecturePlayer.tocMaterial.tocId - 1, lectureList, nowLecture)));
                } else if (currentIndex == 1) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: lectureList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: ListTile(
                                  leading: Image.network(lectureList[index].thumbnail),
                                  title: Text(lectureList[index].title),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EachLecture(
                                              lectureList[index].tocId, lectureList, nowLecture)));
                                },
                              );
                            });
                      });
                } else if (currentIndex == 2 &&
                    nowLecture != lectureList[lectureList.length - 1].tocId) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EachLecture(
                              lecturePlayer.tocMaterial.tocId + 1, lectureList, nowLecture)));
                }
              },
            ),
          )
        : const Center(
            child: Text('Loading...'),
          );
  }

  //이후 showModalBottomSheet로 아래 메뉴 버튼 기능 구현
}
