// To parse this JSON data, do
//
//     final avatarModel = avatarModelFromJson(jsonString);

import 'dart:convert';

AvatarModel avatarModelFromJson(String str) =>
    AvatarModel.fromJson(json.decode(str));

String avatarModelToJson(AvatarModel data) => json.encode(data.toJson());

class AvatarModel {
  AvatarModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  int? code;

  factory AvatarModel.fromJson(Map<String, dynamic> json) => AvatarModel(
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
    this.code,
    this.name,
    this.src,
  });

  String? code;
  String? name;
  String? src;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        code: json["code"],
        name: json["name"],
        src: json["src"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "src": src,
      };
}
