import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final DateTime? datetime;
  final String? senderId;
  final String? senderName;
  final String? senderProfileImageURl;
  final String? systemMessage;
  final String? text;
  final String? userName;
  final String? reply;
  final String? deleted;
  final String? unixTimestamp;
  final List? files;

  Message(
    {
      this.id,
      this.datetime,
      this.senderId,
      this.senderName,
      this.senderProfileImageURl,
      this.systemMessage,
      this.text,
      this.userName,
      this.reply,
      this.deleted,
      this.unixTimestamp,
      this.files
    }
  );

  factory Message.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc})
  {
    return Message(
      id : doc.id,
      datetime : doc['datetime']!=""?DateTime.fromMicrosecondsSinceEpoch(doc['datetime'].microsecondsSinceEpoch):null,
      senderId : doc.data()?.containsKey('sender_id')==false?'':doc["sender_id"].toString(),
      senderName : doc.data()?.containsKey('sender_name')==false?'':doc["sender_name"].toString(),
      senderProfileImageURl :  doc.data()?.containsKey('sender_profile_image_url')==false?'':doc["sender_profile_image_url"].toString(),
      systemMessage :  doc.data()?.containsKey('system_message')==false?'':doc["system_message"].toString(),
      text : doc.data()?.containsKey('text')==false?'':doc["text"].toString(),
      userName : doc.data()?.containsKey('user_name')==false?'':doc["user_name"].toString(),
      reply : doc.data()?.containsKey('reply')==false?'':doc['reply'].toString(),
      deleted :  doc.data()?.containsKey('deleted')==false?'':doc["deleted"].toString(),
      unixTimestamp: doc.data()?.containsKey('unix_timestamp')==false?'':doc["unix_timestamp"].toString(),
      files : doc.data()?.containsKey('files')==false
      ? []
      : doc["files"] == 'null'
      ? []
      : List.from(doc["files"]!.map((x) => x)),
    );
  }

}