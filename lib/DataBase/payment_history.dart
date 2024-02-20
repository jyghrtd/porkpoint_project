import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

PaymentHistory paymentHistoryFromJson(String str) => PaymentHistory.fromJson(json.decode(str));

String paymentHistoryToJson(PaymentHistory data) => json.encode(data.toJson());

class PaymentHistory {
  int code;
  List<PaymentHistoryElement> paymentHistory;

  PaymentHistory({
    required this.code,
    required this.paymentHistory,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        code: json["code"],
        paymentHistory: List<PaymentHistoryElement>.from(
            json["payment_history"].map((x) => PaymentHistoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "payment_history": List<dynamic>.from(paymentHistory.map((x) => x.toJson())),
      };
}

class PaymentHistoryElement {
  int paymentId;
  String userId;
  int amount;
  DateTime paymentDate;
  int lectureId;
  String title;
  DateTime startDate;
  DateTime endDate;

  PaymentHistoryElement({
    required this.paymentId,
    required this.userId,
    required this.amount,
    required this.paymentDate,
    required this.lectureId,
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  factory PaymentHistoryElement.fromJson(Map<String, dynamic> json) => PaymentHistoryElement(
        paymentId: json["PaymentId"],
        userId: json["UserId"],
        amount: json["Amount"],
        paymentDate: DateTime.parse(json["PaymentDate"]),
        lectureId: json["LectureId"],
        title: json["Title"],
        startDate: DateTime.parse(json["StartDate"]),
        endDate: DateTime.parse(json["EndDate"]),
      );

  Map<String, dynamic> toJson() => {
        "PaymentId": paymentId,
        "UserId": userId,
        "Amount": amount,
        "PaymentDate": paymentDate.toIso8601String(),
        "LectureId": lectureId,
        "Title": title,
        "StartDate": startDate.toIso8601String(),
        "EndDate": endDate.toIso8601String(),
      };
}

class GetPaymentHistory {
  static const String url = 'http://192.168.0.94:3000/payment_history';

  static Future<PaymentHistory> getInfo(String userId) async {
    try {
      Map data = {
        "UserId": userId,
      };
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final PaymentHistory paymentHistory = paymentHistoryFromJson(response.body);
        return paymentHistory;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return PaymentHistory(code: response.statusCode, paymentHistory: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return PaymentHistory(code: 0, paymentHistory: []);
    }
  }
}
