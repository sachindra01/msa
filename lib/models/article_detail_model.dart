// To parse this JSON data, do
//
//     final articleDetailModel = articleDetailModelFromJson(jsonString);

import 'dart:convert';

ArticleDetailModel articleDetailModelFromJson(String str) => ArticleDetailModel.fromJson(json.decode(str));

String articleDetailModelToJson(ArticleDetailModel data) => json.encode(data.toJson());

class ArticleDetailModel {
    ArticleDetailModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory ArticleDetailModel.fromJson(Map<String, dynamic> json) => ArticleDetailModel(
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
        this.description1,
        this.description2,
        this.profileImage600,
        this.comments,
        this.prevBlog,
        this.nextBlog,
    });

    int? id;
    int? blogCategory;
    String? memberType;
    int? hostId;
    String? blogCode;
    String? blogTitle;
    String? shortDescription;
    String? tags;
    int? price;
    String? profileImage;
    String? profileImageOriginal;
    String? publishDateFrom;
    String? publishDateTo;
    String? publishFlg;
    String? isRecommended;
    String? publishLogicId;
    bool? isFavorite;
    bool? isPremium;
    int? likeCount;
    int? commentCount;
    bool? liked;
    int? pageView;
    int? uniqueView;
    String? description1;
    String? description2;
    String? profileImage600;
    List<dynamic>? comments;
    int? prevBlog;
    int? nextBlog;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        publishDateFrom: json["publish_date_from"],
        publishDateTo: json["publish_date_to"],
        publishFlg: json["publish_flg"],
        isRecommended: json["is_recommended"],
        publishLogicId: json["publish_logic_id"],
        isFavorite: json["is_favorite"] ?? false,
        isPremium: json["is_premium"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        liked: json["liked"] ?? false,
        pageView: json["page_view"],
        uniqueView: json["unique_view"],
        description1: json["description_1"],
        description2: json["description_2"],
        profileImage600: json["profile_image_600"],
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        prevBlog: json["prev_blog"],
        nextBlog: json["next_blog"],
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
        "publish_date_from": publishDateFrom,
        "publish_date_to": publishDateTo,
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
        "description_1": description1,
        "description_2": description2,
        "profile_image_600": profileImage600,
        "comments": List<dynamic>.from(comments!.map((x) => x)),
        "prev_blog": prevBlog,
        "next_blog": nextBlog,
    };
}
