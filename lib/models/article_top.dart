// To parse this JSON data, do
//
//     final articleTopModel = articleTopModelFromJson(jsonString);

import 'dart:convert';

ArticleTopModel articleTopModelFromJson(String str) =>
    ArticleTopModel.fromJson(json.decode(str));

String articleTopModelToJson(ArticleTopModel data) =>
    json.encode(data.toJson());

class ArticleTopModel {
  ArticleTopModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  Data? data;
  int? code;

  factory ArticleTopModel.fromJson(Map<String, dynamic> json) =>
      ArticleTopModel(
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
    this.recommendedBlogs,
    this.blogs,
    this.recommendedCount,
  });

  List<dynamic>? recommendedBlogs;
  List<DataBlog>? blogs;
  int? recommendedCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recommendedBlogs:
            List<dynamic>.from(json["recommendedBlogs"].map((x) => x)),
        blogs:
            List<DataBlog>.from(json["blogs"].map((x) => DataBlog.fromJson(x))),
        recommendedCount: json["recommendedCount"],
      );

  Map<String, dynamic> toJson() => {
        "recommendedBlogs": List<dynamic>.from(recommendedBlogs!.map((x) => x)),
        "blogs": List<dynamic>.from(blogs!.map((x) => x.toJson())),
        "recommendedCount": recommendedCount,
      };
}

class DataBlog {
  DataBlog({
    this.id,
    this.categoryCode,
    this.categoryName,
    this.categoryDescription,
    this.categoryImage,
    this.categoryLinkUrl,
    this.categoryMembershipStatus,
    this.categoryStatus,
    this.displayOrder,
    this.blogsCount,
    this.blogs,
  });

  int? id;
  String? categoryCode;
  String? categoryName;
  dynamic categoryDescription;
  String? categoryImage;
  dynamic categoryLinkUrl;
  String? categoryMembershipStatus;
  String? categoryStatus;
  int? displayOrder;
  int? blogsCount;
  List<BlogBlog>? blogs;

  factory DataBlog.fromJson(Map<String, dynamic> json) => DataBlog(
        id: json["id"],
        categoryCode: json["category_code"] ?? "",
        categoryName: json["category_name"],
        categoryDescription: json["category_description"],
        categoryImage: json["category_image"],
        categoryLinkUrl: json["category_link_url"],
        categoryMembershipStatus: json["category_membership_status"] ?? "",
        categoryStatus: json["category_status"],
        displayOrder: json["display_order"],
        blogsCount: json["blogs_count"],
        blogs:
            List<BlogBlog>.from(json["blogs"].map((x) => BlogBlog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_code": categoryCode ?? "",
        "category_name": categoryName,
        "category_description": categoryDescription,
        "category_image": categoryImage,
        "category_link_url": categoryLinkUrl,
        "category_membership_status": categoryMembershipStatus ?? "",
        "category_status": categoryStatus,
        "display_order": displayOrder,
        "blogs_count": blogsCount,
        "blogs": List<dynamic>.from(blogs!.map((x) => x.toJson())),
      };
}

class BlogBlog {
  BlogBlog({
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

  factory BlogBlog.fromJson(Map<String, dynamic> json) => BlogBlog(
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
        pageView: json["page_view"] ?? 2,
        uniqueView: json["unique_view"] ?? 1,
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
        "page_view": pageView ?? 1,
        "unique_view": uniqueView ?? 0,
      };
}
