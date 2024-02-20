import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

LectureDetail lectureDetailFromJson(String str) => LectureDetail.fromJson(json.decode(str));

String lectureDetailToJson(LectureDetail data) => json.encode(data.toJson());

class LectureDetail {
  int code;
  Lecture lecture;
  List<LectureToc> lectureToc;

  LectureDetail({
    required this.code,
    required this.lecture,
    required this.lectureToc,
  });

  factory LectureDetail.fromJson(Map<String, dynamic> json) => LectureDetail(
        code: json["code"],
        lecture: Lecture.fromJson(json["lecture"]),
        lectureToc: List<LectureToc>.from(json["lecture_toc"].map((x) => LectureToc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "lecture": lecture.toJson(),
        "lecture_toc": List<dynamic>.from(lectureToc.map((x) => x.toJson())),
      };
}

class Lecture {
  String lecturesImageUrl;
  String title;
  String description;
  int attendanceRate;
  int instructorId;
  String instructorName;
  String email;
  String introduction;
  String comment;
  String image;

  Lecture({
    required this.lecturesImageUrl,
    required this.title,
    required this.description,
    required this.attendanceRate,
    required this.instructorId,
    required this.instructorName,
    required this.email,
    required this.introduction,
    required this.comment,
    required this.image,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
        lecturesImageUrl: json["LecturesImageUrl"],
        title: json["Title"],
        description: json["Description"],
        attendanceRate: json["AttendanceRate"],
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
        "AttendanceRate": attendanceRate,
        "InstructorId": instructorId,
        "InstructorName": instructorName,
        "Email": email,
        "Introduction": introduction,
        "Comment": comment,
        "Image": image,
      };
}

class LectureToc {
  int tocId;
  String title;
  String description;
  String thumbnail;
  int complete;

  LectureToc({
    required this.tocId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.complete,
  });

  factory LectureToc.fromJson(Map<String, dynamic> json) => LectureToc(
        tocId: json["TOCId"],
        title: json["Title"],
        description: json["Description"],
        thumbnail: json["Thumbnail"],
        complete: json["Complete"],
      );

  Map<String, dynamic> toJson() => {
        "TOCId": tocId,
        "Title": title,
        "Description": description,
        "Thumbnail": thumbnail,
        "Complete": complete,
      };
}

class LectureDetailData {
  static const String url = 'http://192.168.0.94:3000/lecture';

  static Future<LectureDetail> getInfo(String userId, int lectureId) async {
    try {
      Map data = {"UserId": userId, "LectureId": lectureId};
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final LectureDetail lectualDetail = lectureDetailFromJson(response.body);
        return lectualDetail;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return LectureDetail(
            code: 0,
            lecture: Lecture(
                lecturesImageUrl: '',
                title: '',
                description: '',
                attendanceRate: 0,
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
      return LectureDetail(
          code: 0,
          lecture: Lecture(
              lecturesImageUrl: '',
              title: '',
              description: '',
              attendanceRate: 0,
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
