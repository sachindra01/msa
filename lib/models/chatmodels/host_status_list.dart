// To parse this JSON data, do
//
//     final statusList = statusListFromJson(jsonString);

import 'dart:convert';

StatusList statusListFromJson(String str) =>
    StatusList.fromJson(json.decode(str));

String statusListToJson(StatusList data) => json.encode(data.toJson());

class StatusList {
  StatusList({
    this.success,
    this.data,
    this.allCount,
    this.code,
  });

  bool? success;
  Data? data;
  int? allCount;
  int? code;

  factory StatusList.fromJson(Map<String, dynamic> json) => StatusList(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        allCount: json["all_count"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "all_count": allCount,
        "code": code,
      };
}

class Data {
  Data({
    this.dataNew,
    this.replied,
    this.hold,
    this.all,
  });

  All? dataNew;
  All? replied;
  All? hold;
  All? all;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dataNew: All.fromJson(json["new"]),
        replied: All.fromJson(json["replied"]),
        hold: All.fromJson(json["hold"]),
        all: All.fromJson(json["all"]),
      );

  Map<String, dynamic> toJson() => {
        "new": dataNew!.toJson(),
        "replied": replied!.toJson(),
        "hold": hold!.toJson(),
        "all": all!.toJson(),
      };
}

class All {
  All({
    this.count,
    this.label,
    this.labelEn,
  });

  int? count;
  String? label;
  String? labelEn;

  factory All.fromJson(Map<String, dynamic> json) => All(
        count: json["count"],
        label: json["label"],
        labelEn: json["label_en"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "label": label,
        "label_en": labelEn,
      };
}
