import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/edituserinformation.dart';
import 'package:porkpoint_project/DataBase/logintry.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/main.dart';

class InformationManagement extends StatefulWidget {
  const InformationManagement({super.key});

  @override
  State<InformationManagement> createState() => _InformationManagementState();
}

class _InformationManagementState extends State<InformationManagement> {
  var userProfileImage = 'assets/img/blank-profile-picture-973460_640.png';

  TextEditingController nicknameController = TextEditingController();
  TextEditingController nowPassController = TextEditingController();
  TextEditingController changePassController = TextEditingController();
  TextEditingController passCheckController = TextEditingController();

//현재 프로필 이미지 관련은 미구현
  NameChange nameChange = NameChange(code: 0, message: '');
  PasswordChange passwordChange = PasswordChange(code: 0, message: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarDefault('개인정보 관리'),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                backgroundImage: AssetImage(userProfileImage),
                radius: 60,
              ),
              IconButton(
                onPressed: () {
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
                                CircleAvatar(
                                  backgroundImage: AssetImage(userProfileImage),
                                  radius: 60,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  userProfileImage,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(onPressed: () {}, child: const Text('이미지 선택'))
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () {}, child: const Text('확인')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소')),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.edit),
              ),
              ListTile(
                leading: const Text('   아이디'),
                title: Text(loginUser.userInfo.userId),
              ),
              ListTile(
                leading: const Text('   닉네임'),
                title: Text(loginUser.userInfo.userNickname),
                trailing: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('현재 닉네임'),
                                    Text(loginUser.userInfo.userNickname),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text('변경할 닉네임'),
                                    TextFormField(
                                      controller: nicknameController,
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      nameChange = await NameChangeTry.getInfo(
                                          nicknameController.text, loginUser.userInfo.userId);

                                      if (nameChange.code == 400) {
                                        Fluttertoast.showToast(msg: nameChange.message);
                                      } else if (nameChange.code == 200) {
                                        Fluttertoast.showToast(msg: '닉네임 변경에 성공하셨습니다.');
                                        // loginUser = await LoginData.getInfo(
                                        //     loginUser.userInfo.userId,
                                        //     loginUser.userInfo.userPassword); //정보 초기화는 나중으로
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('확인')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('취소')),
                              ],
                            );
                          }).then((value) {
                        setState(() {});
                      });
                    },
                    icon: const Icon(Icons.edit)),
              ),
              ListTile(
                leading: const Text('      이름'),
                title: Text(loginUser.userInfo.userName),
              ),
              ListTile(
                leading: const Text('전화번호'),
                title: Text(loginUser.userInfo.userCellPhone),
              ),
              ListTile(
                leading: const Text('   이메일'),
                title: Text(loginUser.userInfo.userEmail),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('현재 비밀번호'),
                                      TextFormField(
                                        controller: nowPassController,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Text('변경할 비밀번호'),
                                      TextFormField(
                                        //decoration: InputDecoration(isDense: true),
                                        controller: changePassController,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Text('비밀번호 확인'),
                                      TextFormField(
                                        controller: passCheckController,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        passwordChange = await PasswordChangeTry.getInfo(
                                            loginUser.userInfo.userId,
                                            nowPassController.text,
                                            changePassController.text,
                                            passCheckController.text);

                                        if (passwordChange.code == 400) {
                                          Fluttertoast.showToast(msg: passwordChange.message);
                                        } else if (passwordChange.code == 200) {
                                          Fluttertoast.showToast(msg: '비밀번호 변경에 성공하였습니다.');
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('확인')),
                                  TextButton(
                                      onPressed: () async {
                                        //예전 비밀번호를 확인용으로 보내도 꼬이고 변경 비밀번호를 보내도 꼬여서 작업이 다 끝난 이후 실행
                                        loginUser = await LoginData.getInfo(
                                            loginUser.userInfo.userId, nowPassController.text);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('취소')),
                                ],
                              );
                            }).then((value) {
                          setState(() {});
                        });
                      },
                      child: const Text('비밀번호 변경')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('완료')),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
