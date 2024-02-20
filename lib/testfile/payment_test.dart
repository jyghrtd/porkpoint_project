import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porkpoint_project/DataBase/payment_history.dart';
import 'package:porkpoint_project/DataBase/payment_process.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/payment.dart';

class PaymentTest extends StatefulWidget {
  const PaymentTest({super.key});

  @override
  State<PaymentTest> createState() => _PaymentTestState();
}

class _PaymentTestState extends State<PaymentTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            //중복결제 여부도 확인해야 할듯
            PaymentProcess payment =
                await NewPayment.getInfo(loginUser.userInfo.userId, 99000, 2, 0, 1);

            if (payment.code == 200) {
              Fluttertoast.showToast(msg: "정상적으로 결제되엇습니다.");
              //정상 작동. 위쪽에 중복결제 여부 확인 필요.
            }
          },
          child: const Text('결제 내역 추가 테스트 버튼'),
        ),
      ),
    );
  }
}
