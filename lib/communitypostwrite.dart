import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/postwrite.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lectureevaluation.dart';
import 'package:porkpoint_project/qnapost.dart';

class CommunityPostWrite extends StatefulWidget {
  const CommunityPostWrite({super.key});

  @override
  State<CommunityPostWrite> createState() => _CommunityPostWriteState();
}

class _CommunityPostWriteState extends State<CommunityPostWrite> {
  String? selectedValue;
  PostWrite postWrite = PostWrite(code: 0, message: '');

  @override
  Widget build(BuildContext context) {
    TextEditingController titleEdit = TextEditingController();
    TextEditingController contentEdit = TextEditingController();
    final postState = ["질문답변 목록", "강의평가"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('질문 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: '제목을 입력해주세요.', border: OutlineInputBorder()),
                    controller: titleEdit,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
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
                        selectedValue = value!;
                      });
                    })),
              ],
            ),
            const SizedBox(
              height: 15,
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

                  int selectedPostType = 0;
                  if (selectedValue == postState[0]) {
                    selectedPostType = 1;
                  } else if (selectedValue == postState[1]) {
                    selectedPostType = 2;
                  }

                  postWrite = await PostWriteData.getInfo(loginUser.userInfo.userId,
                      selectedPostType, titleEdit.text, contentEdit.text, null, null);

                  print(postWrite.code);

                  if (postWrite.code == 200) {
                    GoWritePage writePageData = await WritePageData.getInfo(
                        loginUser.userInfo.userId,
                        selectedPostType,
                        titleEdit.text,
                        contentEdit.text);

                    if (writePageData.pageType == 1) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => QnAPost(writePageData.pageId)));
                    } else if (writePageData.pageType == 2) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LectureEvaluation(writePageData.pageId)));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(120, 50)),
                child: const Text("글 작성"))
          ]),
        ),
      ),
    );
  }
}
