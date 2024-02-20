import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

CustomerCenterData customerCenterDataFromJson(String str) =>
    CustomerCenterData.fromJson(json.decode(str));

String customerCenterDataToJson(CustomerCenterData data) => json.encode(data.toJson());

class CustomerCenterData {
  int code;
  List<CustomerCenter> customerCenter;

  CustomerCenterData({
    required this.code,
    required this.customerCenter,
  });

  factory CustomerCenterData.fromJson(Map<String, dynamic> json) => CustomerCenterData(
        code: json["code"],
        customerCenter: List<CustomerCenter>.from(
            json["customer_center"].map((x) => CustomerCenter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "customer_center": List<dynamic>.from(customerCenter.map((x) => x.toJson())),
      };
}

class CustomerCenter {
  int questionCategory;
  String questionTitle;
  String description;

  CustomerCenter({
    required this.questionCategory,
    required this.questionTitle,
    required this.description,
  });

  factory CustomerCenter.fromJson(Map<String, dynamic> json) => CustomerCenter(
        questionCategory: json["QuestionCategory"],
        questionTitle: json["QuestionTitle"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "QuestionCategory": questionCategory,
        "QuestionTitle": questionTitle,
        "Description": description,
      };
}

class CCData {
  static const String url = 'http://192.168.0.94:3000/customercenter';

  static Future<CustomerCenterData> getInfo() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final CustomerCenterData customerCenterData = customerCenterDataFromJson(response.body);
        return customerCenterData;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return CustomerCenterData(code: 0, customerCenter: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return CustomerCenterData(code: 0, customerCenter: []);
    }
  }
}

MyInquiry myInquiryFromJson(String str) => MyInquiry.fromJson(json.decode(str));

String myInquiryToJson(MyInquiry data) => json.encode(data.toJson());

class MyInquiry {
  int code;
  List<CommunityPage> communityPages;

  MyInquiry({
    required this.code,
    required this.communityPages,
  });

  factory MyInquiry.fromJson(Map<String, dynamic> json) => MyInquiry(
      code: json["code"],
      communityPages:
          List<CommunityPage>.from(json["community_pages"].map((x) => CommunityPage.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "code": code,
        "community_pages": List<dynamic>.from(communityPages.map((x) => x.toJson())),
      };
}

class CommunityPage {
  int postId;
  String postTitle;
  String userId;
  int postType;
  DateTime postTime;
  String description;

  CommunityPage({
    required this.postId,
    required this.postTitle,
    required this.userId,
    required this.postType,
    required this.postTime,
    required this.description,
  });

  factory CommunityPage.fromJson(Map<String, dynamic> json) => CommunityPage(
      postId: json["PostId"],
      postTitle: json["PostTitle"],
      userId: json["UserId"],
      postType: json["PostType"],
      postTime: DateTime.parse(json["PostTime"]),
      description: json["Description"]);

  Map<String, dynamic> toJson() => {
        "PostId": postId,
        "PostTitle": postTitle,
        "UserId": userId,
        "PostType": postType,
        "PostTime": postTime.toIso8601String(),
        "Description": description
      };
}

class MyInquiryData {
  static const String url = 'http://192.168.0.94:3000/myinquiry';

  static Future<MyInquiry> getInfo(String userId) async {
    try {
      Map data = {"UserId": userId};
      var body = jsonEncode(data);

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final MyInquiry myInquiry = myInquiryFromJson(response.body);
        return myInquiry;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again.');
        return MyInquiry(code: response.statusCode, communityPages: []);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return MyInquiry(code: 0, communityPages: []);
    }
  }
}
