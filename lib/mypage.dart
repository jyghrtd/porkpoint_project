import 'package:flutter/material.dart';
import 'package:porkpoint_project/customer_center.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/infomationmanagement.dart';
import 'package:porkpoint_project/mypage_post.dart';
import 'package:porkpoint_project/noticepage.dart';
import 'package:porkpoint_project/registration_record.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  final buttonName = ['고객 센터', '내 작성글', '공지 사항', '결제 내역', '회사 정보'];
  final buttonLink = [
    const CustomerCenter(),
    const MyPagePost(),
    const NoticePage(),
    const RegistrationRecordPage(),
    const MyPageInPost('회사 정보', 'PorkPoint App', '회사 설명')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault('마이 페이지'),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/img/blank-profile-picture-973460_640.png'),
                radius: 60,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                loginUser.userInfo.userId,
                style: const TextStyle(fontSize: 40),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InformationManagement(),
                      )).then((value) {
                    setState(() {});
                  });
                },
                child: const Text('개인정보 관리')),
          ),
          ListView.builder(
              itemCount: buttonName.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: ElevatedButton(
                      onPressed: () {
                        TransferMap(context, buttonLink[index]);
                      },
                      child: Text(buttonName[index])),
                );
              }),
          ElevatedButton(
              onPressed: () {
                Logout(context);
              },
              child: const Text('로그아웃'))
        ]),
      ),
    );
  }
}

class MyPageInPost extends StatefulWidget {
  final String appBarTitle;
  final String title;
  final String content;
  const MyPageInPost(this.appBarTitle, this.title, this.content, {super.key});

  @override
  State<MyPageInPost> createState() => _MyPageInPostState();
}

class _MyPageInPostState extends State<MyPageInPost> {
  late String appBarTitle;
  late String title;
  late String content;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appBarTitle = widget.appBarTitle;
    title = widget.title;
    content = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(appBarTitle),
      body: BasicBoxForm(ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 40,
          ),
          Text(content)
        ],
      )),
    );
  }
}
