// To parse this JSON data, do
//
//     final timeLineListModel = timeLineListModelFromJson(jsonString);

import 'dart:convert';

TimeLineListModel timeLineListModelFromJson(String str) => TimeLineListModel.fromJson(json.decode(str));

String timeLineListModelToJson(TimeLineListModel data) => json.encode(data.toJson());

class TimeLineListModel {
    TimeLineListModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory TimeLineListModel.fromJson(Map<String, dynamic> json) => TimeLineListModel(
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
        this.recommendedTimelines,
        this.timelines,
    });

    List<dynamic>? recommendedTimelines;
    List<DataTimeline>? timelines;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        recommendedTimelines: List<dynamic>.from(json["recommendedTimelines"].map((x) => x)),
        timelines: List<DataTimeline>.from(json["timelines"].map((x) => DataTimeline.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "recommendedTimelines": List<dynamic>.from(recommendedTimelines!.map((x) => x)),
        "timelines": List<dynamic>.from(timelines!.map((x) => x.toJson())),
    };
}

class DataTimeline {
    DataTimeline({
        this.id,
        this.categoryCode,
        this.categoryName,
        this.categoryDescription,
        this.categoryLinkUrl,
        this.categoryMembershipStatus,
        this.categoryStatus,
        this.displayOrder,
        this.timelines,
    });

    int? id;
    String? categoryCode;
    String? categoryName;
    String? categoryDescription;
    String? categoryLinkUrl;
    String? categoryMembershipStatus;
    String? categoryStatus;
    int? displayOrder;
    List<TimelineTimeline>? timelines;

    factory DataTimeline.fromJson(Map<String, dynamic> json) => DataTimeline(
        id: json["id"],
        categoryCode: json["category_code"],
        categoryName: json["category_name"],
        categoryDescription: json["category_description"],
        categoryLinkUrl: json["category_link_url"],
        categoryMembershipStatus: json["category_membership_status"],
        categoryStatus: json["category_status"],
        displayOrder: json["display_order"],
        timelines: List<TimelineTimeline>.from(json["timelines"].map((x) => TimelineTimeline.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_code": categoryCode,
        "category_name": categoryName,
        "category_description": categoryDescription,
        "category_link_url": categoryLinkUrl,
        "category_membership_status": categoryMembershipStatus,
        "category_status": categoryStatus,
        "display_order": displayOrder,
        "timelines": List<dynamic>.from(timelines!.map((x) => x.toJson())),
    };
}

class TimelineTimeline {
    TimelineTimeline({
        this.id,
        this.timelineCategory,
        this.memberType,
        this.hostId,
        this.timelineCode,
        this.timelineTitle,
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
        this.linkType,
        this.productLink,
        this.blogLink,
        this.pageView,
        this.uniqueView,
    });

    int? id;
    int? timelineCategory;
    String? memberType;
    int? hostId;
    String? timelineCode;
    String? timelineTitle;
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
    String? linkType;
    String? productLink;
    String? blogLink;
    int? pageView;
    int? uniqueView;

    factory TimelineTimeline.fromJson(Map<String, dynamic> json) => TimelineTimeline(
        id: json["id"],
        timelineCategory: json["timeline_category"],
        memberType: json["member_type"],
        hostId: json["host_id"],
        timelineCode: json["timeline_code"],
        timelineTitle: json["timeline_title"],
        shortDescription: json["short_description"],
        tags: json["tags"] ?? '',
        price: json["price"],
        profileImage: json["profile_image"],
        profileImageOriginal: json["profile_image_original"],
        publishDateFrom: json["publish_date_from"],
        publishDateTo: json["publish_date_to"],
        publishFlg: json["publish_flg"],
        isRecommended: json["is_recommended"] ?? '',
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
        "tags": tags ?? '',
        "price": price,
        "profile_image": profileImage,
        "profile_image_original": profileImageOriginal,
        "publish_date_from": publishDateFrom,
        "publish_date_to": publishDateTo,
        "publish_flg": publishFlg,
        "is_recommended": isRecommended ?? '',
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