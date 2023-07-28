// To parse this JSON data, do
//
//     final memberList = memberListFromJson(jsonString);

import 'dart:convert';

MemberList memberListFromJson(String str) =>
    MemberList.fromJson(json.decode(str));

String memberListToJson(MemberList data) => json.encode(data.toJson());

class MemberList {
  MemberList({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  int? code;

  factory MemberList.fromJson(Map<String, dynamic> json) => MemberList(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "code": code,
      };
}

class Datum {
  Datum({
    this.reportStatus,
    this.label,
    this.labelEn,
    this.userId,
    this.nickname,
    this.designation,
    this.showAge,
    this.imageUrl,
    this.twitterLink,
  });

  String? reportStatus;
  String? label;
  String? labelEn;
  int? userId;
  String? nickname;
  String? designation;
  bool? showAge;
  String? imageUrl;
  String? twitterLink;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reportStatus: json["report_status"],
        label: json["label"],
        labelEn: json["label_en"],
        userId: json["user_id"],
        nickname: json["nickname"] ?? "",
        designation: json["designation"] ?? "",
        showAge: json["show_age"] ?? false,
        imageUrl: json["image_url"],
        twitterLink: json["twitter_link"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "report_status": reportStatus,
        "label": label,
        "label_en": labelEn,
        "user_id": userId,
        "nickname": nickname,
        "designation": designation ?? '',
        "show_age": showAge ?? false,
        "image_url": imageUrl,
        "twitter_link": twitterLink ?? '',
      };
}
