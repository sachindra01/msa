// To parse this JSON data, do
//
//     final articleFavouriteModel = articleFavouriteModelFromJson(jsonString);

import 'dart:convert';

ArticleFavouriteModel articleFavouriteModelFromJson(String str) =>
    ArticleFavouriteModel.fromJson(json.decode(str));

String articleFavouriteModelToJson(ArticleFavouriteModel data) =>
    json.encode(data.toJson());

class ArticleFavouriteModel {
  ArticleFavouriteModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  int? code;

  factory ArticleFavouriteModel.fromJson(Map<String, dynamic> json) =>
      ArticleFavouriteModel(
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
    this.datetime,
    this.fevProductType,
    this.userId,
    this.productId,
    this.blogId,
    this.rated,
    this.comments,
    this.privateMemo,
    this.timelineId,
    this.radioId,
    this.blog,
  });

  int? id;
  DateTime? datetime;
  String? fevProductType;
  String? userId;
  dynamic productId;
  int? blogId;
  dynamic rated;
  dynamic comments;
  dynamic privateMemo;
  dynamic timelineId;
  dynamic radioId;
  Blog? blog;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        datetime: DateTime.parse(json["datetime"]),
        fevProductType: json["fev_product_type"],
        userId: json["user_id"],
        productId: json["product_id"],
        blogId: json["blog_id"],
        rated: json["rated"],
        comments: json["comments"],
        privateMemo: json["private_memo"],
        timelineId: json["timeline_id"],
        radioId: json["radio_id"],
        blog: Blog.fromJson(json["blog"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "datetime": datetime!.toIso8601String(),
        "fev_product_type": fevProductType,
        "user_id": userId,
        "product_id": productId,
        "blog_id": blogId,
        "rated": rated,
        "comments": comments,
        "private_memo": privateMemo,
        "timeline_id": timelineId,
        "radio_id": radioId,
        "blog": blog!.toJson(),
      };
}

class Blog {
  Blog({
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

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
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
