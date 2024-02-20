import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Homepage homepageFromJson(String str) => Homepage.fromJson(json.decode(str));

String homepageToJson(Homepage data) => json.encode(data.toJson());

class Homepage {
  int code;
  List<Element> mainpageElement;
  List<Element> popularElement;
  List<NewPost> newPost;
  List<CategorySort> categorySort;

  Homepage({
    required this.code,
    required this.mainpageElement,
    required this.popularElement,
    required this.newPost,
    required this.categorySort,
  });

  factory Homepage.fromJson(Map<String, dynamic> json) => Homepage(
        code: json["code"],
        mainpageElement:
            List<Element>.from(json["mainpage_element"].map((x) => Element.fromJson(x))),
        popularElement: List<Element>.from(json["popular_element"].map((x) => Element.fromJson(x))),
        newPost: json["new_post"] != null
            ? List<NewPost>.from(json["new_post"].map((x) => NewPost.fromJson(x)))
            : [],
        categorySort:
            List<CategorySort>.from(json["categorySort"].map((x) => CategorySort.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mainpage_element": List<dynamic>.from(mainpageElement.map((x) => x.toJson())),
        "popular_element": List<dynamic>.from(popularElement.map((x) => x.toJson())),
        "new_post": List<dynamic>.from(newPost.map((x) => x.toJson())),
        "categorySort": List<dynamic>.from(categorySort.map((x) => x.toJson())),
      };
}

class CategorySort {
  String categoryName;
  int categoryParent;

  CategorySort({
    required this.categoryName,
    required this.categoryParent,
  });

  factory CategorySort.fromJson(Map<String, dynamic> json) => CategorySort(
        categoryName: json["CategoryName"],
        categoryParent: json["CategoryParent"],
      );

  Map<String, dynamic> toJson() => {
        "CategoryName": categoryName,
        "CategoryParent": categoryParent,
      };
}

class Element {
  String title;
  String lecturesImageUrl;
  int lectureId;
  int countPaymentsLectureId;

  Element({
    required this.title,
    required this.lecturesImageUrl,
    required this.lectureId,
    required this.countPaymentsLectureId,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        title: json["Title"],
        lecturesImageUrl: json["LecturesImageUrl"],
        lectureId: json["LectureId"],
        countPaymentsLectureId: json["count(Payments.LectureId)"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "LecturesImageUrl": lecturesImageUrl,
        "LectureId": lectureId,
        "count(Payments.LectureId)": countPaymentsLectureId,
      };
}

class NewPost {
  int postId;
  String postTitle;
  int postType;

  NewPost({
    required this.postId,
    required this.postTitle,
    required this.postType,
  });

  factory NewPost.fromJson(Map<String, dynamic> json) => NewPost(
        postId: json["PostId"],
        postTitle: json["PostTitle"],
        postType: json["PostType"],
      );

  Map<String, dynamic> toJson() => {
        "PostId": postId,
        "PostTitle": postTitle,
        "PostType": postType,
      };
}

class HomeScreenData {
  static const String url = 'http://192.168.0.94:3000/';

  static Future<Homepage> getInfo() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Homepage homepage = homepageFromJson(response.body);
        return homepage;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return Homepage(
            code: 0, mainpageElement: [], popularElement: [], categorySort: [], newPost: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return Homepage(
          code: 0, mainpageElement: [], popularElement: [], categorySort: [], newPost: []);
    }
  }
}
