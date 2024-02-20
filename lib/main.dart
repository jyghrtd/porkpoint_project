import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/apphomepage.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/havelecture.dart';
import 'package:porkpoint_project/lecturesearch.dart';
import 'package:porkpoint_project/loginpage.dart';
import 'package:porkpoint_project/mypage.dart';

var currentIndex = 0; // 현재 앱바 화면

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? currentBackPressTime;

  List<Widget> navIndexLogin = <Widget>[const AppHomePage(), const HaveLecture(), const Mypage()];

  List<Widget> navIndexLogout = <Widget>[
    const AppHomePage(),
    const LectureSearch(''), //모든 강의 출력
    const LoginPage()
  ];

  void pageSelect(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PorkPoint",
      home: Center(
        child: Scaffold(
          body: WillPopScope(
            onWillPop: onWillPop,
            child: loginOrNot
                ? navIndexLogin.elementAt(currentIndex)
                : navIndexLogout.elementAt(currentIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.dashboard),
                  label: loginOrNot ? 'MyLecture' : "LectureList"),
              BottomNavigationBarItem(
                icon: const Icon(Icons.emoji_people),
                label: loginOrNot ? "MyPage" : "Login",
              ),
            ],
            currentIndex: currentIndex,
            onTap: pageSelect,
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    DateTime nowTime = DateTime.now();

    if (currentBackPressTime == null ||
        nowTime.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = nowTime;
      Fluttertoast.showToast(msg: "'뒤로' 버튼을 한 번 더 누르시면 종료됩니다.", gravity: ToastGravity.BOTTOM);
      return false;
    }
    return true;

    SystemNavigator.pop();
  }
}
