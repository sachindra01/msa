// To parse this JSON data, do
//
//     final radioDetailModel = radioDetailModelFromJson(jsonString);

import 'dart:convert';

RadioDetailModel radioDetailModelFromJson(String str) => RadioDetailModel.fromJson(json.decode(str));

String radioDetailModelToJson(RadioDetailModel data) => json.encode(data.toJson());

class RadioDetailModel {
    RadioDetailModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory RadioDetailModel.fromJson(Map<String, dynamic> json) => RadioDetailModel(
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
        this.radioCategory,
        this.categoryName,
        this.category,
        this.memberType,
        this.hostId,
        this.radioCode,
        this.radioTitle,
        this.shortDescription,
        this.tags,
        this.price,
        this.profileImage,
        this.profileImageOriginal,
        this.publishDateFrom,
        this.publishDateTo,
        this.publishFlg,
        this.isRecommended,
        this.isFavorite,
        this.isPremium,
        this.likeCount,
        this.commentCount,
        this.liked,
        this.pageView,
        this.uniqueView,
        this.audioUrl,
        this.description1,
        this.description2,
        this.profileImage600,
        this.comments,
        this.prevRadio,
        this.nextRadio,
    });

    int? id;
    dynamic radioCategory;
    String? categoryName;
    dynamic category;
    dynamic memberType;
    int? hostId;
    dynamic radioCode;
    String? radioTitle;
    dynamic shortDescription;
    dynamic tags;
    dynamic price;
    String? profileImage;
    String? profileImageOriginal;
    DateTime? publishDateFrom;
    DateTime? publishDateTo;
    String? publishFlg;
    String? isRecommended;
    bool? isFavorite;
    bool? isPremium;
    int? likeCount;
    int? commentCount;
    bool? liked;
    int? pageView;
    int? uniqueView;
    String? audioUrl;
    String? description1;
    dynamic description2;
    String? profileImage600;
    List<dynamic>? comments;
    dynamic prevRadio;
    int? nextRadio;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        radioCategory: json["radio_category"],
        categoryName: json["category_name"],
        category: json["category"],
        memberType: json["member_type"],
        hostId: json["host_id"],
        radioCode: json["radio_code"],
        radioTitle: json["radio_title"],
        shortDescription: json["short_description"],
        tags: json["tags"],
        price: json["price"],
        profileImage: json["profile_image"],
        profileImageOriginal: json["profile_image_original"],
        publishDateFrom: DateTime.parse(json["publish_date_from"]),
        publishDateTo: DateTime.parse(json["publish_date_to"]),
        publishFlg: json["publish_flg"],
        isRecommended: json["is_recommended"],
        isFavorite: json["is_favorite"],
        isPremium: json["is_premium"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        liked: json["liked"],
        pageView: json["page_view"],
        uniqueView: json["unique_view"],
        audioUrl: json["audio_url"],
        description1: json["description_1"],
        description2: json["description_2"],
        profileImage600: json["profile_image_600"],
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        prevRadio: json["prev_radio"],
        nextRadio: json["next_radio"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "radio_category": radioCategory,
        "category_name": categoryName,
        "category": category,
        "member_type": memberType,
        "host_id": hostId,
        "radio_code": radioCode,
        "radio_title": radioTitle,
        "short_description": shortDescription,
        "tags": tags,
        "price": price,
        "profile_image": profileImage,
        "profile_image_original": profileImageOriginal,
        "publish_date_from": "${publishDateFrom!.year.toString().padLeft(4, '0')}-${publishDateFrom!.month.toString().padLeft(2, '0')}-${publishDateFrom!.day.toString().padLeft(2, '0')}",
        "publish_date_to": "${publishDateTo!.year.toString().padLeft(4, '0')}-${publishDateTo!.month.toString().padLeft(2, '0')}-${publishDateTo!.day.toString().padLeft(2, '0')}",
        "publish_flg": publishFlg,
        "is_recommended": isRecommended,
        "is_favorite": isFavorite,
        "is_premium": isPremium,
        "like_count": likeCount,
        "comment_count": commentCount,
        "liked": liked,
        "page_view": pageView,
        "unique_view": uniqueView,
        "audio_url": audioUrl,
        "description_1": description1,
        "description_2": description2,
        "profile_image_600": profileImage600,
        "comments": List<dynamic>.from(comments!.map((x) => x)),
        "prev_radio": prevRadio,
        "next_radio": nextRadio,
    };
}
