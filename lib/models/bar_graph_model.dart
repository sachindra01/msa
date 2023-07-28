// To parse this JSON data, do
//
//     final barGraphModel = barGraphModelFromJson(jsonString);

import 'dart:convert';

BarGraphModel barGraphModelFromJson(String str) => BarGraphModel.fromJson(json.decode(str));

String barGraphModelToJson(BarGraphModel data) => json.encode(data.toJson());

class BarGraphModel {
    BarGraphModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    List<Datum> ?data;
    int ?code;

    factory BarGraphModel.fromJson(Map<String, dynamic> json) => BarGraphModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "code": code,
    };
}

class Datum {
    Datum({
        this.data,
        this.label,
    });

    List<int>? data;
    String ?label;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        data: List<int>.from(json["data"].map((x) => x)),
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x)),
        "label": label,
    };
}
