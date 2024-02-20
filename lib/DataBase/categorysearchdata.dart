import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

CategorySort categorySearchFromJson(String str) =>
    CategorySort.fromJson(json.decode(str));

String categotySearchToJson(CategorySort data) => json.encode(data.toJson());

class CategorySort {
  int code;
  List<Lecture> lecture;

  CategorySort({
    required this.code,
    required this.lecture,
  });

  factory CategorySort.fromJson(Map<String, dynamic> json) => CategorySort(
        code: json["code"],
        lecture: (json["Lecture"] as List<dynamic>?)
                ?.map((x) => Lecture.fromJson(x))
                .toList() ??
            [],
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

class CategorySearchData {
  static const String url = 'http://192.168.0.94:3000/categorysearch';

  static Future<CategorySort> getInfo(int categoryId) async {
    try {
      final response = await http.get(Uri.parse('$url?CategoryId=$categoryId'));
      print(response.body);

      if (response.statusCode == 200) {
        final CategorySort lecSearch = categorySearchFromJson(response.body);
        return lecSearch;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return CategorySort(code: response.statusCode, lecture: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return CategorySort(code: 0, lecture: []);
    }
  }
}
