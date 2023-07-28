import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUsInfo {
  final String? chatStatus;
  final String? hostUnreadMessage;
  final String? nickName;
  final String? profileImageUrl;
  final String? status;
  final String? userId;
  final String? userUnreadMessage;
  final String? deleteFlg;
  final String? createdAt;
  final String? updatedAt;

  ContactUsInfo(
    {
      this.chatStatus,
      this.nickName,
      this.profileImageUrl,
      this.status,
      this.userId,
      this.hostUnreadMessage,
      this.userUnreadMessage,
      this.deleteFlg,
      this.createdAt,
      this.updatedAt
    }
  );

  factory ContactUsInfo.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc})
  {
    return ContactUsInfo(
      chatStatus : doc["chat_status"].toString(),
      nickName : doc["nickname"].toString(),
      profileImageUrl : doc["profile_image_url"].toString(),
      status : doc["status"].toString(),
      userId : doc["user_id"].toString(),
      hostUnreadMessage : doc["host_unread_messages"].toString(),
      userUnreadMessage : doc["user_unread_messages"].toString(),
      deleteFlg : doc["delete_flg"].toString(),
      createdAt : doc["created_at"].toString(),
      updatedAt : doc["updated_at"].toString(),
    );
  }

}