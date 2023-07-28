// To parse this JSON data, do
//
//     final productCaterogyList = productCaterogyListFromJson(jsonString);

import 'dart:convert';

ProductCaterogyList productCaterogyListFromJson(String str) =>
    ProductCaterogyList.fromJson(json.decode(str));

String productCaterogyListToJson(ProductCaterogyList data) =>
    json.encode(data.toJson());

class ProductCaterogyList {
  ProductCaterogyList({
    required this.success,
    required this.data,
    required this.code,
  });

  bool success;
  List<Datum> data;
  int code;

  factory ProductCaterogyList.fromJson(Map<String, dynamic> json) =>
      ProductCaterogyList(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.categoryCode,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImage,
    required this.categoryLinkUrl,
    required this.categoryMembershipStatus,
    required this.categoryStatus,
    required this.displayOrder,
  });

  int id;
  String categoryCode;
  String categoryName;
  String categoryDescription;
  String categoryImage;
  String categoryLinkUrl;
  String categoryMembershipStatus;
  String categoryStatus;
  int displayOrder;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryCode: json["category_code"],
        categoryName: json["category_name"],
        categoryDescription: json["category_description"],
        categoryImage: json["category_image"],
        categoryLinkUrl: json["category_link_url"],
        categoryMembershipStatus: json["category_membership_status"],
        categoryStatus: json["category_status"],
        displayOrder: json["display_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_code": categoryCode,
        "category_name": categoryName,
        "category_description": categoryDescription,
        "category_image": categoryImage,
        "category_link_url": categoryLinkUrl,
        "category_membership_status": categoryMembershipStatus,
        "category_status": categoryStatus,
        "display_order": displayOrder,
      };
}
