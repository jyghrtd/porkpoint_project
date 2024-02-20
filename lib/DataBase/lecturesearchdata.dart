import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

LecturesSearch lecturesSearchFromJson(String str) => LecturesSearch.fromJson(json.decode(str));

String lecturesSearchToJson(LecturesSearch data) => json.encode(data.toJson());

class LecturesSearch {
  int code;
  List<Lecture> lecture;

  LecturesSearch({
    required this.code,
    required this.lecture,
  });

  factory LecturesSearch.fromJson(Map<String, dynamic> json) => LecturesSearch(
        code: json["code"],
        lecture: List<Lecture>.from(json["Lecture"].map((x) => Lecture.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "Lecture": List<dynamic>.from(lecture.map((x) => x.toJson())),
      };
}

class Lecture {
  String lecturesImageUrl;
  String title;
  int lectureId;
  String description;

  Lecture({
    required this.lecturesImageUrl,
    required this.title,
    required this.lectureId,
    required this.description,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
        lecturesImageUrl: json["LecturesImageUrl"],
        title: json["Title"],
        lectureId: json["LectureId"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "LecturesImageUrl": lecturesImageUrl,
        "Title": title,
        "LectureId": lectureId,
        "Description": description,
      };
}

class LecturesSearchData {
  static const String url = 'http://192.168.0.94:3000/lecturesearch';

  static Future<LecturesSearch> getInfo(String title) async {
    try {
      final response = await http.get(Uri.parse('$url?Title=$title'));

      if (response.statusCode == 200) {
        final LecturesSearch lecturesSearch = lecturesSearchFromJson(response.body);
        return lecturesSearch;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return LecturesSearch(code: response.statusCode, lecture: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return LecturesSearch(code: 0, lecture: []);
    }
  }
}
