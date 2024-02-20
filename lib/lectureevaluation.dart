import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/post_content.dart';
import 'package:porkpoint_project/frequentfunc.dart';

class LectureEvaluation extends StatefulWidget {
  final int postId;
  const LectureEvaluation(this.postId, {super.key});

  @override
  State<LectureEvaluation> createState() => _LectureEvaluationState();
}

class _LectureEvaluationState extends State<LectureEvaluation> {
  PostContent postContent = PostContent(
      code: 0,
      communityPage: CommunityPage(
          postTitle: '',
          userId: '',
          postType: 0,
          postTime: DateTime(0),
          description: '',
          userName: ''),
      comment: []);

  late NewComment addComment;

  late int postId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postId = widget.postId;
    PostContentData.getInfo(widget.postId).then((value) {
      setState(() {
        postContent = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController commentInput = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('강의평가'),
        ),
        body: postContent.communityPage.postTitle.isNotEmpty
            ? SingleChildScrollView(
                child: Column(children: [
                  BasicBoxForm(
                    ListTile(
                      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          postContent.communityPage.postTitle,
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(postContent.communityPage.description),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/img/blank-profile-picture-973460_640.png'),
                              radius: 25,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              postContent.communityPage.userId,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Expanded(
                              child: Text(
                                postContent.communityPage.postTime.toString(),
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ]),
                    ),
                  ),
                  BasicBoxForm(ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: postContent.comment.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/img/blank-profile-picture-973460_640.png'),
                            radius: 25,
                          ),
                          title: Row(
                            children: [
                              Text(postContent.comment[index].userId),
                              Expanded(
                                  child: Text(
                                postContent.comment[index].writeTime.toString().substring(0, 11),
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.right,
                              ))
                            ],
                          ),
                          subtitle: Text(postContent.comment[index].description),
                        );
                      }))
                ]),
              )
            : const Center(
                child: Text('Loading...'),
              ),
        bottomNavigationBar: ListTile(
          title: TextField(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            controller: commentInput,
          ),
          trailing: ElevatedButton(
              onPressed: () async {
                //로그인 하지 않았을 경우
                if (loginUser.userInfo.userId.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Container(
                            padding: const EdgeInsets.all(20),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '로그인하여 주십시오.',
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('확인')),
                          ],
                        );
                      });
                  return;
                }

                addComment = await InputComment.getInfo(
                    loginUser.userInfo.userId, postId, commentInput.text);

                if (addComment.code == 200) {
                  PostContentData.getInfo(widget.postId).then((value) {
                    setState(() {
                      postContent = value;
                    });
                  });
                  setState(() {});
                } else {
                  Fluttertoast.showToast(msg: '댓글 입력 실패.');
                }
              },
              child: const Text('send')),
        )
        // Row(
        //   children: [
        //     Expanded(
        //         child: TextField(
        //       decoration: InputDecoration(border: OutlineInputBorder()),
        //     )),
        //     SizedBox(
        //       width: 10,
        //     ),
        //     ElevatedButton(onPressed: () {}, child: Text('send'))
        //   ],
        // ),
        );
  }
}
