// To parse this JSON data, do
//
//     final tokenValidityModel = tokenValidityModelFromJson(jsonString);

import 'dart:convert';

TokenValidityModel tokenValidityModelFromJson(String str) => TokenValidityModel.fromJson(json.decode(str));

String tokenValidityModelToJson(TokenValidityModel data) => json.encode(data.toJson());

class TokenValidityModel {
    TokenValidityModel({
        this.success,
        this.message,
        this.data,
        this.code,
    });

    bool? success;
    String? message;
    Data? data;
    int? code;

    factory TokenValidityModel.fromJson(Map<String, dynamic> json) => TokenValidityModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toJson(),
        "code": code,
    };
}

class Data {
    Data({
        this.notifyFlg,
    });

    bool? notifyFlg;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        notifyFlg: json["notify_flg"],
    );

    Map<String, dynamic> toJson() => {
        "notify_flg": notifyFlg,
    };
}
