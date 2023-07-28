// To parse this JSON data, do
//
//     final FirstLoginMessage = FirstLoginMessageFromJson(jsonString);

import 'dart:convert';

FirstLoginMessage firstLoginMessageFromJson(String str) => FirstLoginMessage.fromJson(json.decode(str));

String firstLoginMessageToJson(FirstLoginMessage data) => json.encode(data.toJson());

class FirstLoginMessage {
    FirstLoginMessage({
        this.success,
        this.data,
    });

    bool? success;
    List<Datum>? data;

    factory FirstLoginMessage.fromJson(Map<String, dynamic> json) => FirstLoginMessage(
        success: json["success"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.image,
        this.link,
    });

    String? image;
    String? link;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        image: json["image"],
        link: json["link"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "link": link,
    };
}
