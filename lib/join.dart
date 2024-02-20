import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/main.dart';
import 'package:porkpoint_project/DataBase/jointry.dart';
import 'package:porkpoint_project/frequentfunc.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  bool? firstCheck = false;
  bool? secondCheck = false;
  bool? thirdCheck = false;
  List<TextEditingController> joinInfo = List.generate(6, (index) => TextEditingController());
  //아이디, 이메일, 비밀번호, 이름, 닉네임, 전화번호
  TextEditingController passwordConfirm = TextEditingController();

  JoinTry joinTry = JoinTry(code: 0, message: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
            child: BasicBoxForm(
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "회원가입",
                  style: TextStyle(fontSize: 30),
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "아이디"),
                  controller: joinInfo[0],
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "이메일"),
                  controller: joinInfo[1],
                ),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "비밀번호"),
                  controller: joinInfo[2],
                ),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "비밀번호 확인"),
                  controller: passwordConfirm,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "이름"),
                  controller: joinInfo[3],
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "닉네임"),
                  controller: joinInfo[4],
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "전화번호"),
                  controller: joinInfo[5],
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(
                    children: [
                      Checkbox(
                          value: firstCheck,
                          onChanged: (value) => setState(() {
                                firstCheck = value;
                              })),
                      const Text("약관 1"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: secondCheck,
                          onChanged: (value) => setState(() {
                                secondCheck = value;
                              })),
                      const Text("약관 2"),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            TransferMap(context, const Agreement());
                          },
                          child: const Text("보기"))
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: thirdCheck,
                          onChanged: (value) => setState(() {
                                thirdCheck = value;
                              })),
                      const Text("약관 3"),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const Agreement()))
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: const Text("보기"))
                    ],
                  ),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    if (joinInfo[2].text != passwordConfirm.text) {
                      print('비밀번호를 확인해 주십시오.'); //이건 showDialog로 변경한다.
                      return;
                    }

                    JoinTry value = await JoinData.getInfo(
                        joinInfo[0].text,
                        joinInfo[1].text,
                        joinInfo[2].text,
                        joinInfo[3].text,
                        joinInfo[4].text,
                        joinInfo[5].text,
                        'user',
                        'assets/img/blank-profile-picture-973460_640.png');
                    setState(() {
                      joinTry = value;
                    });

                    print(joinTry.code.toString() + joinTry.message);

                    if (joinTry.code == 200) {
                      Fluttertoast.showToast(msg: '회원가입 성공. 로그인하여 주세요.');
                      currentIndex = 0;
                      Navigator.pop(context, MaterialPageRoute(builder: (context) => MyApp()));
                    }
                  },
                  child: const Text("가입하기"),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InputTextBar(String textInfo) {
    return TextField(
      decoration: InputDecoration(hintText: textInfo),
    );
  }

  // Widget Checkbox({bool? value, required void Function(dynamic value) onChanged}, ) {
  //   return Row(
  //                         children: [
  //                           Checkbox(
  //                               value: firstCheck,
  //                               onChanged: (value) => setState(() {
  //                                     firstCheck = value;
  //                                   })),
  //                           const Text("약관 1"),
  //                         ],
  //                       );
  // }
}

class Agreement extends StatelessWidget {
  // 크기 변경의 필요성 있음
  const Agreement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(70.0),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: const Padding(
            padding: EdgeInsets.all(25.0),
            child: Text(
              "약관 페이지",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
