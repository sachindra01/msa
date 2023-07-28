// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    NotificationModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    List<Datum>? data;
    int? code;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
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
        this.title,
        this.publishDateFrom,
        this.publishDateTo,
        this.memberType,
        this.createdAt,
        this.id,
        this.type,
        this.image,
        this.movieCategory,
        this.isPremium,
        this.allowPremiumAccess,
        this.linkType,
        this.newsModule,
        this.productLink,
        this.blogLink,
    });

    String? title;
    String? publishDateFrom;
    String? publishDateTo;
    String? memberType;
    String? createdAt;
    int? id;
    String? type;
    String? image;
    String? movieCategory;
    bool? isPremium;
    bool? allowPremiumAccess;
    String? linkType;
    dynamic newsModule;
    String? productLink;
    String? blogLink;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        publishDateFrom: json["publish_date_from"],
        publishDateTo: json["publish_date_to"],
        memberType: json["member_type"],
        createdAt: json["created_at"],
        id: json["id"],
        type: json["type"],
        image: json["image"],
        movieCategory: json["movie_category"] ?? '',
        isPremium: json["is_premium"],
        allowPremiumAccess: json["allow_premium_access"],
        linkType: json["link_type"],
        newsModule: json["news_module"],
        productLink: json["product_link"],
        blogLink: json["blog_link"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "publish_date_from": publishDateFrom,
        "publish_date_to": publishDateTo,
        "member_type": memberType,
        "created_at": createdAt,
        "id": id,
        "type": type,
        "image": image,
        "movie_category": movieCategory ?? '',
        "is_premium": isPremium,
        "allow_premium_access":allowPremiumAccess,
        "link_type":linkType,
        "news_module": newsModule,
        "product_link":productLink,
        "blog_link":blogLink,
    };
}
