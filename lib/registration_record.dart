import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/payment_history.dart';
import 'package:porkpoint_project/frequentfunc.dart';

class RegistrationRecordPage extends StatefulWidget {
  const RegistrationRecordPage({super.key});

  @override
  State<RegistrationRecordPage> createState() => _RegistrationRecordPageState();
}

class _RegistrationRecordPageState extends State<RegistrationRecordPage> {
  PaymentHistory paymentHistory = PaymentHistory(code: 0, paymentHistory: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetPaymentHistory.getInfo(loginUser.userInfo.userId).then((value) {
      setState(() {
        paymentHistory = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(paymentHistory.paymentHistory.length);
    return Scaffold(
        appBar: AppBarDefault('결제 내역'),
        body: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentHistory.paymentHistory.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  //leading: ,
                  title: Text(paymentHistory.paymentHistory[index].title),
                  subtitle: Text(
                      "${paymentHistory.paymentHistory[index].startDate.toString().substring(0, 11)} ~ ${paymentHistory.paymentHistory[index].endDate.toString().substring(0, 11)}"),
                  trailing: Text("\￦" + paymentHistory.paymentHistory[index].amount.toString()),
                ),
              );
            })
        // BasicBoxForm(ListView(
        //   physics: const NeverScrollableScrollPhysics(),
        //   children: [
        //     Text(
        //       title,
        //       style: TextStyle(fontSize: 30),
        //     ),
        //     SizedBox(
        //       height: 40,
        //     ),
        //     Text(content)
        //   ],
        // )),
        );
  }
}
