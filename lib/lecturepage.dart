import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/lecturedetail.dart';
import 'package:porkpoint_project/eachlecture.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lecturequestionlist.dart';

class LecturePage extends StatefulWidget {
  final int lectureNum;
  const LecturePage(this.lectureNum, {super.key});

  @override
  State<LecturePage> createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  late int nowLecture;

  LectureDetail lectureDetail = LectureDetail(
      code: 0,
      lecture: Lecture(
          lecturesImageUrl: '',
          title: '',
          description: '',
          attendanceRate: 0,
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
    nowLecture = widget.lectureNum;
    setState(() {
      LectureDetailData.getInfo(loginUser.userInfo.userId, widget.lectureNum).then((value) {
        setState(() {
          lectureDetail = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return lectureDetail.lectureToc.isNotEmpty
        ? Scaffold(
            appBar: AppBarDefault("강의 페이지"),
            body: Scrollbar(
              child: ListView(children: [
                Image.network(
                  lectureDetail.lecture.lecturesImageUrl,
                  fit: BoxFit.cover,
                ),
                //ProgressBar 추가
                Text(
                  lectureDetail.lecture.title,
                  style: const TextStyle(fontSize: 30),
                ),
                ExpansionTile(
                  childrenPadding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  title: const Text('강의 정보'),
                  initiallyExpanded: false,
                  children: [Text(lectureDetail.lecture.description)],
                ),
                ExpansionTile(
                  childrenPadding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  title: const Text('강사 정보'),
                  initiallyExpanded: false,
                  children: [
                    Text(lectureDetail.lecture.instructorName),
                    Text(lectureDetail.lecture.introduction),
                    Text(lectureDetail.lecture.email)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          TransferMap(
                              context, LectureQuestionList(nowLecture, loginUser.userInfo.userId));
                        },
                        child: const Text("내 질문 목록")),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          TransferMap(context, LectureQuestionList(nowLecture, ''));
                        },
                        child: const Text("전체 질문 목록")),
                  ],
                ),
                ListView.builder(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    primary: false, //스크롤 없애기
                    itemCount: lectureDetail.lectureToc.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: ListTile(
                          leading: Image.network(lectureDetail.lectureToc[index].thumbnail),
                          title: Text(lectureDetail.lectureToc[index].title),
                          subtitle: Text(lectureDetail.lectureToc[index].description),
                        ),
                        onTap: () {
                          TransferMap(
                              context,
                              EachLecture(lectureDetail.lectureToc[index].tocId,
                                  lectureDetail.lectureToc, nowLecture));
                        },
                      );
                    }),
              ]),
            ),
          )
        : const Center(
            child: Text('Loading...'),
          );
  }
}
