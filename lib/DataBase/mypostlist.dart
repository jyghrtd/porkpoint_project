import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

MyPostList myPostListFromJson(String str) => MyPostList.fromJson(json.decode(str));

String myPostListToJson(MyPostList data) => json.encode(data.toJson());

class MyPostList {
  int code;
  List<MyPost> myPost;

  MyPostList({
    required this.code,
    required this.myPost,
  });

  factory MyPostList.fromJson(Map<String, dynamic> json) => MyPostList(
        code: json["code"],
        myPost: List<MyPost>.from(json["my_post"].map((x) => MyPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "my_post": List<dynamic>.from(myPost.map((x) => x.toJson())),
      };
}

class MyPost {
  int postId;
  String postTitle;
  String userId;
  int postType;
  DateTime postTime;

  MyPost({
    required this.postId,
    required this.postTitle,
    required this.userId,
    required this.postType,
    required this.postTime,
  });

  factory MyPost.fromJson(Map<String, dynamic> json) => MyPost(
        postId: json["PostId"],
        postTitle: json["PostTitle"],
        userId: json["UserId"],
        postType: json["PostType"],
        postTime: DateTime.parse(json["PostTime"]),
      );

  Map<String, dynamic> toJson() => {
        "PostId": postId,
        "PostTitle": postTitle,
        "UserId": userId,
        "PostType": postType,
        "PostTime": postTime.toIso8601String(),
      };
}

class MyPostData {
  static const String url = 'http://192.168.0.94:3000/mypost';

  static Future<MyPostList> getInfo(String userId) async {
    try {
      Map data = {"UserId": userId};
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final MyPostList myPostList = myPostListFromJson(response.body);
        return myPostList;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return MyPostList(code: response.statusCode, myPost: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return MyPostList(code: 0, myPost: []);
    }
  }
}
