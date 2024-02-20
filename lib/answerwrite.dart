import 'package:flutter/material.dart';
import 'package:porkpoint_project/frequentfunc.dart';

class AnswerWrite extends StatefulWidget {
  const AnswerWrite({super.key});

  @override
  State<AnswerWrite> createState() => _AnswerWriteState();
}

class _AnswerWriteState extends State<AnswerWrite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault('답변 작성'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BasicBoxForm(
              const ListTile(
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "질문 제목",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('질문 내용'),
                    ]),
              ),
            ),
            const SizedBox(
                height: 300,
                width: 350,
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: '답변을 입력해주세요.'),
                  expands: true,
                  maxLines: null,
                ))
          ],
        ),
      ),
    );
  }
}
