// To parse this JSON data, do
//
//     final timelineDetail = timelineDetailFromJson(jsonString);

import 'dart:convert';

TimelineDetail timelineDetailFromJson(String str) => TimelineDetail.fromJson(json.decode(str));

String timelineDetailToJson(TimelineDetail data) => json.encode(data.toJson());

class TimelineDetail {
    TimelineDetail({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data ?data;
    int ?code;

    factory TimelineDetail.fromJson(Map<String, dynamic> json) => TimelineDetail(
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
        this.description1,
        this.description2,
        this.profileImage600,
        this.comments,
        this.prevTimeline,
        this.nextTimeline,
    });

    int ?id;
    int ?timelineCategory;
    String ?memberType;
    int ?hostId;
    dynamic timelineCode;
    String ?timelineTitle;
    String ?shortDescription;
    dynamic tags;
    dynamic price;
    String ?profileImage;
    String ?profileImageOriginal;
    DateTime ?publishDateFrom;
    DateTime ?publishDateTo;
    String ?publishFlg;
    dynamic isRecommended;
    dynamic publishLogicId;
    bool ?isFavorite;
    bool ?isPremium;
    int ?likeCount;
    int ?commentCount;
    bool ?liked;
    String ?linkType;
    dynamic productLink;
    dynamic blogLink;
    int ?pageView;
    int ?uniqueView;
    String ?description1;
    dynamic description2;
    String ?profileImage600;
    List<dynamic> ?comments;
    dynamic prevTimeline;
    int ?nextTimeline;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        liked: json["liked"] ?? false,
        linkType: json["link_type"],
        productLink: json["product_link"],
        blogLink: json["blog_link"],
        pageView: json["page_view"],
        uniqueView: json["unique_view"],
        description1: json["description_1"],
        description2: json["description_2"],
        profileImage600: json["profile_image_600"],
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        prevTimeline: json["prev_timeline"],
        nextTimeline: json["next_timeline"],
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
        "publish_date_from": "${publishDateFrom!.year.toString().padLeft(4, '0')}-${publishDateFrom?.month.toString().padLeft(2, '0')}-${publishDateFrom!.day.toString().padLeft(2, '0')}",
        "publish_date_to": "${publishDateTo!.year.toString().padLeft(4, '0')}-${publishDateTo?.month.toString().padLeft(2, '0')}-${publishDateTo!.day.toString().padLeft(2, '0')}",
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
        "description_1": description1,
        "description_2": description2,
        "profile_image_600": profileImage600,
        "comments": List<dynamic>.from(comments!.map((x) => x)),
        "prev_timeline": prevTimeline,
        "next_timeline": nextTimeline,
    };
}
