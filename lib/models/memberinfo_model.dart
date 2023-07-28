// To parse this JSON data, do
//
//     final memberInfoModel = memberInfoModelFromJson(jsonString);

import 'dart:convert';

MemberInfoModel memberInfoModelFromJson(String str) => MemberInfoModel.fromJson(json.decode(str));

String memberInfoModelToJson(MemberInfoModel data) => json.encode(data.toJson());

class MemberInfoModel {
    MemberInfoModel({
        this.success,
        this.data,
        this.prefectureList,
        this.message,
        this.code,
    });

    bool? success;
    Data? data;
    Map<String, String>? prefectureList;
    String? message;
    int? code;

    factory MemberInfoModel.fromJson(Map<String, dynamic> json) => MemberInfoModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        prefectureList: Map.from(json["prefectureList"]).map((k, v) => MapEntry<String, String>(k, v)),
        message: json["message"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "prefectureList": Map.from(prefectureList!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "message": message,
        "code": code,
    };
}

class Data {
    Data({
        this.id,
        this.nickname,
        this.designation,
        this.shortDescription,
        this.address1,
        this.dobYear,
        this.status,
        this.showAge,
        this.imageUrl,
        this.twitterLink,
    });

    int? id;
    String? nickname;
    String? designation;
    String? shortDescription;
    String? address1;
    String? dobYear;
    bool? status;
    bool? showAge;
    String? imageUrl;
    String? twitterLink;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        nickname: json["nickname"],
        designation: json["designation"],
        shortDescription: json["short_description"],
        address1: json["address_1"],
        dobYear: json["dob_year"],
        status: json["status"] ?? false,
        showAge: json["show_age"],
        imageUrl: json["image_url"],
        twitterLink: json["twitter_link"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "designation": designation,
        "short_description": shortDescription,
        "address_1": address1,
        "dob_year": dobYear,
        "status": status ?? false,
        "show_age": showAge,
        "image_url": imageUrl,
        "twitter_link": twitterLink,
    };
}
