// To parse this JSON data, do
//
//     final memberReport = memberReportFromJson(jsonString);

import 'dart:convert';

MemberReport memberReportFromJson(String str) =>
    MemberReport.fromJson(json.decode(str));

String memberReportToJson(MemberReport data) => json.encode(data.toJson());

class MemberReport {
  MemberReport({
    this.success,
    this.data,
    this.reportStatuses,
    this.code,
  });

  bool? success;
  List<Datum>? data;
  ReportStatuses? reportStatuses;
  int? code;

  factory MemberReport.fromJson(Map<String, dynamic> json) => MemberReport(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        reportStatuses: ReportStatuses.fromJson(json["report_statuses"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "report_statuses": reportStatuses!.toJson(),
        "code": code,
      };
}

class Datum {
  Datum({
    this.id,
    this.reportStatus,
    this.label,
    this.labelEn,
    this.userId,
    this.replyDate,
    this.reportDate,
    this.earning,
    this.grossProfit,
    this.expenses,
    this.monthGoal,
    this.askHost,
    this.nextMonthGoal,
    this.earningReply,
    this.grossProfitReply,
    this.expensesReply,
    this.monthGoalReply,
    this.askHostReply,
    this.nextMonthGoalReply,
    this.clientReplySeen,
    this.labelMember,
    this.labelEnMember,
  });

  int? id;
  String? reportStatus;
  String? label;
  String? labelEn;
  int? userId;
  dynamic replyDate;
  DateTime? reportDate;
  String? earning;
  String? grossProfit;
  dynamic expenses;
  dynamic monthGoal;
  dynamic askHost;
  dynamic nextMonthGoal;
  dynamic earningReply;
  dynamic grossProfitReply;
  dynamic expensesReply;
  dynamic monthGoalReply;
  dynamic askHostReply;
  dynamic nextMonthGoalReply;
  bool? clientReplySeen;
  String? labelMember;
  String? labelEnMember;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        reportStatus: json["report_status"],
        label: json["label"],
        labelEn: json["label_en"],
        userId: json["user_id"],
        replyDate: json["reply_date"],
        reportDate: DateTime.parse(json["report_date"]),
        earning: json["earning"],
        grossProfit: json["gross_profit"],
        expenses: json["expenses"],
        monthGoal: json["month_goal"],
        askHost: json["ask_host"],
        nextMonthGoal: json["next_month_goal"],
        earningReply: json["earning_reply"],
        grossProfitReply: json["gross_profit_reply"],
        expensesReply: json["expenses_reply"],
        monthGoalReply: json["month_goal_reply"],
        askHostReply: json["ask_host_reply"],
        nextMonthGoalReply: json["next_month_goal_reply"],
        clientReplySeen: json["client_reply_seen"],
        labelMember: json["label_member"],
        labelEnMember: json["label_en_member"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "report_status": reportStatus,
        "label": label,
        "label_en": labelEn,
        "user_id": userId,
        "reply_date": replyDate,
        "report_date":
            "${reportDate!.year.toString().padLeft(4, '0')}-${reportDate!.month.toString().padLeft(2, '0')}-${reportDate!.day.toString().padLeft(2, '0')}",
        "earning": earning,
        "gross_profit": grossProfit,
        "expenses": expenses,
        "month_goal": monthGoal,
        "ask_host": askHost,
        "next_month_goal": nextMonthGoal,
        "earning_reply": earningReply,
        "gross_profit_reply": grossProfitReply,
        "expenses_reply": expensesReply,
        "month_goal_reply": monthGoalReply,
        "ask_host_reply": askHostReply,
        "next_month_goal_reply": nextMonthGoalReply,
        "client_reply_seen": clientReplySeen,
        "label_member": labelMember,
        "label_en_member": labelEnMember,
      };
}

class ReportStatuses {
  ReportStatuses({
    this.reportStatusesNew,
    this.replied,
    this.hold,
  });

  Hold? reportStatusesNew;
  Hold? replied;
  Hold? hold;

  factory ReportStatuses.fromJson(Map<String, dynamic> json) => ReportStatuses(
        reportStatusesNew: Hold.fromJson(json["new"]),
        replied: Hold.fromJson(json["replied"]),
        hold: Hold.fromJson(json["hold"]),
      );

  Map<String, dynamic> toJson() => {
        "new": reportStatusesNew!.toJson(),
        "replied": replied!.toJson(),
        "hold": hold!.toJson(),
      };
}

class Hold {
  Hold({
    this.label,
    this.labelEn,
  });

  String? label;
  String? labelEn;

  factory Hold.fromJson(Map<String, dynamic> json) => Hold(
        label: json["label"],
        labelEn: json["label_en"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "label_en": labelEn,
      };
}
