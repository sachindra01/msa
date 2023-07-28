// To parse this JSON data, do
//
//     final logInModel = logInModelFromJson(jsonString);

import 'dart:convert';

LogInModel logInModelFromJson(String str) => LogInModel.fromJson(json.decode(str));

String logInModelToJson(LogInModel data) => json.encode(data.toJson());

class LogInModel {
    LogInModel({
        this.success,
        this.data,
        this.message,
        this.code,
    });

    bool? success;
    Data? data;
    String? message;
    int? code;

    factory LogInModel.fromJson(Map<String, dynamic> json) => LogInModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "message": message,
        "code": code,
    };
}

class Data {
    Data({
        this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.isActive,
        this.signupToken,
        this.passwordToken,
        this.deleteFlg,
        this.userType,
        this.createdAt,
        this.updatedAt,
        this.apiToken,
        this.deviceId,
        this.fcmToken,
        this.stripeId,
        this.cardBrand,
        this.cardLastFour,
        this.trialEndsAt,
        this.nickname,
        this.designation,
        this.shortDescription,
        this.profileImage,
        this.isPremium,
        this.memberType,
        this.kanaFirstName,
        this.firstLogin,
        this.freeUserData,
    });

    int? id;
    String? name;
    String? email;
    dynamic emailVerifiedAt;
    int? isActive;
    dynamic signupToken;
    dynamic passwordToken;
    int? deleteFlg;
    int? userType;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? apiToken;
    String? deviceId;
    String? fcmToken;
    String? stripeId;
    String? cardBrand;
    String? cardLastFour;
    dynamic trialEndsAt;
    String? nickname;
    String? designation;
    String? shortDescription;
    String? profileImage;
    bool? isPremium;
    String? memberType;
    String? kanaFirstName;
    bool? firstLogin;
    FreeUserData? freeUserData;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        isActive: json["is_active"],
        signupToken: json["signup_token"],
        passwordToken: json["password_token"],
        deleteFlg: json["delete_flg"],
        userType: json["user_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        apiToken: json["api_token"],
        deviceId: json["device_id"],
        fcmToken: json["fcm_token"],
        stripeId: json["stripe_id"],
        cardBrand: json["card_brand"],
        cardLastFour: json["card_last_four"],
        trialEndsAt: json["trial_ends_at"],
        nickname: json["nickname"],
        designation: json["designation"],
        shortDescription: json["short_description"],
        profileImage: json["profile_image"],
        isPremium: json["is_premium"],
        memberType: json["member_type"],
        kanaFirstName: json["kana_first_name"],
        firstLogin: json["first_login"],
        freeUserData: FreeUserData.fromJson(json["free_user_data"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "is_active": isActive,
        "signup_token": signupToken,
        "password_token": passwordToken,
        "delete_flg": deleteFlg,
        "user_type": userType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "api_token": apiToken,
        "device_id": deviceId,
        "fcm_token": fcmToken,
        "stripe_id": stripeId,
        "card_brand": cardBrand,
        "card_last_four": cardLastFour,
        "trial_ends_at": trialEndsAt,
        "nickname": nickname,
        "designation": designation,
        "short_description": shortDescription,
        "profile_image": profileImage,
        "is_premium": isPremium,
        "member_type": memberType,
        "kana_first_name": kanaFirstName,
        "first_login": firstLogin,
        "free_user_data": freeUserData!.toJson(),
    };
}

class FreeUserData {
    FreeUserData({
        this.image,
        this.url,
    });

    String? image;
    String? url;

    factory FreeUserData.fromJson(Map<String, dynamic> json) => FreeUserData(
        image: json["image"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "url": url,
    };
}
