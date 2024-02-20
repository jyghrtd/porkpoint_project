import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/QuestionList.dart';
import 'package:porkpoint_project/DataBase/post_content.dart';
import 'package:porkpoint_project/answerwrite.dart';
import 'package:porkpoint_project/frequentfunc.dart';

class LectureQuestionPage extends StatefulWidget {
  final int postId;
  const LectureQuestionPage(this.postId, {super.key});

  @override
  State<LectureQuestionPage> createState() => _LectureQuestionPageState();
}

class _LectureQuestionPageState extends State<LectureQuestionPage> {
  PostContent questionPage = PostContent(
      code: 0,
      communityPage: CommunityPage(
          postTitle: '',
          userId: '',
          postType: 0,
          postTime: DateTime(0),
          description: '',
          userName: ''),
      comment: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PostContentData.getInfo(widget.postId).then((value) {
      setState(() {
        questionPage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text('질문 페이지'),
        actions: [
          ElevatedButton(
              onPressed: () {
                TransferMap(context, AnswerWrite());
              },
              child: const Text('답변하기'))
        ],
      ),
      body: Scrollbar(
        child: Column(children: [
          //질문
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
                title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionPage.communityPage.postTitle,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(questionPage.communityPage.description)
              ],
            )),
          ),
          //답변
          questionPage.comment.isNotEmpty
              ? ListView.builder(
                  itemCount: questionPage.comment.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Text(questionPage.comment[index].userId),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  questionPage.comment[index].writeTime.toString().substring(0, 11),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              questionPage.comment[index].description,
                              style: const TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ));
                  })
              : const Column(),
        ]),
      ),
    );
  }
}
