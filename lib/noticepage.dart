import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/community_post.dart';
import 'package:porkpoint_project/DataBase/post_content.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/mypage.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  PostList postList = PostList(code: 0, communityPages: []);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommunitySearchData.getInfo(3).then((value) {
      setState(() {
        postList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(postList.code);
    return Scaffold(
        appBar: AppBarDefault('공지사항'),
        body: postList.communityPages.isNotEmpty
            ? ListView.builder(
                itemCount: postList.communityPages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () async {
                        postContent =
                            await PostContentData.getInfo(postList.communityPages[index].postId);

                        TransferMap(
                            context,
                            MyPageInPost('공지사항', postContent.communityPage.postTitle,
                                postContent.communityPage.description));
                      },
                      child: ListTile(
                        title: Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.grey[300],
                          child: Text(postList.communityPages[index].postTitle),
                        ),
                      ));
                })
            : const Center(
                child: Text('현재 게시글이 존재하지 않습니다.'),
              ));
  }
}
