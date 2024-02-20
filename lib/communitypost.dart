import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/community_post.dart';
import 'package:porkpoint_project/communitypostwrite.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lectureevaluation.dart';
import 'package:porkpoint_project/qnapost.dart';

class CommunityPost extends StatefulWidget {
  const CommunityPost({super.key});

  @override
  State<CommunityPost> createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  String? selectedValue = "All";
  bool lecturePage = false;
  int selectedState = 0;

  PostList postList = PostList(code: 0, communityPages: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommunitySearchData.getInfo(0).then((value) {
      setState(() {
        postList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = ["All", "질문답변 목록", "강의평가"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('강의평가, 질문답변 목록'),
        actions: [
          ElevatedButton(
              onPressed: () {
                TransferMap(context, const CommunityPostWrite());
              },
              child: const Text('게시글 작성'))
        ],
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton(
                items: postState
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: ((value) {
                  setState(() {
                    selectedState = postState.indexWhere((element) => element == value);
                    selectedValue = value!;
                  });
                })),
          ],
        ),
        //게시글 리스트
        postList.communityPages.isNotEmpty
            ? Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: postList.communityPages.length,
                      itemBuilder: (context, index) {
                        if (selectedState ==
                            postState.indexWhere((element) => element == postState[0])) {
                          return InkWell(
                            onTap: () {
                              if (postList.communityPages[index].postType == 1) {
                                TransferMap(context,
                                    LectureEvaluation(postList.communityPages[index].postId));
                              } else if (postList.communityPages[index].postType == 2) {
                                TransferMap(
                                    context, QnAPost(postList.communityPages[index].postId));
                              }
                            },
                            child: (ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postList.communityPages[index].postTitle,
                                    style: const TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    postList.communityPages[index].userId,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Text(postList.communityPages[index].postTime
                                  .toString()
                                  .substring(0, 11)),
                            )),
                          );
                        } else {
                          if (selectedState == postList.communityPages[index].postType) {
                            return InkWell(
                              onTap: () {
                                if (postList.communityPages[index].postType == 1) {
                                  TransferMap(context,
                                      LectureEvaluation(postList.communityPages[index].postId));
                                } else if (postList.communityPages[index].postType == 2) {
                                  TransferMap(
                                      context, QnAPost(postList.communityPages[index].postId));
                                }
                              },
                              child: (ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      postList.communityPages[index].postTitle,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(postList.communityPages[index].userId),
                                  ],
                                ),
                                trailing: Text(postList.communityPages[index].postTime
                                    .toString()
                                    .substring(0, 11)),
                              )),
                            );
                          } else {
                            return Container();
                          }
                        }
                      }),
                ),
              )
            : const Column(
                children: [Text('현재 게시글이 존재하지 않습니다.'), Text('첫 게시물을 작성해 보세요!')],
              )
      ]),
    );
  }
}
