// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
    NewsModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "code": code,
    };
}

class Data {
    Data({
        this.id,
        this.title,
        this.description,
        this.publishDateFrom,
        this.publishDateTo,
        this.userId,
        this.displayOrder,
        this.status,
        this.profileImage,
        this.profileImageOriginal,
    });

    int? id;
    String? title;
    String? description;
    String? publishDateFrom;
    String? publishDateTo;
    dynamic userId;
    dynamic displayOrder;
    bool? status;
    String? profileImage;
    String? profileImageOriginal;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        publishDateFrom: json["publish_date_from"],
        publishDateTo: json["publish_date_to"],
        userId: json["user_id"],
        displayOrder: json["display_order"],
        status: json["status"],
        profileImage: json["profile_image"],
        profileImageOriginal: json["profile_image_original"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "publish_date_from": publishDateFrom,
        "publish_date_to": publishDateTo,
        "user_id": userId,
        "display_order": displayOrder,
        "status": status,
        "profile_image": profileImage,
        "profile_image_original": profileImageOriginal,
    };
}