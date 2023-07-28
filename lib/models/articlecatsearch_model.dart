// To parse this JSON data, do
//
//     final articleCatSearchModel = articleCatSearchModelFromJson(jsonString);

import 'dart:convert';

ArticleCatSearchModel articleCatSearchModelFromJson(String str) => ArticleCatSearchModel.fromJson(json.decode(str));

String articleCatSearchModelToJson(ArticleCatSearchModel data) => json.encode(data.toJson());

class ArticleCatSearchModel {
    ArticleCatSearchModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory ArticleCatSearchModel.fromJson(Map<String, dynamic> json) => ArticleCatSearchModel(
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
        this.categoryCode,
        this.categoryName,
        this.categoryId,
        this.blogs,
    });

    String? categoryCode;
    String? categoryName;
    int? categoryId;
    List<Blog>? blogs;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        categoryCode: json["category_code"],
        categoryName: json["category_name"],
        categoryId: json["category_id"],
        blogs: List<Blog>.from(json["blogs"].map((x) => Blog.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "category_code": categoryCode,
        "category_name": categoryName,
        "category_id": categoryId,
        "blogs": List<dynamic>.from(blogs!.map((x) => x.toJson())),
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

    factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        blogCategory: json["blog_category"],
        memberType: json["member_type"] ?? '',
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
        pageView: json["page_view"] ?? 0,
        uniqueView: json["unique_view"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "blog_category": blogCategory,
        "member_type": memberType ?? '',
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
        "page_view": pageView ?? 0,
        "unique_view": uniqueView ?? 0,
    };
}
