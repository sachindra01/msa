// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

ProductDetailModel productDetailModelFromJson(String str) =>
    ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) => json.encode(data.toJson());

class ProductDetailModel {
  ProductDetailModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  Data? data;
  int? code;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
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
        this.detail,
        this.list,
        this.comments,
    });

    Detail? detail;
    List<Detail>? list;
    List<Comment>? comments;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        detail: Detail.fromJson(json["detail"]),
        list: List<Detail>.from(json["list"].map((x) => Detail.fromJson(x))),
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "detail": detail!.toJson(),
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
    };
}

class Detail {
  Detail({
    this.id,
    this.productCategory,
    this.memberType,
    this.hostId,
    this.productCode,
    this.productTitle,
    this.shortDescription,
    this.tags,
    this.price,
    this.movieDuration,
    this.profileImage,
    this.publishDateFrom,
    this.publishDateTo,
    this.publishFlg,
    this.isRecommended,
    this.publishLogicId,
    this.isSet,
    this.setProductList,
    this.setNumber,
    this.setLength,
    this.movieCategory,
    this.liveZoomUrl,
    this.liveZoomId,
    this.liveZoomPassword,
    this.liveMemo,
    this.liveDate,
    this.liveOption1,
    this.liveOption2,
    this.liveOption3,
    this.liveOption4,
    this.liveOption5,
    this.movieUrl,
    this.movieCode,
    this.movieOption1,
    this.movieOption2,
    this.movieOption3,
    this.movieOption4,
    this.movieOption5,
    this.previewUrl,
    this.previewCode,
    this.previewTime,
    this.previewMemo,
    this.displayOrder,
    this.isPremium,
    this.likeCount,
    this.commentCount,
    this.liked,
    this.pageView,
    this.uniqueView,
    this.description1,
    this.description2,
    this.categoryName,
    this.isChecked,
    this.isOnPlaylist,
    this.playedTime,
  });

