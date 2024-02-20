import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/post_content.dart';
import 'package:porkpoint_project/answerwrite.dart';
import 'package:porkpoint_project/frequentfunc.dart';

class QnAPost extends StatefulWidget {
  final int postId;
  const QnAPost(this.postId, {super.key});

  @override
  State<QnAPost> createState() => _QnAPostState();
}

class _QnAPostState extends State<QnAPost> {
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

    return postContent.communityPage.postTitle.isNotEmpty
        ? Scaffold(
            appBar: AppBarDefault('질문ㆍ답변'),
            body: SingleChildScrollView(
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
                        height: 30,
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
                              postContent.communityPage.postTime.toString().substring(0, 11),
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      )
                    ]),
                  ),
                ),
                ListTile(
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
                          Fluttertoast.showToast(msg: '답변 입력 실패.');
                        }
                      },
                      child: const Text('send')),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: postContent.comment.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final reverseIndex = postContent.comment.length - 1 - index;
                      return BasicBoxForm(
                        QnAShape(
                            "답변 ${reverseIndex + 1}",
                            postContent.comment[reverseIndex].description,
                            'assets/img/blank-profile-picture-973460_640.png',
                            postContent.comment[reverseIndex].userId),
                      );
                    })
              ]),
            ),
          )
        : const Center(
            child: Text('Loading...'),
          );
  }

  ListTile QnAShape(String questionTitle, String content, String imageLink, String name) {
    return ListTile(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          questionTitle,
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(content),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageLink),
              radius: 25,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 20),
            ),
            Expanded(
              child: Text(
                postContent.communityPage.postTime.toString().substring(0, 11),
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.right,
              ),
            )
          ],
        )
      ]),
    );
  }
}
