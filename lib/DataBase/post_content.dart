import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

PostContent postContentsFromJson(String str) => PostContent.fromJson(json.decode(str));

String postContentToJson(PostContent data) => json.encode(data.toJson());

class PostContent {
  int code;
  CommunityPage communityPage;
  List<Comment> comment;

  PostContent({
    required this.code,
    required this.communityPage,
    required this.comment,
  });

  factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
        code: json["code"],
        communityPage: CommunityPage.fromJson(json["community_page"]),
        comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "community_page": communityPage.toJson(),
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
      };
}

class Comment {
  String userId;
  DateTime writeTime;
  String description;

  Comment({
    required this.userId,
    required this.writeTime,
    required this.description,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["UserId"],
        writeTime: DateTime.parse(json["WriteTime"]),
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "WriteTime": writeTime.toIso8601String(),
        "Description": description,
      };
}

class CommunityPage {
  String postTitle;
  String userId;
  int postType;
  DateTime postTime;
  String description;
  String userName;

  CommunityPage({
    required this.postTitle,
    required this.userId,
    required this.postType,
    required this.postTime,
    required this.description,
    required this.userName,
  });

  factory CommunityPage.fromJson(Map<String, dynamic> json) => CommunityPage(
        postTitle: json["PostTitle"],
        userId: json["UserId"],
        postType: json["PostType"],
        postTime: DateTime.parse(json["PostTime"]),
        description: json["Description"],
        userName: json["UserName"],
      );

  Map<String, dynamic> toJson() => {
        "PostTitle": postTitle,
        "UserId": userId,
        "PostType": postType,
        "PostTime": postTime.toIso8601String(),
        "Description": description,
        "UserName": userName,
      };
}

class PostContentData {
  static const String url = 'http://192.168.0.94:3000/communitypost';

  static Future<PostContent> getInfo(int postId) async {
    final response;
    try {
      response = await http.get(Uri.parse('$url?PostId=$postId'));

      if (response.statusCode == 200) {
        final PostContent postContents = postContentsFromJson(response.body);
        return postContents;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return PostContent(
            code: response.statusCode,
            communityPage: CommunityPage(
                postTitle: '',
                userId: '',
                postType: 0,
                postTime: DateTime(0),
                description: '',
                userName: ''),
            comment: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return PostContent(
          code: 0,
          communityPage: CommunityPage(
              postTitle: '',
              userId: '',
              postType: 0,
              postTime: DateTime(0),
              description: '',
              userName: ''),
          comment: []);
    }
  }
}

//코멘트 입력
NewComment newCommentFromJson(String str) => NewComment.fromJson(json.decode(str));

String newCommentToJson(NewComment data) => json.encode(data.toJson());

class NewComment {
  int code;
  String message;

  NewComment({
    required this.code,
    required this.message,
  });

  factory NewComment.fromJson(Map<String, dynamic> json) => NewComment(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class InputComment {
  static const String url = 'http://192.168.0.94:3000/addcomment';

  static Future<NewComment> getInfo(String userId, int postId, String description) async {
    try {
      Map data = {'UserId': userId, 'PostId': postId, 'Description': description};

      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final NewComment newComment = newCommentFromJson(response.body);
        return newComment;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return NewComment(code: response.statusCode, message: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return NewComment(code: 0, message: '');
    }
  }
}
