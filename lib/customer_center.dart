import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/customercenterdata.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/inquity_to_center.dart';

class CustomerCenter extends StatefulWidget {
  const CustomerCenter({super.key});

  @override
  State<CustomerCenter> createState() => _CustomerCenterState();
}

class _CustomerCenterState extends State<CustomerCenter> {
  CustomerCenterData customerCenterData = CustomerCenterData(code: 0, customerCenter: []);
  MyInquiry myInquiry = MyInquiry(code: 0, communityPages: []);

  @override
  void initState() {
    super.initState();
    CCData.getInfo().then((value) {
      setState(() {
        customerCenterData = value;
      });
    });
    MyInquiryData.getInfo(loginUser.userInfo.userId).then((value) {
      myInquiry = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionArticle = ['자주 묻는 질문', '결제 관련 질문', '계정 관련 질문', '강의 관련 질문'];
    int categoryParent = questionArticle.length - 1;
    print(myInquiry.communityPages.length);

    return Scaffold(
      appBar: AppBarDefault('고객센터'),
      body: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ListView(
              children: [
                //자주묻는 질문 미구현
                TileShape(
                    questionArticle[0],
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            leading: Text('Q$index'),
                            title: Text('Question$index'),
                            children: [Text('Answer $index')],
                          );
                        })),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: categoryParent, //대분류 갯수
                  itemBuilder: (context, index) {
                    return eachCategory(questionArticle[index + 1], [
                      for (int i = 0; i < customerCenterData.customerCenter.length; i++)
                        if (customerCenterData.customerCenter[i].questionCategory == index + 1)
                          ExpansionTile(
                            childrenPadding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            title: Text(customerCenterData.customerCenter[i].questionTitle),
                            initiallyExpanded: false,
                            children: [Text(customerCenterData.customerCenter[i].description)],
                          )
                    ]);
                  },
                ),
                //내 문의사항 공간
                eachCategory('내 문의사항', [
                  if (myInquiry.communityPages.isNotEmpty)
                    for (int i = 0; i < myInquiry.communityPages.length; i++)
                      ExpansionTile(
                        childrenPadding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        title: Text(myInquiry.communityPages[i].postTitle),
                        trailing:
                            Text(myInquiry.communityPages[i].postTime.toString().substring(0, 11)),
                        initiallyExpanded: false,
                        children: [Text(myInquiry.communityPages[i].description)],
                      )
                  else
                    const Column(),
                ]),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      TransferMap(context, const InquiryToCenter());
                    },
                    child: const Text('문의하기'))
              ],
            ),
          )),
    );
  }

  ExpansionTile TileShape(String article, Widget widget) {
    return ExpansionTile(title: Text(article), initiallyExpanded: false, children: [widget]);
  }

  // ExpansionTile TileShape(String article, int itemCount, Widget Function(int) widget) {
  ExpansionTile eachCategory(String categoryName, List<Widget> childWidget) {
    return ExpansionTile(
        title: Text(categoryName),
        initiallyExpanded: false,
        childrenPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        children: childWidget);
  }
}
