import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

PossibleLecture possibleLectureFromJson(String str) =>
    PossibleLecture.fromJson(json.decode(str));

String possibleLectureToJson(PossibleLecture data) =>
    json.encode(data.toJson());

class PossibleLecture {
  int code;
  List<Mylecture> mylecture;

  PossibleLecture({
    required this.code,
    required this.mylecture,
  });

  factory PossibleLecture.fromJson(Map<String, dynamic> json) =>
      PossibleLecture(
        code: json["code"],
        mylecture: List<Mylecture>.from(
            json["mylecture"].map((x) => Mylecture.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mylecture": List<dynamic>.from(mylecture.map((x) => x.toJson())),
      };
}

class Mylecture {
  int lectureId;
  String lecturesImageUrl;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;

  Mylecture({
    required this.lectureId,
    required this.lecturesImageUrl,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory Mylecture.fromJson(Map<String, dynamic> json) => Mylecture(
        lectureId: json["LectureId"],
        lecturesImageUrl: json["LecturesImageUrl"],
        title: json["Title"],
        description: json["Description"],
        startDate: DateTime.parse(json["StartDate"]),
        endDate: DateTime.parse(json["EndDate"]),
      );

  Map<String, dynamic> toJson() => {
        "LectureId": lectureId,
        "LecturesImageUrl": lecturesImageUrl,
        "Title": title,
        "Description": description,
        "StartDate": startDate.toIso8601String(),
        "EndDate": endDate.toIso8601String(),
      };
}

class PossibleLectureData {
  static const String url = 'http://192.168.0.94:3000/mylecture';

  static Future<PossibleLecture> getInfo(String userId) async {
    try {
      Map data = {"UserId": userId};
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final PossibleLecture possibleLecture =
            possibleLectureFromJson(response.body);
        return possibleLecture;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return PossibleLecture(code: response.statusCode, mylecture: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return PossibleLecture(code: 0, mylecture: []);
    }
  }
}
