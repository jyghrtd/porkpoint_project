import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/logintry.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/join.dart';
import 'package:porkpoint_project/mypage.dart';
import 'package:porkpoint_project/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController inputId = TextEditingController();
  TextEditingController inputPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: BasicBoxForm(
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.man_4),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(hintText: " UserName"),
                      controller: inputId,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.key),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      decoration: const InputDecoration(hintText: " ****"),
                      controller: inputPass,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(10.0)),
                  const Text(
                    "아이디ㆍ비밀번호 찾기",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const Join()));
                      },
                      child: const Text("회원가입")),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    LoginTry value = await LoginData.getInfo(inputId.text, inputPass.text);
                    setState(() {
                      loginUser = value;
                    });
                    print(
                        '${loginUser.code}\n${loginUser.message}\n${inputId.text}\n${inputPass.text}');

                    if (loginUser.userInfo.userId.isNotEmpty) {
                      setState(() {
                        loginOrNot = true;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    } else {
                      Fluttertoast.showToast(msg: loginUser.message);
                    }
                  },
                  child: const Text("로그인")),
            ],
          ),
        ),
      )),
    );
  }
}
