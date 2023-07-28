// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
    ProductListModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
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
        this.recommendedProducts,
        this.category,
    });

    List<Product>? recommendedProducts;
    List<Category>? category;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        recommendedProducts: List<Product>.from(json["recommendedProducts"].map((x) => Product.fromJson(x))),
        category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "recommendedProducts": List<dynamic>.from(recommendedProducts!.map((x) => x.toJson())),
        "category": List<dynamic>.from(category!.map((x) => x.toJson())),
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
        this.products,
    });

    int? id;
    String? categoryCode;
    String? categoryName;
    String? categoryDescription;
    String? categoryImage;
    String? categoryLinkUrl;
    String? categoryMembershipStatus;
    String? categoryStatus;
    int? displayOrder;
    List<Product>? products;

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
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
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
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
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
    String? publishDateFrom;
    String? publishDateTo;
    String? publishFlg;
    String? isRecommended;
    int? publishLogicId;
    String? isSet;
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
    bool? isChecked;
    bool? isOnPlaylist;
    String? playedTime;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productCategory: json["product_category"],
        memberType: json["member_type"],
        hostId: json["host_id"],
        productCode: json["product_code"],
        productTitle: json["product_title"] ?? '',
        shortDescription: json["short_description"],
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
        movieUrl: json["movie_url"] ?? '',
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
        pageView: json["page_view"] ?? 0,
        uniqueView: json["unique_view"] ?? 0,
        isChecked: json["is_checked"],
        isOnPlaylist: json["is_on_playlist"],
        playedTime: json["played_time"] ?? '',
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
        "movie_url": movieUrl ?? '',
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
        "page_view": pageView ?? 0,
        "unique_view": uniqueView ?? 0,
        "is_checked": isChecked,
        "is_on_playlist": isOnPlaylist,
        "played_time": playedTime ?? '',
    };
}
