import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomInfo {
  final String? id;
  final String? title;
  final String? status;
  final String? isPremium;
  final String? imageUrl;
  final String? description;
  final String? deleteFlg;
  final List<int>? members;
  final List? messageReadLogs;
  final String? lastMessage;
  final String? totalMembers;

  ChatRoomInfo(
    {
      this.id,
      this.title,
      this.status,
      this.isPremium,
      this.imageUrl,
      this.description,
      this.deleteFlg,
      this.members,
      this.messageReadLogs,
      this.lastMessage,
      this.totalMembers
    }
  );

  factory ChatRoomInfo.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc})
  {
    return ChatRoomInfo(
      id : doc.id,
      title : doc["title"],
      status : doc["status"].toString(),
      isPremium : doc["is_premium"].toString(),
      imageUrl : doc["image_url"].toString(),
      description : doc["description"].toString(),
      deleteFlg : doc["delete_flg"].toString(),
      lastMessage: doc["last_message"].toString(),
      totalMembers: doc["total_members"].toString(),
      members : doc.data()?.containsKey('members')==false
      ? []
      : doc["members"] == 'null'
      ? []
      : List<int>.from(doc["members"]!.map((x) => x)),
      messageReadLogs : doc.data()?.containsKey('message_read_logs')==false
      ? []
      : doc["message_read_logs"] == 'null'
      ? []
      : List.from(doc["message_read_logs"]!.map((x) => x)),
    );
  }

}