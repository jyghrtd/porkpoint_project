import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

PaymentProcess paymentProcessFromJson(String str) => PaymentProcess.fromJson(json.decode(str));

String paymentProcessToJson(PaymentProcess data) => json.encode(data.toJson());

class PaymentProcess {
  int code;
  String message;

  PaymentProcess({
    required this.code,
    required this.message,
  });

  factory PaymentProcess.fromJson(Map<String, dynamic> json) => PaymentProcess(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class NewPayment {
  static const String url = 'http://192.168.0.94:3000/payment';

  static Future<PaymentProcess> getInfo(
      String userId, int amount, int lectureId, int attendanceRate, int payment) async {
    try {
      Map data = {
        "UserId": userId,
        "Amount": amount,
        "LectureId": lectureId,
        "AttendanceRate": attendanceRate,
        "Payment": payment
      };
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final PaymentProcess paymentProcess = paymentProcessFromJson(response.body);
        return paymentProcess;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return PaymentProcess(code: response.statusCode, message: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return PaymentProcess(code: 0, message: '');
    }
  }
}
