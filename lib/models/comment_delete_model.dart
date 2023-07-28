// To parse this JSON data, do
//
//     final commentDeleteModel = commentDeleteModelFromJson(jsonString);

import 'dart:convert';

CommentDeleteModel commentDeleteModelFromJson(String str) => CommentDeleteModel.fromJson(json.decode(str));

String commentDeleteModelToJson(CommentDeleteModel data) => json.encode(data.toJson());

class CommentDeleteModel {
    CommentDeleteModel({
        this.success,
        this.message,
        this.commentCount,
        this.code,
    });

    bool? success;
    String? message;
    int? commentCount;
    int? code;

    factory CommentDeleteModel.fromJson(Map<String, dynamic> json) => CommentDeleteModel(
        success: json["success"],
        message: json["message"],
        commentCount: json["comment_count"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "comment_count": commentCount,
        "code": code,
    };
}
