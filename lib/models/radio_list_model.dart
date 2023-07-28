// To parse this JSON data, do
//
//     final radioList = radioListFromJson(jsonString);

import 'dart:convert';

RadioList radioListFromJson(String str) => RadioList.fromJson(json.decode(str));

String radioListToJson(RadioList data) => json.encode(data.toJson());

class RadioList {
    RadioList({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory RadioList.fromJson(Map<String, dynamic> json) => RadioList(
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
        this.recommendedRadio,
        this.radios,
        this.recommendedCount,
    });

    List<List<Radio>>? recommendedRadio;
    List<Radio>? radios;
    int? recommendedCount;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        recommendedRadio: List<List<Radio>>.from(json["recommendedRadio"].map((x) => List<Radio>.from(x.map((x) => Radio.fromJson(x))))),
        radios: List<Radio>.from(json["radios"].map((x) => Radio.fromJson(x))),
        recommendedCount: json["recommendedCount"],
    );

    Map<String, dynamic> toJson() => {
        "recommendedRadio": List<dynamic>.from(recommendedRadio!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "radios": List<dynamic>.from(radios!.map((x) => x.toJson())),
        "recommendedCount": recommendedCount,
    };
}

class Radio {
    Radio({
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
    });

    int? id;
    int? radioCategory;
    String? categoryName;
    Category? category;
    dynamic memberType;
    int? hostId;
    dynamic radioCode;
    String? radioTitle;
    String? shortDescription;
    String? tags;
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

    factory Radio.fromJson(Map<String, dynamic> json) => Radio(
        id: json["id"],
        radioCategory: json["radio_category"],
        categoryName: json["category_name"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        memberType: json["member_type"],
        hostId: json["host_id"],
        radioCode: json["radio_code"],
        radioTitle: json["radio_title"],
        shortDescription: json["short_description"] ?? '',
        tags: json["tags"] ?? '',
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
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "radio_category": radioCategory ?? '',
        "category_name": categoryName,
        "category": category ?? '',
        "member_type": memberType,
        "host_id": hostId,
        "radio_code": radioCode,
        "radio_title": radioTitle,
        "short_description": shortDescription ?? '',
        "tags": tags ?? '',
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
    };
}

class Category {
    Category({
        this.id,
        this.categoryCode,
        this.categoryName,
        this.categoryDescription,
        this.categoryImage,
        this.categoryLinkUrl,
        this.categoryMembershipStatus,
        this.categoryStatus,
        this.displayOrder,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.deleteFlg,
        this.deletedBy,
    });

    int? id;
    dynamic categoryCode;
    String? categoryName;
    dynamic categoryDescription;
    dynamic categoryImage;
    dynamic categoryLinkUrl;
    dynamic categoryMembershipStatus;
    String? categoryStatus;
    int? displayOrder;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? createdBy;
    int? updatedBy;
    dynamic deletedAt;
    int? deleteFlg;
    dynamic deletedBy;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryCode: json["category_code"],
        categoryName: json["category_name"],
        categoryDescription: json["category_description"],
        categoryImage: json["category_image"],
        categoryLinkUrl: json["category_link_url"],
        categoryMembershipStatus: json["category_membership_status"],
        categoryStatus: json["category_status"],
        displayOrder: json["display_order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedAt: json["deleted_at"],
        deleteFlg: json["delete_flg"],
        deletedBy: json["deleted_by"],
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
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "deleted_at": deletedAt,
        "delete_flg": deleteFlg,
        "deleted_by": deletedBy,
    };
}
