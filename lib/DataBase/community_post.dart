import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

PostList postListFromJson(String str) => PostList.fromJson(json.decode(str));

String postListToJson(PostList data) => json.encode(data.toJson());

class PostList {
  int code;
  List<CommunityPages> communityPages;

  PostList({
    required this.code,
    required this.communityPages,
  });

  factory PostList.fromJson(Map<String, dynamic> json) => PostList(
        code: json["code"],
        communityPages: List<CommunityPages>.from(
            json["community_pages"].map((x) => CommunityPages.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "community_pages": List<dynamic>.from(communityPages.map((x) => x.toJson())),
      };
}

class CommunityPages {
  int postId;
  String postTitle;
  String userId;
  int postType;
  DateTime postTime;

  CommunityPages({
    required this.postId,
    required this.postTitle,
    required this.userId,
    required this.postType,
    required this.postTime,
  });

  factory CommunityPages.fromJson(Map<String, dynamic> json) => CommunityPages(
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

class CommunitySearchData {
  static const String url = 'http://192.168.0.94:3000/community';

  static Future<PostList> getInfo(int postType) async {
    final response;
    try {
      postType == 0
          ? response = await http.get(Uri.parse(url))
          : response = await http.get(Uri.parse('$url?PostType=$postType'));

      if (response.statusCode == 200) {
        final PostList questionList = postListFromJson(response.body);
        return questionList;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return PostList(code: 0, communityPages: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return PostList(code: 0, communityPages: []);
    }
  }
}
