import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

MyProfile myProfileFromJson(String str) => MyProfile.fromJson(json.decode(str));

String myProfileToJson(MyProfile data) => json.encode(data.toJson());

class MyProfile {
  int code;
  Profile profile;

  MyProfile({
    required this.code,
    required this.profile,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) => MyProfile(
        code: json["code"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "profile": profile.toJson(),
      };
}

class Profile {
  String userImage;
  String userId;
  String userName;
  String userCellPhone;
  String userEmail;

  Profile({
    required this.userImage,
    required this.userId,
    required this.userName,
    required this.userCellPhone,
    required this.userEmail,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        userImage: json["UserImage"],
        userId: json["UserId"],
        userName: json["UserName"],
        userCellPhone: json["UserCellPhone"],
        userEmail: json["UserEmail"],
      );

  Map<String, dynamic> toJson() => {
        "UserImage": userImage,
        "UserId": userId,
        "UserName": userName,
        "UserCellPhone": userCellPhone,
        "UserEmail": userEmail,
      };
}

class MyProfileData {
  static const String url = 'http://192.168.0.94:3000/profile';

  static Future<MyProfile> getInfo(String userId) async {
    try {
      Map data = {"UserId": userId};
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final MyProfile myProfile = myProfileFromJson(response.body);
        return myProfile;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return MyProfile(
            code: response.statusCode,
            profile: Profile(
                userImage: '',
                userId: '',
                userName: '',
                userCellPhone: '',
                userEmail: ''));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return MyProfile(
          code: 0,
          profile: Profile(
              userImage: '',
              userId: '',
              userName: '',
              userCellPhone: '',
              userEmail: ''));
    }
  }
}

//닉네임 변경
NameChange nameChangeFromJson(String str) =>
    NameChange.fromJson(json.decode(str));

String nameChangeToJson(NameChange data) => json.encode(data.toJson());

class NameChange {
  int code;
  String message;

  NameChange({
    required this.code,
    required this.message,
  });

  factory NameChange.fromJson(Map<String, dynamic> json) => NameChange(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class NameChangeTry {
  static const String url = 'http://192.168.0.94:3000/namechange';

  static Future<NameChange> getInfo(String userNickname, String userId) async {
    try {
      Map data = {"UserNickname": userNickname, "UserId": userId};
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final NameChange nameChange = nameChangeFromJson(response.body);
        return nameChange;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return NameChange(
            code: response.statusCode,
            message: 'Error occurred. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return NameChange(code: 0, message: '');
    }
  }
}

//비밀번호 변경
PasswordChange passwordChangeFromJson(String str) =>
    PasswordChange.fromJson(json.decode(str));

String passwordChangeToJson(PasswordChange data) => json.encode(data.toJson());

class PasswordChange {
  int code;
  String message;

  PasswordChange({
    required this.code,
    required this.message,
  });

  factory PasswordChange.fromJson(Map<String, dynamic> json) => PasswordChange(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class PasswordChangeTry {
  static const String url = 'http://192.168.0.94:3000/passwordchange';

  static Future<PasswordChange> getInfo(String userId, String userPassword,
      String changePassword, String passwordCheck) async {
    try {
      Map data = {
        "UserId": userId,
        "UserPassword": userPassword,
        "ChangePassword": changePassword,
        "PasswordCheck": passwordCheck
      };
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final PasswordChange passwordChange =
            passwordChangeFromJson(response.body);
        return passwordChange;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return PasswordChange(
            code: response.statusCode,
            message: 'Error occurred. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return PasswordChange(code: 0, message: '');
    }
  }
}
