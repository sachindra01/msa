import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/constants.dart' as constants;
import 'package:msa/models/chatmodels/chat_room_info.dart';
import 'package:msa/models/chatmodels/contact_us_info.dart';
import 'package:msa/models/chatmodels/message_model.dart';
import 'package:msa/models/chatmodels/message_read_logs.dart';
import 'package:msa/models/chatmodels/user.dart';

final FirebaseFirestore firestore                    = FirebaseFirestore.instance;
final String dbCollectionUsers                       = constants.firebaseCollection['users'];
final CollectionReference mainUsersCollection        = firestore.collection(dbCollectionUsers);
final String dbCollectionChatRoomInfo                = constants.firebaseCollection['chatRoomInfo'];
final CollectionReference mainChatRoomInfoCollection = firestore.collection(dbCollectionChatRoomInfo);
final String dbCollectionChatRooms                   = constants.firebaseCollection['chatRooms'];
final CollectionReference mainChatRoomsCollection    = firestore.collection(dbCollectionChatRooms);
final String dbCollectionContactUs                   = constants.firebaseCollection['contactUs'];
final CollectionReference mainContactUsCollection    = firestore.collection(dbCollectionContactUs);
final String dbCollectionContactUsInfo               = constants.firebaseCollection['contactUsInfo'];
final CollectionReference mainContactUsInfoCollection= firestore.collection(dbCollectionContactUsInfo);
final String dbCollectionChatRoomLogs                = constants.firebaseCollection['chatRoomLogs'];
final CollectionReference mainChatRoomLogsCollection = firestore.collection(dbCollectionChatRoomLogs);

class FirestoreServices {

