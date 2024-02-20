import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/explain_lecture.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/payment.dart';

class LectureIntroduce extends StatefulWidget {
  final int id;
  const LectureIntroduce(this.id, {super.key});

  @override
  State<LectureIntroduce> createState() => _LectureIntroduceState();
}

class _LectureIntroduceState extends State<LectureIntroduce> {
  ExplainLecture getLec = ExplainLecture(
      code: 0,
      lectureExplain: LectureExplain(
          lecturesImageUrl: '',
          title: '',
          description: '',
          instructorId: 0,
          instructorName: '',
          email: '',
          introduction: '',
          comment: '',
          image: ''),
      lectureToc: []);

  @override
  void initState() {
    super.initState();
    ExplainLectureData.getInfo(widget.id).then((value) {
      setState(() {
        getLec = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int bottomIndex = 0;
    print(getLec.lectureToc.length);

    String ect = "default"; //ect

    return Scaffold(
      body: getLec.lectureExplain.title.isNotEmpty
          ? Scrollbar(
              controller: ScrollController(),
              thickness: 5,
              child: ListView(
                controller: ScrollController(),
                children: [
                  Image.network(
                    getLec.lectureExplain.lecturesImageUrl, //이후 다른 이미지가 될 것
                    fit: BoxFit.cover,
                  ),
                  Text(
                    getLec.lectureExplain.title,
                    style: const TextStyle(fontSize: 30),
                  ),
                  const Divider(),
                  Text(getLec.lectureExplain.description),
                  const Divider(),
                  BasicBoxForm(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('강사 정보', style: TextStyle(fontSize: 20)),
                        Text(' -강사명: ${getLec.lectureExplain.instructorName}\n'),
                        Text(' -경력\n${getLec.lectureExplain.introduction}\n'),
                        Text('강사의 한마디\n${getLec.lectureExplain.comment}\n\n -강의목차'),
                        for (int i = 0; i < getLec.lectureToc.length; i++)
                          Text(getLec.lectureToc[i].title),
                        Text(ect),
                      ],
                    ),
                  )
                ],
              ))
          : const Center(
              child: Text('Loading...'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: "뒤로가기"),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: "강의 신청하기")
        ],
        currentIndex: bottomIndex,
        onTap: (index) {
          setState(() {
            bottomIndex = index;
          });

          if (bottomIndex == 0) {
            Navigator.pop(context);
          } else if (bottomIndex == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment()));
          }
        },
      ),
    );
  }
}
