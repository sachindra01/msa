// To parse this JSON data, do
//
//     final playListModel = playListModelFromJson(jsonString);

import 'dart:convert';

PlayListModel playListModelFromJson(String str) =>
    PlayListModel.fromJson(json.decode(str));

String playListModelToJson(PlayListModel data) => json.encode(data.toJson());

class PlayListModel {
  PlayListModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  int? code;

  factory PlayListModel.fromJson(Map<String, dynamic> json) => PlayListModel(
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
    this.categoryId,
    this.categoryCode,
    this.categoryName,
    this.displayOrder,
    this.playlist,
  });

  int? categoryId;
  String? categoryCode;
  String? categoryName;
  int? displayOrder;
  List<Playlist>? playlist;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["category_id"],
        categoryCode: json["category_code"],
        categoryName: json["category_name"],
        displayOrder: json["display_order"],
        playlist: List<Playlist>.from(
            json["playlist"].map((x) => Playlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_code": categoryCode,
        "category_name": categoryName,
        "display_order": displayOrder,
        "playlist": List<dynamic>.from(playlist!.map((x) => x.toJson())),
      };
}

class Playlist {
  Playlist({
    this.id,
    this.userId,
    this.productId,
    this.action,
    this.datetime,
    this.lasttimePlayDatetime,
    this.playedTime,
    this.numberOfPlayed,
    this.status,
    this.isChecked,
    this.isOnPlaylist,
    this.product,
  });

  int? id;
  int? userId;
  int? productId;
  dynamic action;
  dynamic datetime;
  dynamic lasttimePlayDatetime;
  dynamic playedTime;
  dynamic numberOfPlayed;
  int? status;
  bool? isChecked;
  String? isOnPlaylist;
  Product? product;

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        action: json["action"],
        datetime: json["datetime"],
        lasttimePlayDatetime: json["lasttime_play_datetime"],
        playedTime: json["played_time"],
        numberOfPlayed: json["number_of_played"],
        status: json["status"],
        isChecked: json["is_checked"],
        isOnPlaylist: json["is_on_playlist"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "action": action,
        "datetime": datetime,
        "lasttime_play_datetime": lasttimePlayDatetime,
        "played_time": playedTime,
        "number_of_played": numberOfPlayed,
        "status": status,
        "is_checked": isChecked,
        "is_on_playlist": isOnPlaylist,
        "product": product!.toJson(),
      };
}

class Product {
  Product({
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
  DateTime? publishDateFrom;
  DateTime? publishDateTo;
  String? publishFlg;
  String? isRecommended;
  dynamic publishLogicId;
  dynamic isSet;
  dynamic setProductList;
  dynamic setNumber;
  dynamic setLength;
  int? movieCategory;
  dynamic liveZoomUrl;
  dynamic liveZoomId;
  dynamic liveZoomPassword;
  dynamic liveMemo;
  dynamic liveDate;
  dynamic liveOption1;
  dynamic liveOption2;
  dynamic liveOption3;
  dynamic liveOption4;
  dynamic liveOption5;
  String? movieUrl;
  String? movieCode;
  dynamic movieOption1;
  dynamic movieOption2;
  dynamic movieOption3;
  dynamic movieOption4;
  dynamic movieOption5;
  String? previewUrl;
  String? previewCode;
  dynamic previewTime;
  dynamic previewMemo;
  dynamic displayOrder;
  bool? isPremium;
  int? likeCount;
  int? commentCount;
  bool? liked;
  int? pageView;
  int? uniqueView;
  bool? isChecked;
  bool? isOnPlaylist;
  dynamic playedTime;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productCategory: json["product_category"],
        memberType: json["member_type"],
        hostId: json["host_id"],
        productCode: json["product_code"],
        productTitle: json["product_title"],
        shortDescription: json["short_description"],
        tags: json["tags"],
        price: json["price"],
        movieDuration: json["movie_duration"],
        profileImage: json["profile_image"],
        publishDateFrom: DateTime.parse(json["publish_date_from"]),
        publishDateTo: DateTime.parse(json["publish_date_to"]),
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
        "publish_date_from":
            "${publishDateFrom!.year.toString().padLeft(4, '0')}-${publishDateFrom!.month.toString().padLeft(2, '0')}-${publishDateFrom!.day.toString().padLeft(2, '0')}",
        "publish_date_to":
            "${publishDateTo!.year.toString().padLeft(4, '0')}-${publishDateTo!.month.toString().padLeft(2, '0')}-${publishDateTo!.day.toString().padLeft(2, '0')}",
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
        "is_checked": isChecked,
        "is_on_playlist": isOnPlaylist,
        "played_time": playedTime,
      };
}
