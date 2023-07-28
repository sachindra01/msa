// To parse this JSON data, do
//
//     final inquiryModel = inquiryModelFromJson(jsonString);

import 'dart:convert';

InquiryModel inquiryModelFromJson(String str) =>
    InquiryModel.fromJson(json.decode(str));

String inquiryModelToJson(InquiryModel data) => json.encode(data.toJson());

class InquiryModel {
  InquiryModel({
    this.success,
    this.message,
    this.code,
  });

  bool? success;
  String? message;
  int? code;

  factory InquiryModel.fromJson(Map<String, dynamic> json) => InquiryModel(
        success: json["success"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "code": code,
      };
}
