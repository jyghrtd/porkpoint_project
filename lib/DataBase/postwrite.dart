import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

PostWrite postWriteFromJson(String str) => PostWrite.fromJson(json.decode(str));

String postWriteToJson(PostWrite data) => json.encode(data.toJson());

class PostWrite {
  int code;
  String message;

  PostWrite({
    required this.code,
    required this.message,
  });

  factory PostWrite.fromJson(Map<String, dynamic> json) => PostWrite(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class PostWriteData {
  static const String url = 'http://192.168.0.94:3000/postwrite';

  static Future<PostWrite> getInfo(String userId, int postType, String postTitle,
      String description, int? answerCheck, int? lectureId) async {
    try {
      Map data = {
        "UserId": userId,
        "PostType": postType,
        "PostTitle": postTitle,
        "Description": description,
        "AnswerCheck": answerCheck,
        "LectureId": lectureId
      };
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final PostWrite postWrite = postWriteFromJson(response.body);
        return postWrite;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return PostWrite(code: response.statusCode, message: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return PostWrite(code: 0, message: '');
    }
  }
}

//작성한 페이지로 이동
GoWritePage goWritePageFromJson(String str) => GoWritePage.fromJson(json.decode(str));

String goWritePageToJson(GoWritePage data) => json.encode(data.toJson());

class GoWritePage {
  int code;
  int pageId;
  int pageType;

  GoWritePage({
    required this.code,
    required this.pageId,
    required this.pageType,
  });

  factory GoWritePage.fromJson(Map<String, dynamic> json) => GoWritePage(
        code: json["code"],
        pageId: json["pageId"],
        pageType: json["pageType"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "pageId": pageId,
        "pageType": pageType,
      };
}

class WritePageData {
  static const String url = 'http://192.168.0.94:3000/gowritepage';

  static Future<GoWritePage> getInfo(
      String userId, int postType, String postTitle, String description) async {
    try {
      Map data = {
        "UserId": userId,
        "PostType": postType,
        "PostTitle": postTitle,
        "Description": description,
      };
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final GoWritePage goWritePage = goWritePageFromJson(response.body);
        return goWritePage;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return GoWritePage(code: response.statusCode, pageId: 0, pageType: 0);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return GoWritePage(code: 0, pageId: 0, pageType: 0);
    }
  }
}
