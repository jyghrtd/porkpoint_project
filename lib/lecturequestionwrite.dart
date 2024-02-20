import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/postwrite.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lecturequestionpage.dart';

class LectureQuestionWrite extends StatefulWidget {
  final int lectureId;
  const LectureQuestionWrite(this.lectureId, {super.key});

  @override
  State<LectureQuestionWrite> createState() => _LectureQuestionWriteState();
}

class _LectureQuestionWriteState extends State<LectureQuestionWrite> {
  PostWrite postWrite = PostWrite(code: 0, message: '');
  late int nowLecture;

  @override
  void initState() {
    super.initState();
    nowLecture = widget.lectureId;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleEdit = TextEditingController();
    TextEditingController contentEdit = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text('질문 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          TextField(
            decoration:
                const InputDecoration(hintText: '강의 회차 ○에 대한 질문입니다.', border: OutlineInputBorder()),
            controller: titleEdit,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: TextField(
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration:
                  const InputDecoration(hintText: '내용을 입력해주세요.', border: OutlineInputBorder()),
              controller: contentEdit,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                if (titleEdit.text.isEmpty) {
                  ActionFailedDialog(context, '제목을 입력해 주십시오.');
                  return;
                } else if (contentEdit.text.isEmpty) {
                  ActionFailedDialog(context, '질문 내용을 입력해 주십시오.');
                  return;
                }

                postWrite = await PostWriteData.getInfo(
                    loginUser.userInfo.userId, 7, titleEdit.text, contentEdit.text, 0, nowLecture);

                if (postWrite.code == 200) {
                  GoWritePage writePageData = await WritePageData.getInfo(
                      loginUser.userInfo.userId, 7, titleEdit.text, contentEdit.text);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LectureQuestionPage(writePageData.pageId)));
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(120, 50)),
              child: const Text("글 작성"))
        ]),
      ),
    );
  }
}