  int? id;
  int? productCategory;
  String? memberType;
  int? hostId;
  String? productCode;
  String? productTitle;
  String? shortDescription;
  String? tags;
  int? price;
  String? movieDuration;
  String? profileImage;
  String? publishDateFrom;
  String? publishDateTo;
  String? publishFlg;
  String? isRecommended;
  int? publishLogicId;
  bool? isSet;
  String? setProductList;
  int? setNumber;
  int? setLength;
  int? movieCategory;
  String? liveZoomUrl;
  String? liveZoomId;
  String? liveZoomPassword;
  String? liveMemo;
  String? liveDate;
  String? liveOption1;
  String? liveOption2;
  String? liveOption3;
  String? liveOption4;
  String? liveOption5;
  String? movieUrl;
  String? movieCode;
  String? movieOption1;
  String? movieOption2;
  String? movieOption3;
  String? movieOption4;
  String? movieOption5;
  String? previewUrl;
  String? previewCode;
  String? previewTime;
  String? previewMemo;
  String? displayOrder;
  bool? isPremium;
  int? likeCount;
  int? commentCount;
  bool? liked;
  int? pageView;
  int? uniqueView;
  String? description1;
  String? description2;
  String? categoryName;
  bool? isChecked;
  bool? isOnPlaylist;
  String? playedTime;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        productCategory: json["product_category"],
        memberType: json["member_type"],
        hostId: json["host_id"],
        productCode: json["product_code"],
        productTitle: json["product_title"] ?? '',
        shortDescription: json["short_description"] ?? '',
        tags: json["tags"],
        price: json["price"],
        movieDuration: json["movie_duration"],
        profileImage: json["profile_image"],
        publishDateFrom: json["publish_date_from"],
        publishDateTo: json["publish_date_to"],
        publishFlg: json["publish_flg"],
        isRecommended: json["is_recommended"],
        publishLogicId: json["publish_logic_id"],
        isSet: json["is_set"],
        setProductList: json["set_product_list"],
        setNumber: json["set_number"],
        setLength: json["set_length"],
        movieCategory: json["movie_category"],
        liveZoomUrl: json["live_zoom_url"],
        liveZoomId: json["live_zoom_id"],
        liveZoomPassword: json["live_zoom_password"],
        liveMemo: json["live_memo"],
        liveDate: json["live_date"],
        liveOption1: json["live_option1"],
        liveOption2: json["live_option2"],
        liveOption3: json["live_option3"],
        liveOption4: json["live_option4"],
        liveOption5: json["live_option5"],
        movieUrl: json["movie_url"],
        movieCode: json["movie_code"],
        movieOption1: json["movie_option1"],
        movieOption2: json["movie_option2"],
        movieOption3: json["movie_option3"],
        movieOption4: json["movie_option4"],
        movieOption5: json["movie_option5"],
        previewUrl: json["preview_url"],
        previewCode: json["preview_code"],
        previewTime: json["preview_time"],
        previewMemo: json["preview_memo"],
        displayOrder: json["display_order"],
        isPremium: json["is_premium"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        liked: json["liked"],
        pageView: json["page_view"],
        uniqueView: json["unique_view"],
        description1: json["description_1"] ?? '',
        description2: json["description_2"] ?? '',
        categoryName: json["category_name"],
        isChecked: json["is_checked"],
        isOnPlaylist: json["is_on_playlist"],
        playedTime: json["played_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_category": productCategory,
        "member_type": memberType,
        "host_id": hostId,
        "product_code": productCode,
        "product_title": productTitle,
        "short_description": shortDescription,
        "tags": tags,
        "price": price,
        "movie_duration": movieDuration,
        "profile_image": profileImage,
        "publish_date_from": publishDateFrom,
        "publish_date_to": publishDateTo,
        "publish_flg": publishFlg,
        "is_recommended": isRecommended,
        "publish_logic_id": publishLogicId,
        "is_set": isSet,
        "set_product_list": setProductList,
        "set_number": setNumber,
        "set_length": setLength,
        "movie_category": movieCategory,
        "live_zoom_url": liveZoomUrl,
        "live_zoom_id": liveZoomId,
        "live_zoom_password": liveZoomPassword,
        "live_memo": liveMemo,
        "live_date": liveDate,
        "live_option1": liveOption1,
        "live_option2": liveOption2,
        "live_option3": liveOption3,
        "live_option4": liveOption4,
        "live_option5": liveOption5,
        "movie_url": movieUrl,
        "movie_code": movieCode,
        "movie_option1": movieOption1,
        "movie_option2": movieOption2,
        "movie_option3": movieOption3,
        "movie_option4": movieOption4,
        "movie_option5": movieOption5,
        "preview_url": previewUrl,
        "preview_code": previewCode,
        "preview_time": previewTime,
        "preview_memo": previewMemo,
        "display_order": displayOrder,
        "is_premium": isPremium,
        "like_count": likeCount,
        "comment_count": commentCount,
        "liked": liked,
        "page_view": pageView,
        "unique_view": uniqueView,
        "description_1": description1,
        "description_2": description2,
        "category_name": categoryName,
        "is_checked": isChecked,
        "is_on_playlist": isOnPlaylist,
        "played_time": playedTime,
      };
}

class User {
    User({
        this.id,
        this.nickname,
        this.firstName,
        this.kanaFirstName,
        this.imageUrl,
    });

    int? id;
    String? nickname;
    String? firstName;
    String? kanaFirstName;
    String? imageUrl;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nickname: json["nickname"],
        firstName: json["first_name"],
        kanaFirstName: json["kana_first_name"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "first_name": firstName,
        "kana_first_name": kanaFirstName,
        "image_url": imageUrl,
    };
}

class Comment {
    Comment({
        this.id,
        this.comment,
        this.type,
        this.itemId,
        this.parentId,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    int? id;
    String? comment;
    String? type;
    int? itemId;
    int? parentId;
    String? createdAt;
    String? updatedAt;
    User? user;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        comment: json["comment"],
        type: json["type"],
        itemId: json["item_id"],
        parentId: json["parent_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "type": type,
        "item_id": itemId,
        "parent_id": parentId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user!.toJson(),
    };
}