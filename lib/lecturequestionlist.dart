import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/QuestionList.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lecturequestionpage.dart';
import 'package:porkpoint_project/lecturequestionwrite.dart';
import 'package:porkpoint_project/qnapost.dart';

class LectureQuestionList extends StatefulWidget {
  final int lectureId;
  final String userId;
  const LectureQuestionList(this.lectureId, this.userId, {super.key});

  @override
  State<LectureQuestionList> createState() => _LectureQuestionListState();
}

class _LectureQuestionListState extends State<LectureQuestionList> {
  bool myQuestion = false;
  bool replied = false;
  late int nowLecture;

  QuestionList questionList = QuestionList(code: 1, lectureQuestion: []);

  @override
  void initState() {
    super.initState();
    nowLecture = widget.lectureId;
    CommunitySearchData.getInfo(widget.lectureId, widget.userId).then((value) {
      setState(() {
        questionList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(nowLecture);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text('질문 목록'),
        actions: [
          ElevatedButton(
              onPressed: () {
                TransferMap(context, LectureQuestionWrite(nowLecture));
              },
              child: const Text('질문하기'))
        ],
      ),
      body: questionList.lectureQuestion.isNotEmpty
          ? ListView.builder(
              itemCount: questionList.lectureQuestion.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () =>
                      TransferMap(context, QnAPost(questionList.lectureQuestion[index].postId)),
                  child: ListTile(
                    title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        questionList.lectureQuestion[index].postTitle,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        questionList.lectureQuestion[index].description,
                        overflow: TextOverflow.ellipsis,
                      )
                    ]),
                    trailing: questionList.lectureQuestion[index].answerCheck == 1
                        ? const Icon(Icons.lightbulb_outline)
                        : const Icon(Icons.question_mark_rounded),
                  ),
                );
              })
          : const Center(
              child: Text('이 글에 질문이 존재하지 않습니다.\n최초로 질문을 작성해 보세요.'),
            ),
    );
  }
}
