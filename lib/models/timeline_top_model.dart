// To parse this JSON data, do
//
//     final timelineTopModel = timelineTopModelFromJson(jsonString);

import 'dart:convert';

TimelineTopModel timelineTopModelFromJson(String str) =>
    TimelineTopModel.fromJson(json.decode(str));

String timelineTopModelToJson(TimelineTopModel data) =>
    json.encode(data.toJson());

class TimelineTopModel {
  TimelineTopModel({
    required this.success,
    required this.data,
    required this.code,
  });

  bool success;
  Data data;
  int code;

  factory TimelineTopModel.fromJson(Map<String, dynamic> json) =>
      TimelineTopModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "code": code,
      };
}

class Data {
  Data({
    required this.recommendedTimelines,
    required this.timelines,
  });

  List<dynamic> recommendedTimelines;
  List<DataTimeline> timelines;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recommendedTimelines:
            List<dynamic>.from(json["recommendedTimelines"].map((x) => x)),
        timelines: List<DataTimeline>.from(
            json["timelines"].map((x) => DataTimeline.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recommendedTimelines":
            List<dynamic>.from(recommendedTimelines.map((x) => x)),
        "timelines": List<dynamic>.from(timelines.map((x) => x.toJson())),
      };
}

class DataTimeline {
  DataTimeline({
    required this.id,
    required this.required,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryLinkUrl,
    required this.categoryMembershipStatus,
    required this.categoryStatus,
    required this.displayOrder,
    required this.timelines,
  });

  int id;
  String required;
  String categoryName;
  String categoryDescription;
  String categoryLinkUrl;
  String categoryMembershipStatus;
  String categoryStatus;
  int displayOrder;
  List<TimelineTimeline> timelines;

  factory DataTimeline.fromJson(Map<String, dynamic> json) => DataTimeline(
        id: json["id"],
        required: json["category_code"],
        categoryName: json["category_name"],
        categoryDescription: json["category_description"],
        categoryLinkUrl: json["category_link_url"],
        categoryMembershipStatus: json["category_membership_status"],
        categoryStatus: json["category_status"],
        displayOrder: json["display_order"],
        timelines: List<TimelineTimeline>.from(
            json["timelines"].map((x) => TimelineTimeline.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_code": required,
        "category_name": categoryName,
        "category_description": categoryDescription,
        "category_link_url": categoryLinkUrl,
        "category_membership_status": categoryMembershipStatus,
        "category_status": categoryStatus,
        "display_order": displayOrder,
        "timelines": List<dynamic>.from(timelines.map((x) => x.toJson())),
      };
}

class TimelineTimeline {
  TimelineTimeline({
    required this.id,
    required this.timelineCategory,
    required this.memberType,
    required this.hostId,
    required this.timelineCode,
    required this.timelineTitle,
    required this.shortDescription,
    required this.tags,
    required this.price,
    required this.profileImage,
    required this.profileImageOriginal,
    required this.publishDateFrom,
    required this.publishDateTo,
    required this.publishFlg,
    required this.isRecommended,
    required this.publishLogicId,
    required this.isFavorite,
    required this.isPremium,
    required this.likeCount,
    required this.commentCount,
    required this.liked,
    required this.linkType,
    required this.productLink,
    required this.blogLink,
    required this.pageView,
    required this.uniqueView,
  });

  int id;
  int timelineCategory;
  String memberType;
  int hostId;
  String timelineCode;
  String timelineTitle;
  String shortDescription;
  String tags;
  String price;
  String profileImage;
  String profileImageOriginal;
  DateTime publishDateFrom;
  DateTime publishDateTo;
  String publishFlg;
  dynamic isRecommended;
  dynamic publishLogicId;
  bool isFavorite;
  bool isPremium;
  int likeCount;
  int commentCount;
  bool liked;
  String linkType;
  String productLink;
  String blogLink;
  int pageView;
  int uniqueView;

  factory TimelineTimeline.fromJson(Map<String, dynamic> json) =>
      TimelineTimeline(
        id: json["id"],
        timelineCategory: json["timeline_category"],
        memberType: json["member_type"],
        hostId: json["host_id"],
        timelineCode: json["timeline_code"],
        timelineTitle: json["timeline_title"],
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
        linkType: json["link_type"],
        productLink: json["product_link"],
        blogLink: json["blog_link"],
        pageView: json["page_view"],
        uniqueView: json["unique_view"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "timeline_category": timelineCategory,
        "member_type": memberType,
        "host_id": hostId,
        "timeline_code": timelineCode,
        "timeline_title": timelineTitle,
        "short_description": shortDescription,
        "tags": tags,
        "price": price,
        "profile_image": profileImage,
        "profile_image_original": profileImageOriginal,
        "publish_date_from":
            "${publishDateFrom.year.toString().padLeft(4, '0')}-${publishDateFrom.month.toString().padLeft(2, '0')}-${publishDateFrom.day.toString().padLeft(2, '0')}",
        "publish_date_to":
            "${publishDateTo.year.toString().padLeft(4, '0')}-${publishDateTo.month.toString().padLeft(2, '0')}-${publishDateTo.day.toString().padLeft(2, '0')}",
        "publish_flg": publishFlg,
        "is_recommended": isRecommended,
        "publish_logic_id": publishLogicId,
        "is_favorite": isFavorite,
        "is_premium": isPremium,
        "like_count": likeCount,
        "comment_count": commentCount,
        "liked": liked,
        "link_type": linkType,
        "product_link": productLink,
        "blog_link": blogLink,
        "page_view": pageView,
        "unique_view": uniqueView,
      };
}
