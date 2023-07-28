// To parse this JSON data, do
//
//     final occupationListModel = occupationListModelFromJson(jsonString);

import 'dart:convert';

OccupationListModel occupationListModelFromJson(String str) => OccupationListModel.fromJson(json.decode(str));

String occupationListModelToJson(OccupationListModel data) => json.encode(data.toJson());

class OccupationListModel {
  OccupationListModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  Map<String, String>? data;
  int? code;

  factory OccupationListModel.fromJson(Map<String, dynamic> json) =>
      OccupationListModel(
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
