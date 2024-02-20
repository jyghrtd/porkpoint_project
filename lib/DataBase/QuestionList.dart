import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

QuestionList questionListFromJson(String str) => QuestionList.fromJson(json.decode(str));

String questionListToJson(QuestionList data) => json.encode(data.toJson());

class QuestionList {
  int code;
  List<LectureQuestion> lectureQuestion;

  QuestionList({
    required this.code,
    required this.lectureQuestion,
  });

  factory QuestionList.fromJson(Map<String, dynamic> json) => QuestionList(
        code: json["code"],
        lectureQuestion: List<LectureQuestion>.from(
            json["lecture_question"].map((x) => LectureQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "lecture_question": List<dynamic>.from(lectureQuestion.map((x) => x.toJson())),
      };
}

class LectureQuestion {
  int postId;
  String userId;
  int postType;
  DateTime postTime;
  String description;
  String postTitle;
  int answerCheck;
  int lectureId;

  LectureQuestion({
    required this.postId,
    required this.userId,
    required this.postType,
    required this.postTime,
    required this.description,
    required this.postTitle,
    required this.answerCheck,
    required this.lectureId,
  });

  factory LectureQuestion.fromJson(Map<String, dynamic> json) => LectureQuestion(
        postId: json["PostId"],
        userId: json["UserId"],
        postType: json["PostType"],
        postTime: DateTime.parse(json["PostTime"]),
        description: json["Description"],
        postTitle: json["PostTitle"],
        answerCheck: json["AnswerCheck"],
        lectureId: json["LectureId"],
      );

  Map<String, dynamic> toJson() => {
        "PostId": postId,
        "UserId": userId,
        "PostType": postType,
        "PostTime": postTime.toIso8601String(),
        "Description": description,
        "PostTitle": postTitle,
        "AnswerCheck": answerCheck,
        "LectureId": lectureId,
      };
}

//이후 내부 변수값을 바꿔 커뮤니티 계열 공통 함수로 사용해야 할듯. 질문 계열과 일반 게시글 계열을 나눠서.(AnswerCheck와 LectureId 존재여부 때문)
class CommunitySearchData {
  static const String url = 'http://192.168.0.94:3000/lecturequestion';

  static Future<QuestionList> getInfo(int lectureId, String userId) async {
    final response;
    try {
      userId.isEmpty
          ? response = await http.get(Uri.parse('$url?LectureId=$lectureId'))
          : response = await http.get(Uri.parse('$url?LectureId=$lectureId&UserId="$userId"'));

      if (response.statusCode == 200) {
        final QuestionList questionList = questionListFromJson(response.body);
        return questionList;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return QuestionList(code: response.statusCode, lectureQuestion: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return QuestionList(code: 0, lectureQuestion: []);
    }
  }
}
