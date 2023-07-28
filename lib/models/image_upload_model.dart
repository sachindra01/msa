// To parse this JSON data, do
//
//     final imageUploadSuccess = imageUploadSuccessFromJson(jsonString);

import 'dart:convert';

ImageUploadSuccess imageUploadSuccessFromJson(String str) =>
    ImageUploadSuccess.fromJson(json.decode(str));

String imageUploadSuccessToJson(ImageUploadSuccess data) =>
    json.encode(data.toJson());

class ImageUploadSuccess {
  ImageUploadSuccess({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  Data? data;
  int? code;

  factory ImageUploadSuccess.fromJson(Map<String, dynamic> json) =>
      ImageUploadSuccess(
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
    this.image,
  });

  String? image;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
