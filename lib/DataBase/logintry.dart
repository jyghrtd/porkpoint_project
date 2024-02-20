import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

LoginTry loginTryFromJson(String str) => LoginTry.fromJson(json.decode(str));

String loginTryToJson(LoginTry data) => json.encode(data.toJson());

class LoginTry {
  int code;
  String message;
  UserInfo userInfo;

  LoginTry({
    required this.code,
    required this.message,
    required this.userInfo,
  });

  factory LoginTry.fromJson(Map<String, dynamic> json) => LoginTry(
        code: json["code"],
        message: json["message"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "userInfo": userInfo.toJson(),
      };
}

class UserInfo {
  String userId;
  String userName;
  String userEmail;
  String userCellPhone;
  // String userPassword;
  String userType;
  String userNickname;
  String userImage;

  UserInfo({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userCellPhone,
    // required this.userPassword,
    required this.userType,
    required this.userNickname,
    required this.userImage,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        userId: json["UserId"],
        userName: json["UserName"],
        userEmail: json["UserEmail"],
        userCellPhone: json["UserCellPhone"],
        // userPassword: json["UserPassword"],
        userType: json["UserType"],
        userNickname: json["UserNickname"],
        userImage: json["UserImage"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "UserName": userName,
        "UserEmail": userEmail,
        "UserCellPhone": userCellPhone,
        // "UserPassword": userPassword,
        "UserType": userType,
        "UserNickname": userNickname,
        "UserImage": userImage,
      };
}

class LoginData {
  static const String url = 'http://192.168.0.94:3000/login';

  static Future<LoginTry> getInfo(String userId, String userPassword) async {
    try {
      Map data = {'UserId': userId, 'UserPassword': userPassword};

      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final LoginTry loginTry = loginTryFromJson(response.body);
        //print(loginTry.userInfo);
        return loginTry;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return LoginTry(
            code: response.statusCode,
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
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return LoginTry(
          code: e.hashCode,
          message: e.toString(),
          userInfo: UserInfo(
              userId: '',
              userName: '',
              userEmail: '',
              userCellPhone: '',
              // userPassword: '',
              userType: '',
              userNickname: '',
              userImage: ''));
    }
  }
}
