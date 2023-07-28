// To parse this JSON data, do
//
//     final SaveMemberReport = SaveMemberReportFromJson(jsonString);

import 'dart:convert';

SaveMemberReport saveMemberReportFromJson(String str) =>
    SaveMemberReport.fromJson(json.decode(str));

String saveMemberReportToJson(SaveMemberReport data) =>
    json.encode(data.toJson());

class SaveMemberReport {
  SaveMemberReport({
    this.success,
    this.data,
    this.code,
  });

  bool? success;
  Data? data;
  int? code;

  factory SaveMemberReport.fromJson(Map<String, dynamic> json) =>
      SaveMemberReport(
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
    this.earning,
    this.grossProfit,
    this.expenses,
    this.monthGoal,
    this.askHost,
    this.nextMonthGoal,
    this.userId,
    this.reportStatus,
  });

  String? earning;
  String? grossProfit;
  String? expenses;
  String? monthGoal;
  String? askHost;
  String? nextMonthGoal;
  int? userId;
  String? reportStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        earning: json["earning"],
        grossProfit: json["gross_profit"],
        expenses: json["expenses"],
        monthGoal: json["month_goal"],
        askHost: json["ask_host"],
        nextMonthGoal: json["next_month_goal"],
        userId: json["user_id"],
        reportStatus: json["report_status"],
      );

  Map<String, dynamic> toJson() => {
        "earning": earning,
        "gross_profit": grossProfit,
        "expenses": expenses,
        "month_goal": monthGoal,
        "ask_host": askHost,
        "next_month_goal": nextMonthGoal,
        "user_id": userId,
        "report_status": reportStatus,
      };
}
