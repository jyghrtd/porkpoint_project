import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

JoinTry joinTryFromJson(String str) => JoinTry.fromJson(json.decode(str));

String joinTryToJson(JoinTry data) => json.encode(data.toJson());

class JoinTry {
  int code;
  String message;

  JoinTry({
    required this.code,
    required this.message,
  });

  factory JoinTry.fromJson(Map<String, dynamic> json) => JoinTry(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class JoinData {
  static const String url = 'http://192.168.0.94:3000/join';

  static Future<JoinTry> getInfo(
      String userId,
      String userEmail,
      String userPassword,
      String userName,
      String userNickname,
      String userCellPhone,
      String userType,
      String userImage) async {
    try {
      Map data = {
        "UserId": userId,
        "UserEmail": userEmail,
        "UserPassword": userPassword,
        "UserName": userName,
        "UserNickname": userNickname,
        "UserCellPhone": userCellPhone,
        "UserType": userType,
        "UserImage": userImage
      };
      print('data ' + data.toString());

      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final JoinTry joinTry = joinTryFromJson(response.body);
        return joinTry;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return JoinTry(
          code: response.statusCode,
          message: 'Error occurred. Please try again.',
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return JoinTry(
        code: e.hashCode,
        message: e.toString(),
      );
    }
  }
}
