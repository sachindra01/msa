// To parse this JSON data, do
//
//     final articleCategoryModel = articleCategoryModelFromJson(jsonString);

import 'dart:convert';

ArticleCategoryModel articleCategoryModelFromJson(String str) =>
    ArticleCategoryModel.fromJson(json.decode(str));

String articleCategoryModelToJson(ArticleCategoryModel data) =>
    json.encode(data.toJson());

class ArticleCategoryModel {
  ArticleCategoryModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  int? code;

  factory ArticleCategoryModel.fromJson(Map<String, dynamic> json) =>
      ArticleCategoryModel(
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
    this.categoryCode,
    this.categoryName,
    this.categoryDescription,
    this.categoryImage,
    this.categoryLinkUrl,
    this.categoryMembershipStatus,
    this.categoryStatus,
    this.displayOrder,
    this.blogsCount,
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
      };
}
