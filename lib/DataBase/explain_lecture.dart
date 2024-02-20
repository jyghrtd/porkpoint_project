import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

ExplainLecture explainLectureFromJson(String str) => ExplainLecture.fromJson(json.decode(str));

String explainLectureToJson(ExplainLecture data) => json.encode(data.toJson());

class ExplainLecture {
  int code;
  LectureExplain lectureExplain;
  List<LectureToc> lectureToc;

  ExplainLecture({
    required this.code,
    required this.lectureExplain,
    required this.lectureToc,
  });

  factory ExplainLecture.fromJson(Map<String, dynamic> json) => ExplainLecture(
        code: json["code"],
        lectureExplain: LectureExplain.fromJson(json["lecture_explain"]),
        lectureToc: List<LectureToc>.from(json["LectureTOC"].map((x) => LectureToc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "lecture_explain": lectureExplain.toJson(),
        "LectureTOC": List<dynamic>.from(lectureToc.map((x) => x.toJson())),
      };
}

class LectureExplain {
  String lecturesImageUrl;
  String title;
  String description;
  int instructorId;
  String instructorName;
  String email;
  String introduction;
  String comment;
  String image;

  LectureExplain({
    required this.lecturesImageUrl,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.email,
    required this.introduction,
    required this.comment,
    required this.image,
  });

  factory LectureExplain.fromJson(Map<String, dynamic> json) => LectureExplain(
        lecturesImageUrl: json["LecturesImageUrl"],
        title: json["Title"],
        description: json["Description"],
        instructorId: json["InstructorId"],
        instructorName: json["InstructorName"],
        email: json["Email"],
        introduction: json["Introduction"],
        comment: json["Comment"],
        image: json["Image"],
      );

  Map<String, dynamic> toJson() => {
        "LecturesImageUrl": lecturesImageUrl,
        "Title": title,
        "Description": description,
        "InstructorId": instructorId,
        "InstructorName": instructorName,
        "Email": email,
        "Introduction": introduction,
        "Comment": comment,
        "Image": image,
      };
}

class LectureToc {
  String title;
  String description;

  LectureToc({
    required this.title,
    required this.description,
  });

  factory LectureToc.fromJson(Map<String, dynamic> json) => LectureToc(
        title: json["Title"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Description": description,
      };
}

class ExplainLectureData {
  static const String url = 'http://192.168.0.94:3000/explainlecture';

  static Future<ExplainLecture> getInfo(int lectureId) async {
    try {
      final response = await http.get(Uri.parse('$url?LectureId=$lectureId'),
          headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"});

      if (response.statusCode == 200) {
        final ExplainLecture explainLecture = explainLectureFromJson(response.body);
        return explainLecture;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return ExplainLecture(
            code: response.statusCode,
            lectureExplain: LectureExplain(
                lecturesImageUrl: '',
                title: '',
                description: '',
                instructorId: 0,
                instructorName: '',
                email: '',
                introduction: '',
                comment: '',
                image: ''),
            lectureToc: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return ExplainLecture(
          code: 0,
          lectureExplain: LectureExplain(
              lecturesImageUrl: '',
              title: '',
              description: '',
              instructorId: 0,
              instructorName: '',
              email: '',
              introduction: '',
              comment: '',
              image: ''),
          lectureToc: []);
    }
  }
}
