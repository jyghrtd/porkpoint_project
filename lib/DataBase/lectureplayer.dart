import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

LecturePlayer lecturePlayerFromJson(String str) => LecturePlayer.fromJson(json.decode(str));

String lecturePlayerToJson(LecturePlayer data) => json.encode(data.toJson());

class LecturePlayer {
  int code;
  TocMaterial tocMaterial;
  List<Comment> comment;

  LecturePlayer({
    required this.code,
    required this.tocMaterial,
    required this.comment,
  });

  factory LecturePlayer.fromJson(Map<String, dynamic> json) => LecturePlayer(
        code: json["code"],
        tocMaterial: TocMaterial.fromJson(json["tocMaterial"]),
        comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "tocMaterial": tocMaterial.toJson(),
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
      };
}

class Comment {
  String userId;
  DateTime inputTime;
  String commentInfo;

  Comment({
    required this.userId,
    required this.inputTime,
    required this.commentInfo,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["UserId"],
        inputTime: DateTime.parse(json["InputTime"]),
        commentInfo: json["CommentInfo"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "InputTime": inputTime.toIso8601String(),
        "CommentInfo": commentInfo,
      };
}

class TocMaterial {
  int tocId;
  String title;
  String description;
  int videoLength;
  int complete;
  int timeProcess;
  String materialType;
  String materialUrl;

  TocMaterial({
    required this.tocId,
    required this.title,
    required this.description,
    required this.videoLength,
    required this.complete,
    required this.timeProcess,
    required this.materialType,
    required this.materialUrl,
  });

  factory TocMaterial.fromJson(Map<String, dynamic> json) => TocMaterial(
        tocId: json["TOCId"],
        title: json["Title"],
        description: json["Description"],
        videoLength: json["VideoLength"],
        complete: json["Complete"],
        timeProcess: json["TimeProcess"],
        materialType: json["MaterialType"],
        materialUrl: json["MaterialURL"],
      );

  Map<String, dynamic> toJson() => {
        "TOCId": tocId,
        "Title": title,
        "Description": description,
        "VideoLength": videoLength,
        "Complete": complete,
        "TimeProcess": timeProcess,
        "MaterialType": materialType,
        "MaterialURL": materialUrl,
      };
}

class LecturePlayerData {
  static const String url = 'http://192.168.0.94:3000/eachlecture';

  static Future<LecturePlayer> getInfo(int TOCId) async {
    try {
      Map data = {"TOCId": TOCId};
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final LecturePlayer lecturePlayer = lecturePlayerFromJson(response.body);
        return lecturePlayer;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return LecturePlayer(
            code: response.statusCode,
            comment: [],
            tocMaterial: TocMaterial(
                tocId: 0,
                title: '',
                description: '',
                videoLength: 0,
                complete: 0,
                timeProcess: 0,
                materialType: '',
                materialUrl: ''));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return LecturePlayer(
          code: 0,
          comment: [],
          tocMaterial: TocMaterial(
              tocId: 0,
              title: '',
              description: '',
              videoLength: 0,
              complete: 0,
              timeProcess: 0,
              materialType: '',
              materialUrl: ''));
    }
  }
}

AddLectureComment addLectureCommentFromJson(String str) =>
    AddLectureComment.fromJson(json.decode(str));

String addLectureCommentToJson(AddLectureComment data) => json.encode(data.toJson());

class AddLectureComment {
  int code;
  String message;

  AddLectureComment({
    required this.code,
    required this.message,
  });

  factory AddLectureComment.fromJson(Map<String, dynamic> json) => AddLectureComment(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class AddLectureCommentData {
  static const String url = 'http://192.168.0.94:3000/addlecturecomment';

  static Future<AddLectureComment> getInfo(String userId, int tocId, String commentInfo) async {
    try {
      Map data = {'UserId': userId, 'TOCId': tocId, 'CommentInfo': commentInfo};

      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final AddLectureComment addLectureComment = addLectureCommentFromJson(response.body);
        //print(loginTry.userInfo);
        return addLectureComment;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return AddLectureComment(code: response.statusCode, message: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return AddLectureComment(code: 0, message: '');
    }
  }
}
