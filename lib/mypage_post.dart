import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/mypostlist.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lectureevaluation.dart';
import 'package:porkpoint_project/lecturequestionpage.dart';
import 'package:porkpoint_project/qnapost.dart';

class MyPagePost extends StatefulWidget {
  const MyPagePost({super.key});

  @override
  State<MyPagePost> createState() => _MyPagePostState();
}

class _MyPagePostState extends State<MyPagePost> {
  MyPostList myPostList = MyPostList(code: 0, myPost: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyPostData.getInfo(loginUser.userInfo.userId).then((value) {
      setState(() {
        myPostList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarDefault('내 작성글'),
        body: myPostList.myPost.isNotEmpty
            ? ListView.builder(
                itemCount: myPostList.myPost.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        if (myPostList.myPost[index].postType == 1) {
                          TransferMap(context, LectureEvaluation(myPostList.myPost[index].postId));
                        } else if (myPostList.myPost[index].postType == 2) {
                          TransferMap(context, QnAPost(myPostList.myPost[index].postId));
                        } else if (myPostList.myPost[index].postType == 4 ||
                            myPostList.myPost[index].postType == 5 ||
                            myPostList.myPost[index].postType == 6) {
                          TransferMap(
                              context,
                              LectureEvaluation(myPostList.myPost[index]
                                  .postId)); //문의사항 관련 페이지. 이후 구현. LectureEvaluation을 변경
                        } else if (myPostList.myPost[index].postType == 7) {
                          TransferMap(
                              context, LectureQuestionPage(myPostList.myPost[index].postId));
                        } else if (myPostList.myPost[index].postType == 8) {
                          //자유게시판, 미구현
                          TransferMap(
                              context, LectureQuestionPage(myPostList.myPost[index].postId));
                        }
                      },
                      child: ListTile(
                        title: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.grey[300],
                          child: Text(myPostList.myPost[index].postTitle),
                        ),
                      ));
                })
            : const Center(
                child: Text('현재 게시글이 존재하지 않습니다.'),
              ));
  }
}
