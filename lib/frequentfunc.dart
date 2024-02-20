import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/logintry.dart';
import 'package:porkpoint_project/main.dart';

Color? appbarColor = Colors.blue[300];

//로그인 정보 전역변수 선언
LoginTry loginUser = LoginTry(
    code: -1,
    message: '',
    userInfo: UserInfo(
        userId: '',
        userName: '',
        userEmail: '',
        userCellPhone: '',
        // userPassword: '',
        userType: '',
        userNickname: '',
        userImage: ''));
var loginOrNot = false; // 로그인 여부

//화면 이동 간략화
void TransferMap(BuildContext context, Widget className) {
  Navigator.push(context,
      MaterialPageRoute(fullscreenDialog: true, builder: (BuildContext context) => className));
}

//박스 컨테이너 기본 틀
Container BasicBoxForm(Widget child) {
  return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child);
}

//채팅 시 이름과 메시지 크기 지정 간략화
Column ChattingText(String name, String comment) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: const TextStyle(fontSize: 20),
      ),
      Text(comment)
    ],
  );
}

AppBar AppBarDefault(String appbarName) {
  return AppBar(
    backgroundColor: appbarColor,
    title: Text(appbarName),
  );
}

void ActionFailedDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인')),
          ],
        );
      });
  return;
}

void Logout(BuildContext context) {
  loginOrNot = false;
  loginUser = LoginTry(
      code: -1,
      message: '',
      userInfo: UserInfo(
          userId: '',
          userName: '',
          userEmail: '',
          userCellPhone: '',
          // userPassword: '',
          userType: '',
          userNickname: '',
          userImage: ''));
  currentIndex = 0;
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MyApp()),
  );
}
