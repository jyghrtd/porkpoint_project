import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/possiblelecture.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/lecturepage.dart';
import 'package:porkpoint_project/testfile/payment_test.dart';

class HaveLecture extends StatefulWidget {
  const HaveLecture({super.key});

  @override
  State<HaveLecture> createState() => _HaveLectureState();
}

class _HaveLectureState extends State<HaveLecture> {
  PossibleLecture possibleLecture = PossibleLecture(code: 0, mylecture: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PossibleLectureData.getInfo(loginUser.userInfo.userId).then((value) {
      setState(() {
        possibleLecture = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return possibleLecture.mylecture.isNotEmpty
        ? Scaffold(
            appBar: AppBarDefault('내 강의'),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "최근 강의",
                    style: TextStyle(fontSize: 30),
                  ),
                  const Row(
                    children: [Text("Have Lecture")],
                  ),
                  const Divider(),
                  const Text(
                    "보유 강의",
                    style: TextStyle(fontSize: 30),
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.all(10),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: possibleLecture.mylecture.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            TransferMap(
                                context, LecturePage(possibleLecture.mylecture[index].lectureId));
                          },
                          child: ListTile(
                            leading:
                                Image.network(possibleLecture.mylecture[index].lecturesImageUrl),
                            title: Text(possibleLecture.mylecture[index].title),
                            subtitle: Text(
                              possibleLecture.mylecture[index].description,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }),
                  ElevatedButton(
                      onPressed: () {
                        TransferMap(context, PaymentTest());
                      },
                      child: const Text('결제 내역 추가 테스트 페이지'))
                ],
              ),
            ))
        : Center(
            child: Column(
              children: [
                const Text('Loading...'),
                ElevatedButton(
                    onPressed: () {
                      TransferMap(context, PaymentTest());
                    },
                    child: const Text('결제 내역 추가 테스트 페이지'))
              ],
            ),
          );
  }
}