  //Get Chat Room Detail List
  static Stream<ChatRoomInfo>getChatRoomInfoDetail(chatRoomInfoId) {
    try{
      return 
        mainChatRoomInfoCollection.doc(chatRoomInfoId)
        .snapshots()
        .map((chatRoom){
          final ChatRoomInfo chatRoomDetailFromFirestore;
          chatRoomDetailFromFirestore = ChatRoomInfo.fromDocumentSnapshot(doc:chatRoom as DocumentSnapshot<Map<String, dynamic>>);
          return chatRoomDetailFromFirestore;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  //Get Chat Message Detail as per chatRoomId
  static Stream<List<Message>>getChatMessages(chatRoomId,descending) {
    try{
      return 
        mainChatRoomsCollection.doc(chatRoomId)
        .collection('chat-messages')
        // .where('deleted', isEqualTo: false)
        .orderBy('datetime',descending: descending)
        .snapshots()
        .map((message){
          final List<Message> messagesFromFirestore = <Message>[];
            for(final DocumentSnapshot<Map<String,dynamic>> doc in message.docs){
              messagesFromFirestore.add(Message.fromDocumentSnapshot(doc:doc));
            }
          return messagesFromFirestore;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  //Get Chat Message Detail as per chatRoomId
  static Stream<List<Message>>getChatMessagesByUnix(chatRoomId) {
    try{
      return 
        mainChatRoomsCollection.doc(chatRoomId)
        .collection('chat-messages')
        // .where('deleted', isEqualTo: false)
        .orderBy('unix_timestamp')
        .snapshots()
        .map((message){
          final List<Message> messagesFromFirestore = <Message>[];
            for(final DocumentSnapshot<Map<String,dynamic>> doc in message.docs){
              messagesFromFirestore.add(Message.fromDocumentSnapshot(doc:doc));
            }
          return messagesFromFirestore;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  //Get Chat Message Detail as per chatRoomId
  static Stream<List<Message>>getInquiryChatMessages(chatRoomId,descending) {
    try{
      return 
        mainContactUsCollection.doc(chatRoomId)
        .collection('chat-messages')
        // .where('deleted', isEqualTo: false)
        .orderBy('datetime',descending: descending)
        .snapshots()
        .map((message){
          final List<Message> messagesFromFirestore = <Message>[];
            for(final DocumentSnapshot<Map<String,dynamic>> doc in message.docs){
              messagesFromFirestore.add(Message.fromDocumentSnapshot(doc:doc));
            }
          return messagesFromFirestore;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  static Stream<User>getUserProfile(userId) {
    try{
      return 
        mainUsersCollection.doc(userId)
        .snapshots()
        .map((user){
          final User userDetail;
          userDetail = User.fromDocumentSnapshot(doc:user as DocumentSnapshot<Map<String, dynamic>>);
          return userDetail;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  //Send Message
  static Future<void> sendMessage({
    required String docId,
    required int senderId,
    required String senderName,
    required String senderProfileImageUrl,
    required String text,
    String? fileUrl,
    String? fileName,
  }) async {
    DocumentReference documentReferencer = mainChatRoomsCollection.doc(docId).collection('chat-messages').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "sender_id"  : senderId,
      "sender_name": senderName,
      "sender_profile_image_url"  : senderProfileImageUrl,
      "system_message":false,
      "text"  : text,
      "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000,
      "datetime":DateTime.now(),
      "deleted" : false
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
      //
    })
    .catchError((e) {
      //
    });
  }

  //Send Image Message
  static Future<void> sendImageMessage({
    required String docId,
    required int senderId,
    required String senderName,
    required String senderProfileImageUrl,
    required String text,
    required String removeDocId,
    required String userId,
    required int preunix,
    String? fileUrl,
    String? fileName,
  }) async {
    DocumentReference documentReferencer = mainChatRoomsCollection.doc(docId).collection('chat-messages').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "sender_id"  : senderId,
      "sender_name": senderName,
      "sender_profile_image_url"  : senderProfileImageUrl,
      "system_message":false,
      "text"  : text,
      "datetime":DateTime.now(),
      "files": [{
        'downloadURL': fileUrl,
        'fileName' : fileName
      }],
      "deleted" : false,
      "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
    })
    .catchError((e) {
      //
    });
  }

  //Send Image Message for Inquiry Chat Page
  static Future<void> sendImageMessageInquiry({
    required String docId,
    required int senderId,
    required String senderName,
    required String senderProfileImageUrl,
    required String text,
    required String memberType,
    String? fileUrl,
    String? fileName,
  }) async {
    DocumentReference documentReferencer = mainContactUsCollection.doc(docId).collection('chat-messages').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "sender_id"  : senderId,
      "sender_name": senderName,
      "sender_profile_image_url"  : senderProfileImageUrl,
      "system_message":false,
      "text"  : text,
      "datetime":DateTime.now(),
      "files": [{
        'downloadURL': fileUrl,
        'fileName' : fileName
      }],
      "deleted" : false,
      "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
      if(memberType=="host"){
        updateUserUnreadCount(userId: docId, type: 'increment');
      }
      else{
        updateHostUnreadCount(userId: docId, type: 'increment');
      }
    })
    .catchError((e) {
      //
    });
  }

  //Send Message
  static Future<void> sendMessageInquiry({
    required String docId,
    required int senderId,
    required String senderName,
    required String senderProfileImageUrl,
    required String text,
    required String memberType,
  }) async {
    DocumentReference documentReferencer = mainContactUsCollection.doc(docId).collection('chat-messages').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "sender_id"  : senderId,
      "sender_name": senderName,
      "sender_profile_image_url": senderProfileImageUrl,
      "member_type":memberType,
      "system_message":false,
      "text"  : text,
      "datetime":DateTime.now(),
      "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000,
      "deleted" : false
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
      if(memberType=="host"){
        updateUserUnreadCount(userId: docId, type: 'increment');
      }
      else{
        updateHostUnreadCount(userId: docId, type: 'increment');
      }
    })
    .catchError((e) {
      //
    });
  }

  //Delete Message
  static Future<void> deleteMessageChatRoom({
    required String docId1,
    required String docId2,
  }) async {
    DocumentReference documentReferencer = mainChatRoomsCollection.doc(docId1).collection('chat-messages').doc(docId2);
    Map<String, dynamic> data = <String, dynamic>{
      // "system_message":false,
      // "text":"メッセージの送信を取り消しました",
      "deleted" : true,
      // "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000,
      "updated_at"  : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
    })
    .catchError((e) {
    });
  }

  //Delete message Contact-Us Chat Page
  static Future<void> deleteMessageContactUs({
    required String docId1,
    required String docId2,
  }) async {
    DocumentReference documentReferencer = mainContactUsCollection.doc(docId1).collection('chat-messages').doc(docId2);
    Map<String, dynamic> data = <String, dynamic>{
      // "system_message":true,
      // "text":"メッセージの送信を取り消しました",
      "deleted" : true,
      // "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000,
      "updated_at"  : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
    })
    .catchError((e) {
    });
  }

  //Participate in group
  static Future<void> participateInGroup({
    required String docId,
    required String userId,
    required String userName,
  }) async {
    await sendSystemMessage(docId: docId, text: '$userName さんが参加しました。', userName: userName);
    DocumentReference documentReferencer = mainChatRoomInfoCollection.doc(docId);
    Map<String, dynamic> data = <String, dynamic>{
      "members" : FieldValue.arrayUnion([int.parse(userId)]),
      "updated_at": DateTime.now(),
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
      addChatRoomLogGroupUser(groupId: docId, userId: userId);
    })
    .catchError((e) {
    });
  }

  //Add Group User To Chat Room log 
  static Future<void> addChatRoomLogGroupUser({
    required String groupId,
    required String userId,
  }) async {
    DocumentReference documentReferencer = mainChatRoomLogsCollection.doc(groupId).collection("message-read-logs").doc(userId);
    Map<String, dynamic> data = <String, dynamic>{
      "chat_id" : int.parse(groupId),
      "unix_timestamp" : DateTime.now().toUtc().millisecondsSinceEpoch~/1000,
      "user_id" : int.parse(userId)
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
    })
    .catchError((e) {
    });
  }

  //leave a group
  static Future<void> leaveGroup({
    required String docId,
    required String userId,
    required String userName,
    required int unixTimestamp,
  }) async {
    DocumentReference documentReferencer = mainChatRoomInfoCollection.doc(docId);
    Map<String, dynamic> data = <String, dynamic>{
      "members" : FieldValue.arrayRemove([int.parse(userId)]),
      "updated_at"  : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
      deleteChatRoomLogGroupUser(groupId: docId, userId: userId);
      sendSystemMessage(docId: docId, text: '$userName さんが退会しました。', userName: userName);
    })
    .catchError((e) {
    });
  }

  //Delete group user from chat room log
  static Future<void> deleteChatRoomLogGroupUser({
    required String groupId,
    required String userId,
  }) async {
    DocumentReference documentReferencer = mainChatRoomLogsCollection.doc(groupId).collection("message-read-logs").doc(userId);
    await documentReferencer
    .delete()
    .whenComplete(() {
    })
    .catchError((e) {
    });
  }

  //Send System Message
  static Future<void> sendSystemMessage({
    required String docId,
    required String text,
    required String userName,
  }) async {
    DocumentReference documentReferencer = mainChatRoomsCollection.doc(docId).collection('chat-messages').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "datetime":DateTime.now(),
      "deleted" : false,
      "system_message":true,
      "text"  : text,
      "user_name" : userName,
      "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
      //
    })
    .catchError((e) {
      //
    });
  }

  static Stream<ContactUsInfo>getContactUsInfoList(docId) {
    try{
      return 
        mainContactUsInfoCollection.doc(docId)
        .snapshots()
        .map((contactUsInfo){
          final ContactUsInfo contactUsInfosFromFirestore;
          contactUsInfosFromFirestore = ContactUsInfo.fromDocumentSnapshot(doc:contactUsInfo as DocumentSnapshot<Map<String, dynamic>>);
          return contactUsInfosFromFirestore;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  static Stream<ContactUsInfo>getContactUsInfoMessagePage(docId,nickName,imageUrl) {
    try{
      return 
        mainContactUsInfoCollection.doc(docId)
        .snapshots()
        .map((contactUsInfo){
          if(contactUsInfo.data()==null){
            addMembersInContasUsInfo(userId: docId, nickName: nickName, imageUrl: imageUrl);
          }
          final ContactUsInfo contactUsInfosFromFirestore;
          contactUsInfosFromFirestore = ContactUsInfo.fromDocumentSnapshot(doc:contactUsInfo as DocumentSnapshot<Map<String, dynamic>>);
          return contactUsInfosFromFirestore;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  //Edit Message
  static Future<void> editMessage({
    required String docId,
    required String docId2,
    required String text,
  }) async {
    DocumentReference documentReferencer = mainChatRoomsCollection.doc(docId).collection('chat-messages').doc(docId2);
    Map<String, dynamic> data = <String, dynamic>{
      "text" : text,
      "updated_at"  : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
    })
    .catchError((e) {
    });
  }

  //Edit Message For Inquiry
  static Future<void> editInquiryMessage({
    required String docId,
    required String docId2,
    required String text,
  }) async {
    DocumentReference documentReferencer = mainContactUsCollection.doc(docId).collection('chat-messages').doc(docId2);
    Map<String, dynamic> data = <String, dynamic>{
      "text" : text,
      "updated_at"  : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
    })
    .catchError((e) {
    });
  }

  static Future<void> replyMessage({
    required String docId,
    required int senderId,
    required String senderName,
    required String senderProfileImageUrl,
    required String text,
    required String memberType,
    required String replyTo,
  }) async {
    DocumentReference documentReferencer = mainChatRoomsCollection.doc(docId).collection('chat-messages').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "sender_id"  : senderId,
      "sender_name": senderName,
      "sender_profile_image_url": senderProfileImageUrl,
      "text"  : text,
      "member_type":memberType,
      "system_message":false,
      "reply": replyTo,
      "datetime":DateTime.now(),
      "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000,
      "deleted" : false
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
      //
    })
    .catchError((e) {
      //
    });
  }

  static Future<void> replyInquiryMessage({
    required String docId,
    required int senderId,
    required String senderName,
    required String senderProfileImageUrl,
    required String text,
    required String memberType,
    required String replyTo,
  }) async {
    DocumentReference documentReferencer = mainContactUsCollection.doc(docId).collection('chat-messages').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "sender_id"  : senderId,
      "sender_name": senderName,
      "sender_profile_image_url": senderProfileImageUrl,
      "text"  : text,
      "member_type":memberType,
      "system_message":false,
      "reply": replyTo,
      "datetime":DateTime.now(),
      "deleted" : false,
      "unix_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch~/1000
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
      if(memberType=="host"){
        updateUserUnreadCount(userId: docId, type: 'increment');
      }
      else{
        updateHostUnreadCount(userId: docId, type: 'increment');
      }
    })
    .catchError((e) {
      //
    });
  }

  //Get Reply msg detail with replyId
  static Stream<Message>replyMsgDetail(userId,docId) {
    try{
      return 
        mainChatRoomsCollection.doc(userId).collection('chat-messages').doc(docId)
        .snapshots()
        .map((message){
          final Message messageDetail;
          messageDetail = Message.fromDocumentSnapshot(doc:message);
          return messageDetail;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  //Get Reply msg detail with replyId
  static Stream<Message>replyMsgInquiryDetail(userId,docId) {
    try{
      return 
        mainContactUsCollection.doc(userId).collection('chat-messages').doc(docId)
        .snapshots()
        .map((message){
          final Message messageDetail;
          messageDetail = Message.fromDocumentSnapshot(doc:message);
          return messageDetail;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  static Future<void> editInquiryChatStatus({
    required String docId,
    required int chatStatus,
  }) async {
    DocumentReference documentReferencer = mainContactUsInfoCollection.doc(docId);
    Map<String, dynamic> data = <String, dynamic>{
      "chat_status" : chatStatus,
      "updated_at"  : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
    })
    .catchError((e) {
    });
  }

  static Future<void> uploadProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    DocumentReference documentReferencer = mainUsersCollection.doc(userId);
    Map<String, dynamic> data = <String, dynamic>{
      "profile_image_url" : imageUrl,
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
      updateContactUsCollectionUsersImage(userId: userId, profileImageUrl: imageUrl);
      final box = GetStorage();
      box.write('profileImageUrl', imageUrl);
    })
    .catchError((e) {
    });
  }

  static Future<void> addMembersInContasUsInfo({
    required String userId,
    required String nickName,
    required String imageUrl,
  }) async {
    DocumentReference documentReferencer = mainContactUsInfoCollection.doc(userId);
    Map<String, dynamic> data = <String, dynamic>{
      "bookmark" : true,
      "chat_status" : 3,
      "delete_flg" : false,
      "host_unread_messages" : 0,
      "nickname" : nickName,
      "profile_image_url": imageUrl,
      "status" :true,
      "user_id": int.parse(userId),
      "user_unread_messages":0,
      "created_at" :DateTime.now(),
      "updated_at" :DateTime.now()
    };
    await documentReferencer
    .set(data)
    .whenComplete(() {
      
    })
    .catchError((e) {
    });
  }

  static Future<void> updateHostUnreadCount({
    required String userId,
    required String type,
  }) async {
    DocumentReference documentReferencer = mainContactUsInfoCollection.doc(userId);
    Map<String, dynamic> data;
    if(type == "increment"){
      data = <String, dynamic>{
        "host_unread_messages" : FieldValue.increment(1),
        'chat_status': 1 ,
        "updated_at" : DateTime.now()
      };
    }
    else{
      data = <String, dynamic>{
        "host_unread_messages" : 0,
        "updated_at" : DateTime.now()
      };
    }
    await documentReferencer
    .update(data)
    .whenComplete(() {
      
    })
    .catchError((e) {
    });
  }

  static Future<void> updateUserUnreadCount({
    required String userId,
    required String type,
  }) async {
    DocumentReference documentReferencer = mainContactUsInfoCollection.doc(userId);
    Map<String, dynamic> data;
    if(type == "increment"){
      data = <String, dynamic>{
        "user_unread_messages" : FieldValue.increment(1),
        "updated_at" : DateTime.now()
      };
    }
    else{
      data = <String, dynamic>{
        "user_unread_messages" : 0,
        "updated_at" : DateTime.now()
      };
    }
    await documentReferencer
    .update(data)
    .whenComplete(() {
      
    })
    .catchError((e) {
    });
  }

  static Future<void> updateUsersCollection({
    required String userId,
    required String nickname,
  })async{
    DocumentReference documentReferencer = mainUsersCollection.doc(userId);
    Map<String, dynamic> data;
    data = <String, dynamic>{
      "nickname" : nickname,
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
      
    })
    .catchError((e) {
    });
  }

  static Future<void> updateContactUsCollectionUsers({
    required String userId,
    required String nickname,
  })async{
    DocumentReference documentReferencer = mainContactUsInfoCollection.doc(userId);
    Map<String, dynamic> data;
    data = <String, dynamic>{
      "nickname" : nickname,
      "updated_at" : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
      
    })
    .catchError((e) {
    });
  }

  static Future<void> updateContactUsCollectionUsersImage({
    required String userId,
    required String profileImageUrl,
  })async{
    DocumentReference documentReferencer = mainContactUsInfoCollection.doc(userId);
    Map<String, dynamic> data;
    data = <String, dynamic>{
      "profile_image_url" : profileImageUrl,
      "updated_at" : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
      
    })
    .catchError((e) {
    });
  }

  static Stream<MessageReadLogs> getGroupUserChatRoomlogUnix(groupId,userId) {
    try{
      return 
        mainChatRoomLogsCollection
        .doc(groupId)
        .collection("message-read-logs")
        .doc(userId)
        .snapshots()
        .map((messageReadLog){
          final MessageReadLogs messageReadLogsUserUnix;
          messageReadLogsUserUnix = MessageReadLogs.fromDocumentSnapshot(doc:messageReadLog);
          return messageReadLogsUserUnix;
        }
      );
    }
    catch (e){
      rethrow;
    }
  }

  static Future<void> setLastMessageChatRoomInfo({
    required String groupId,
    required String lastMessage,
  })async{
    DocumentReference documentReferencer = mainChatRoomInfoCollection.doc(groupId);
    Map<String, dynamic> data;
    data = <String, dynamic>{
      "last_message" : lastMessage,
      "updated_at" : DateTime.now()
    };
    await documentReferencer
    .update(data)
    .whenComplete(() {
      
    })
    .catchError((e) {
    });
  }
}