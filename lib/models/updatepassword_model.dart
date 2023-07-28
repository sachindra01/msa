// To parse this JSON data, do
//
//     final updatePasswordModel = updatePasswordModelFromJson(jsonString);

import 'dart:convert';

UpdatePasswordModel updatePasswordModelFromJson(String str) => UpdatePasswordModel.fromJson(json.decode(str));

String updatePasswordModelToJson(UpdatePasswordModel data) => json.encode(data.toJson());

class UpdatePasswordModel {
    UpdatePasswordModel({
        this.success,
        this.message,
        this.code,
    });

    bool? success;
    String? message;
    int? code;

    factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) => UpdatePasswordModel(
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
