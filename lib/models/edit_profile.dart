// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) =>
    EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) =>
    json.encode(data.toJson());

class EditProfileModel {
  EditProfileModel({
    this.success,
    this.data,
    this.message,
    this.code,
  });

  bool? success;
  Data? data;
  String? message;
  int? code;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      EditProfileModel(
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
    this.memberCode,
    this.firstName,
    this.lastName,
    this.kanaFirstName,
    this.kanaLastName,
    this.memberStatus,
    this.email,
    this.phoneNo1,
    this.phoneNo2,
    this.postalCode,
    this.address1,
    this.address2,
    this.address3,
    this.occupation,
    this.notificationStatus,
    this.status,
    this.gender,
    this.dobYear,
    this.dobMonth,
    this.dobDay,
    this.nickname,
    this.designation,
    this.shortDescription,
    this.lineId,
    this.profileImage,
    this.isPremium,
    this.memberType,
    this.studyLevel,
    this.levelImage,
    this.levelName,
    this.user,
    this.checkedProducts,
    this.totalProductsCount,
    this.learnedRate,
    this.membershipStatus,
    this.showAge,
    this.prefecture,
    this.firstLogin,
    this.twitterLink,
  });

  int? id;
  String? memberCode;
  String? firstName;
  String? lastName;
  String? kanaFirstName;
  String? kanaLastName;
  dynamic memberStatus;
  String? email;
  dynamic phoneNo1;
  dynamic phoneNo2;
  dynamic postalCode;
  dynamic address1;
  dynamic address2;
  dynamic address3;
  dynamic occupation;
  dynamic notificationStatus;
  dynamic status;
  String? gender;
  String? dobYear;
  dynamic dobMonth;
  dynamic dobDay;
  String? nickname;
  String? designation;
  String? shortDescription;
  dynamic lineId;
  String? profileImage;
  bool? isPremium;
  dynamic memberType;
  dynamic studyLevel;
  String? levelImage;
  String? levelName;
  User? user;
  int? checkedProducts;
  int? totalProductsCount;
  String? learnedRate;
  dynamic membershipStatus;
  dynamic showAge;
  String? prefecture;
  bool? firstLogin;
  String? twitterLink;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        memberCode: json["member_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        kanaFirstName: json["kana_first_name"],
        kanaLastName: json["kana_last_name"],
        memberStatus: json["member_status"],
        email: json["email"],
        phoneNo1: json["phone_no1"],
        phoneNo2: json["phone_no2"],
        postalCode: json["postal_code"],
        address1: json["address_1"],
        address2: json["address2"],
        address3: json["address3"],
        occupation: json["occupation"],
        notificationStatus: json["notification_status"],
        status: json["status"],
        gender: json["gender"],
        dobYear: json["dob_year"],
        dobMonth: json["dob_month"],
        dobDay: json["dob_day"],
        nickname: json["nickname"],
        designation: json["designation"],
        shortDescription: json["short_description"],
        lineId: json["line_id"],
        profileImage: json["profile_image"],
        isPremium: json["is_premium"],
        memberType: json["member_type"],
        studyLevel: json["study_level"],
        levelImage: json["level_image"],
        levelName: json["level_name"],
        user: User.fromJson(json["user"]),
        checkedProducts: json["checked_products"],
        totalProductsCount: json["total_products_count"],
        learnedRate: json["learned_rate"].toString(),
        membershipStatus: json["membership_status"],
        showAge: json["show_age"],
        prefecture: json["prefecture"],
        firstLogin: json["first_login"],
        twitterLink: json["twitter_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "member_code": memberCode,
        "first_name": firstName,
        "last_name": lastName,
        "kana_first_name": kanaFirstName,
        "kana_last_name": kanaLastName,
        "member_status": memberStatus,
        "email": email,
        "phone_no1": phoneNo1,
        "phone_no2": phoneNo2,
        "postal_code": postalCode,
        "address_1": address1,
        "address2": address2,
        "address3": address3,
        "occupation": occupation,
        "notification_status": notificationStatus,
        "status": status,
        "gender": gender,
        "dob_year": dobYear,
        "dob_month": dobMonth,
        "dob_day": dobDay,
        "nickname": nickname,
        "designation": designation,
        "short_description": shortDescription,
        "line_id": lineId,
        "profile_image": profileImage,
        "is_premium": isPremium,
        "member_type": memberType,
        "study_level": studyLevel,
        "level_image": levelImage,
        "level_name": levelName,
        "user": user!.toJson(),
        "checked_products": checkedProducts,
        "total_products_count": totalProductsCount,
        "learned_rate": learnedRate,
        "membership_status": membershipStatus,
        "show_age": showAge,
        "prefecture": prefecture,
        "first_login": firstLogin,
        "twitter_link": twitterLink,
      };
}

class User {
  User({
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
  });

  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  int? isActive;
  dynamic signupToken;
  String? passwordToken;
  int? deleteFlg;
  int? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? apiToken;
  String? deviceId;
  String? fcmToken;
  dynamic stripeId;
  dynamic cardBrand;
  dynamic cardLastFour;
  dynamic trialEndsAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "api_token": apiToken,
        "device_id": deviceId,
        "fcm_token": fcmToken,
        "stripe_id": stripeId,
        "card_brand": cardBrand,
        "card_last_four": cardLastFour,
        "trial_ends_at": trialEndsAt,
      };
}
