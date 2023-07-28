import 'package:cloud_firestore/cloud_firestore.dart';

class MessageReadLogs {
  final int? chatId;
  final int? unixTimeStamp;
  final int? userId;
  MessageReadLogs(
    {
      this.chatId,
      this.unixTimeStamp,
      this.userId
    }
  );

  factory MessageReadLogs.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc})
  {
    return MessageReadLogs(
      chatId : doc["chat_id"],
      unixTimeStamp : doc["unix_timestamp"],
      userId : doc["user_id"],
    );
  }

}