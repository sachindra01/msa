// To parse this JSON data, do
//
//     final blogSearchModel = blogSearchModelFromJson(jsonString);

import 'dart:convert';

BlogSearchModel blogSearchModelFromJson(String str) =>
    BlogSearchModel.fromJson(json.decode(str));

String blogSearchModelToJson(BlogSearchModel data) =>
    json.encode(data.toJson());

class BlogSearchModel {
  BlogSearchModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  int? code;

  factory BlogSearchModel.fromJson(Map<String, dynamic> json) =>
      BlogSearchModel(
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
    this.id,
    this.blogCategory,
    this.memberType,
    this.hostId,
    this.blogCode,
    this.blogTitle,
    this.shortDescription,
    this.tags,
    this.price,
    this.profileImage,
    this.profileImageOriginal,
    this.publishDateFrom,
    this.publishDateTo,
    this.publishFlg,
    this.isRecommended,
    this.publishLogicId,
    this.isFavorite,
    this.isPremium,
    this.likeCount,
    this.commentCount,
    this.liked,
    this.pageView,
    this.uniqueView,
  });

  int? id;
  int? blogCategory;
  String? memberType;
  int? hostId;
  dynamic blogCode;
  String? blogTitle;
  dynamic shortDescription;
  dynamic tags;
  dynamic price;
  String? profileImage;
  String? profileImageOriginal;
  DateTime? publishDateFrom;
  DateTime? publishDateTo;
  String? publishFlg;
  String? isRecommended;
  dynamic publishLogicId;
  bool? isFavorite;
  bool? isPremium;
  int? likeCount;
  int? commentCount;
  bool? liked;
  int? pageView;
  int? uniqueView;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        blogCategory: json["blog_category"],
        memberType: json["member_type"],
        hostId: json["host_id"],
        blogCode: json["blog_code"],
        blogTitle: json["blog_title"],
        shortDescription: json["short_description"],
        tags: json["tags"],
        price: json["price"],
        profileImage: json["profile_image"],
        profileImageOriginal: json["profile_image_original"],
        publishDateFrom: DateTime.parse(json["publish_date_from"]),
        publishDateTo: DateTime.parse(json["publish_date_to"]),
        publishFlg: json["publish_flg"],
        isRecommended: json["is_recommended"],
        publishLogicId: json["publish_logic_id"],
        isFavorite: json["is_favorite"],
        isPremium: json["is_premium"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        liked: json["liked"],
        pageView: json["page_view"],
        uniqueView: json["unique_view"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "blog_category": blogCategory,
        "member_type": memberType,
        "host_id": hostId,
        "blog_code": blogCode,
        "blog_title": blogTitle,
        "short_description": shortDescription,
        "tags": tags,
        "price": price,
        "profile_image": profileImage,
        "profile_image_original": profileImageOriginal,
        "publish_date_from":
            "${publishDateFrom!.year.toString().padLeft(4, '0')}-${publishDateFrom!.month.toString().padLeft(2, '0')}-${publishDateFrom!.day.toString().padLeft(2, '0')}",
        "publish_date_to":
            "${publishDateTo!.year.toString().padLeft(4, '0')}-${publishDateTo!.month.toString().padLeft(2, '0')}-${publishDateTo!.day.toString().padLeft(2, '0')}",
        "publish_flg": publishFlg,
        "is_recommended": isRecommended,
        "publish_logic_id": publishLogicId,
        "is_favorite": isFavorite,
        "is_premium": isPremium,
        "like_count": likeCount,
        "comment_count": commentCount,
        "liked": liked,
        "page_view": pageView,
        "unique_view": uniqueView,
      };
}
