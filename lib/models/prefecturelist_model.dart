// To parse this JSON data, do
//
//     final prefectureListModel = prefectureListModelFromJson(jsonString);

import 'dart:convert';

PrefectureListModel prefectureListModelFromJson(String str) =>
    PrefectureListModel.fromJson(json.decode(str));

String prefectureListModelToJson(PrefectureListModel data) =>
    json.encode(data.toJson());

class PrefectureListModel {
  PrefectureListModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  Map<String, String>? data;
  int? code;

  factory PrefectureListModel.fromJson(Map<String, dynamic> json) =>
      PrefectureListModel(
        success: json["success"],
        data: Map.from(json["data"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "code": code,
      };
}
