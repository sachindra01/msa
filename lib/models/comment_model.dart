// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
    CommentModel({
        this.success,
        this.message,
        this.data,
        this.likeCount,
        this.commentCount,
        this.code,
    });

    bool ?success;
    String ?message;
    Data ?data;
    int ?likeCount;
    int ?commentCount;
    int ?code;

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data!.toJson(),
        "like_count": likeCount,
        "comment_count": commentCount,
        "code": code,
    };
}

class Data {
    Data({
        this.id,
        this.comment,
        this.type,
        this.itemId,
        this.parentId,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.reply,
    });

    int ?id;
    String ?comment;
    String ?type;
    int ?itemId;
    dynamic parentId;
    DateTime ?createdAt;
    DateTime ?updatedAt;
    User ?user;
     List<Reply>? reply;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        comment: json["comment"],
        type: json["type"],
        itemId: json["item_id"],
        parentId: json["parent_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
         reply: json["reply"] == null ? [] : List<Reply>.from(json["reply"].map((x) => Reply.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "type": type,
        "item_id": itemId,
        "parent_id": parentId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "user": user!.toJson(),
        "reply": reply == null ? [] : List<dynamic>.from(reply!.map((x) => x.toJson())),
    };
}

class Reply {
    Reply({
        this.id,
        this.comment,
        this.type,
        this.itemId,
        this.parentId,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    int? id;
    String? comment;
    String? type;
    int? itemId;
    int? parentId;
    DateTime? createdAt;
    DateTime? updatedAt;
    User? user;

    factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["id"],
        comment: json["comment"],
        type: json["type"],
        itemId: json["item_id"],
        parentId: json["parent_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "type": type,
        "item_id": itemId,
        "parent_id": parentId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "user": user!.toJson(),
    };
}

class User {
    User({
        this.id,
        this.nickname,
        this.firstName,
        this.kanaFirstName,
        this.imageUrl,
    });

    int ?id;
    String ?nickname;
    String ?firstName;
    String ?kanaFirstName;
    String ?imageUrl;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nickname: json["nickname"],
        firstName: json["first_name"],
        kanaFirstName: json["kana_first_name"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "first_name": firstName,
        "kana_first_name": kanaFirstName,
        "image_url": imageUrl,
    };
}
