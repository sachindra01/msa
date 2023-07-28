// To parse this JSON data, do
//
//     final hostReplyModel = hostReplyModelFromJson(jsonString);

import 'dart:convert';

HostReplyModel hostReplyModelFromJson(String str) =>
    HostReplyModel.fromJson(json.decode(str));

String hostReplyModelToJson(HostReplyModel data) => json.encode(data.toJson());

class HostReplyModel {
  HostReplyModel({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  Data? data;
  int? code;

  factory HostReplyModel.fromJson(Map<String, dynamic> json) => HostReplyModel(
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
    this.nextMonthGoalReply,
    this.reportStatus,
    this.replyBy,
    this.replyDate,
    this.label,
    this.labelEn,
  });

  String? nextMonthGoalReply;
  String? reportStatus;
  int? replyBy;
  DateTime? replyDate;
  String? label;
  String? labelEn;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        nextMonthGoalReply: json["next_month_goal_reply"],
        reportStatus: json["report_status"],
        replyBy: json["reply_by"],
        replyDate: DateTime.parse(json["reply_date"]),
        label: json["label"],
        labelEn: json["label_en"],
      );

  Map<String, dynamic> toJson() => {
        "next_month_goal_reply": nextMonthGoalReply,
        "report_status": reportStatus,
        "reply_by": replyBy,
        "reply_date": replyDate!.toIso8601String(),
        "label": label,
        "label_en": labelEn,
      };
}
