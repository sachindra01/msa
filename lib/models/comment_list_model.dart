// To parse this JSON data, do
//
//     final commentModellist = commentModellistFromJson(jsonString);

import 'dart:convert';

CommentModellist commentModellistFromJson(String str) =>
    CommentModellist.fromJson(json.decode(str));

String commentModellistToJson(CommentModellist data) =>
    json.encode(data.toJson());

class CommentModellist {
  CommentModellist({
    this.success,
    this.data,
    this.likeCount,
    this.commentCount,
    this.title,
    this.liked,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  int? likeCount;
  int? commentCount;
  String? title;
  bool? liked;
  int? code;

  factory CommentModellist.fromJson(Map<String, dynamic> json) =>
    CommentModellist(
      success: json["success"],
      data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      likeCount: json["like_count"],
      commentCount: json["comment_count"],
      title: json["title"],
      liked: json["liked"],
      code: json["code"],
    );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "like_count": likeCount,
    "comment_count": commentCount,
    "title": title,
    "liked": liked,
    "code": code,
  };
}

class Datum {
  Datum({
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

  int? id;
  String? comment;
  String? type;
  int? itemId;
  dynamic parentId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  List<Reply>? reply;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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

  int? id;
  String? nickname;
  String? firstName;
  String? kanaFirstName;
  String? imageUrl;

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
