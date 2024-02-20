import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porkpoint_project/DataBase/postwrite.dart';
import 'package:porkpoint_project/frequentfunc.dart';

class InquiryToCenter extends StatefulWidget {
  const InquiryToCenter({super.key});

  @override
  State<InquiryToCenter> createState() => _InquiryToCenterState();
}

class _InquiryToCenterState extends State<InquiryToCenter> {
  String? selectedValue;
  PostWrite inquiryWrite = PostWrite(code: 0, message: '');

  @override
  Widget build(BuildContext context) {
    final postState = ['계정 관련', '강의 관련', '결제 관련'];
    TextEditingController titleEdit = TextEditingController();
    TextEditingController contentEdit = TextEditingController();

    return Scaffold(
      appBar: AppBarDefault("문의하기"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              child: ListTile(
                title: TextField(
                    controller: titleEdit,
                    decoration: const InputDecoration(
                        hintText: '제목을 입력해주세요.', border: OutlineInputBorder())),
                trailing: DropdownButton(
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
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 200,
              child: TextField(
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                    hintText: '문의하실 내용을 입력해주세요.', border: OutlineInputBorder()),
                keyboardType: TextInputType.multiline,
                controller: contentEdit,
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
                    selectedPostType = 4;
                  } else if (selectedValue == postState[1]) {
                    selectedPostType = 5;
                  } else if (selectedValue == postState[2]) {
                    selectedPostType = 6;
                  }

                  inquiryWrite = await PostWriteData.getInfo(loginUser.userInfo.userId,
                      selectedPostType, titleEdit.text, contentEdit.text, 0, null);

                  if (inquiryWrite.code == 200) {
                    Fluttertoast.showToast(msg: '정상적으로 접수되었습니다.');
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(120, 50)),
                child: const Text("문의 작성"))
          ]),
        ),
      ),
    );
  }
}
