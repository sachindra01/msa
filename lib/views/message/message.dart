import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/controller/statuslist_controller.dart';
import 'package:msa/models/chatmodels/chat_room_info.dart';
import 'package:msa/models/chatmodels/contact_us_info.dart';
import 'package:msa/models/chatmodels/message_model.dart';
import 'package:msa/models/chatmodels/message_read_logs.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:msa/common/constants.dart' as constants;
// import 'package:msa/views/message/activity_diarybox.dart';
import 'package:msa/views/message/add_group.dart';
import 'package:msa/views/message/chat_page.dart';
import 'package:msa/views/message/contact_us.dart';
import 'package:msa/views/message/inquiry.dart';
import 'package:msa/widgets/loading_widget.dart';

class MessagePage extends StatefulWidget {
  static const routeName = '/message';
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final MessageController _messageCon = Get.put(MessageController());
  final ScrollController scrollController = ScrollController();
  final _statusListCon = Get.put(StatusListController());
  int badgeCount = 0;

  @override
  void initState() {
    super.initState();
    _messageCon.getPref();
    _statusListCon.getStatusList();
  }

  @override
  Widget build(BuildContext context) {
    var memberType = GetStorage().read('memberType');
    return GetBuilder(
      init: StatusListController(),
      builder: (_) {
        return Obx(
          ()=> _statusListCon.isLoading.value == true
          ? Center(child: loadingWidget())
          : Scaffold(
            body: Container(
              //Main Padding 
              margin: const EdgeInsets.only(left:16.0,right: 16.0,top:10.0),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //When member is a HOST
                  //Inquiry and Activity Diary Inbox
                  memberType == 'host'
                  ?SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            child: const Text(
                              'お問い合わせ',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Get.to(()=> const ChatInquiry(),
                              transition: Transition.rightToLeft);
                            // Navigator.pushNamed(context, '/chat/inquiry');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFeb5757)
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.018,
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.07,
                        //   width: MediaQuery.of(context).size.width * 0.7,
                        //   child: ElevatedButton(
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         const Text(
                        //           ' 活動日誌受信BOX ',
                        //           style: TextStyle(color: Colors.white),
                        //         ),
                        //         Padding(
                        //             padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1),
                        //             child: CircleAvatar(
                        //               backgroundColor: red,
                        //               foregroundColor: white,
                        //               radius: 10,
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(2),
                        //                 child: Text(
                        //                   _statusListCon.statuslist.all.count>=100?'99+':_statusListCon.statuslist.all.count.toString(),
                        //                   style: badgeCounterTextStyle,
                        //                 ),
                        //               ),
                        //             ),
                        //         ),
                        //       ],
                        //     ),
                        //     onPressed: () {
                        //       Get.to(()=> const ActivityDiaryBox(),
                        //       transition: Transition.rightToLeftWithFade);
                        //     },
                        //     style: ElevatedButton.styleFrom(primary: const Color(0xFF5e81f4)),
                        //   ),
                        // ),
                        // const SizedBox(height: 20.0)
                      ],
                    ),
                  )
                  :const SizedBox(),
                  //CONSULT WITH TEACHER
                  //if member show Consult with Teacher
                  memberType=='member'
                  ?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //padding for text header only
                      const Padding(
                        padding: EdgeInsets.only(top:0.0,bottom:20.0),
                        child: Text(
                          'お問い合わせ',
                          style: catTitleStyle,
                        ),
                      ),
                      StreamBuilder<ContactUsInfo>(
                        stream: FirestoreServices.getContactUsInfoMessagePage(_messageCon.userId.toString(),_messageCon.nickName,_messageCon.profileImageUrl),
                        builder:(BuildContext context, AsyncSnapshot contactUsInfoSnapshot) {
                          if (contactUsInfoSnapshot.hasError || !contactUsInfoSnapshot.hasData) {
                            return const SizedBox(height: 40);
                          } 
                          else{
                            return InkWell(
                              onTap: () {
                                if(contactUsInfoSnapshot.data!=null){
                                  if(contactUsInfoSnapshot.data.userUnreadMessage!="0"){
                                    FirestoreServices.updateUserUnreadCount(type: 'decrement', userId: _messageCon.userId.toString());
                                  }
                                }
                                Get.to(()=> const ContactUs(),
                                  transition: Transition.rightToLeft
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:4.0),
                                        child: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          radius: 26,
                                          child: CircleAvatar(
                                            backgroundColor: primaryColor,
                                            child: Image.asset("assets/images/ic_logo.png"),
                                            radius: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: const [
                                            Text(
                                              '先生と相談',
                                              style: grouptitleStyle,
                                            ),
                                            Text(
                                              'お気軽にご相談してください。',
                                              style: groupSubTitleStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //chat badge
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      contactUsInfoSnapshot.data.userUnreadMessage=="0"
                                      ?const SizedBox()
                                      :CircleAvatar(
                                        backgroundColor: red,
                                        foregroundColor: white,
                                        radius: 10,
                                        child: Padding(
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                            int.parse(contactUsInfoSnapshot.data.userUnreadMessage)>=100?'99+':contactUsInfoSnapshot.data.userUnreadMessage.toString(),
                                            style: badgeCounterTextStyle,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        }
                      )
                    ],
                  )
                  :const SizedBox(),
                  //ADD GROUPS
                  //Groups and Add Group button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //padding for text header only
                      const Padding(
                        padding: EdgeInsets.only(top:20.0,bottom:20.0),
                        child: Text(
                          'グループチャット',
                          style: catTitleStyle,
                        ),
                      ),
                      CircleAvatar(
                        radius: 11.0,
                        backgroundColor: black,
                        child: CircleAvatar(
                          backgroundColor: white,
                          radius: 10.0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.add,
                              size: 16,
                              color: black,
                            ),
                            onPressed: () {
                              Get.to(()=> const AddGroup(),
                              transition: Transition.rightToLeft);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //GROUP CHAT
                  //Groups list from chat room info with me as a member
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['chatRoomInfo'])
                      .where("delete_flg",isEqualTo: false)
                      .where("status",isEqualTo: true)
                      .where("members",arrayContainsAny: [_messageCon.userId])
                      .snapshots(),
                      builder:(BuildContext context, AsyncSnapshot chatRoomsSnapShot) {
                        if (chatRoomsSnapShot.hasError || !chatRoomsSnapShot.hasData) {
                          return Center(
                            child: Column(
                              children: const[
                                SizedBox(height: 130),
                                CircularProgressIndicator(color: primaryColor),
                              ],
                            )
                          );
                        }
                        else{
                          return ListView.builder(
                            padding: const EdgeInsets.only(left:4.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: chatRoomsSnapShot.data.docs.length,
                            controller: scrollController,
                            itemBuilder: (BuildContext context, int index){
                              return Padding(
                                padding: const EdgeInsets.only(bottom:14.0),
                                child: InkWell(
                                  onTap: () async{
                                    setState(() {
                                      _messageCon.tappedGroup=true;
                                    });
                                    Get.to(()=>  ChatPage(
                                      data: ChatRoomInfo.fromDocumentSnapshot(
                                          doc: chatRoomsSnapShot.data.docs[index]
                                        ), 
                                      ),
                                      transition: Transition.rightToLeft
                                    );
                                  },
                                  child: StreamBuilder<List<Message>>(
                                    stream: FirestoreServices.getChatMessagesByUnix(chatRoomsSnapShot.data.docs[index]["id"].toString()),
                                    builder:(BuildContext context, AsyncSnapshot messageSnapshot) {
                                      if (messageSnapshot.hasError || !messageSnapshot.hasData) {
                                        return const SizedBox();
                                      } 
                                      else{
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: primaryColor,
                                                  radius: 26,
                                                  child: CircleAvatar(
                                                    backgroundColor: white,
                                                    backgroundImage: NetworkImage(chatRoomsSnapShot.data.docs[index]["image_url"]),
                                                    radius: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 16.0),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width*0.6,
                                                      child: Text(
                                                        chatRoomsSnapShot.data.docs[index]["title"],
                                                        style: grouptitleStyle,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    //Get last message
                                                    StreamBuilder<ChatRoomInfo>(
                                                    stream:FirestoreServices.getChatRoomInfoDetail(chatRoomsSnapShot.data.docs[index]["id"].toString()),
                                                    builder:(BuildContext context, AsyncSnapshot chatRoomInfoSnapShot) {
                                                      if (chatRoomInfoSnapShot.hasError || !chatRoomInfoSnapShot.hasData) {
                                                        return const SizedBox();
                                                      } 
                                                      else{
                                                        return Container(
                                                          width: MediaQuery.of(context).size.width*0.6,
                                                          padding: const EdgeInsets.only(top:6.0),
                                                          alignment: Alignment.centerLeft,
                                                          child: chatRoomInfoSnapShot.data.lastMessage != null
                                                          ?Text(
                                                            chatRoomInfoSnapShot.data.lastMessage,
                                                            maxLines: 1,
                                                            softWrap: false,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: groupSubTitleStyle,
                                                          )
                                                          :const SizedBox()
                                                        );
                                                      }
                                                    }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            //for Group Chat badge count
                                            StreamBuilder<MessageReadLogs>(
                                              stream: FirestoreServices.getGroupUserChatRoomlogUnix(
                                                chatRoomsSnapShot.data.docs[index]["id"].toString(),
                                                _messageCon.userId.toString()
                                              ),
                                              builder:(BuildContext context, AsyncSnapshot userUnixLogSnapshot) {
                                                if (userUnixLogSnapshot.hasError || !userUnixLogSnapshot.hasData) {
                                                  return const SizedBox();
                                                }
                                                else{
                                                  badgeCount = 0;
                                                  var totalMessages = messageSnapshot.data;
                                                  var totalMessagesLength = messageSnapshot.data.length;
                                                  var newTotalMessage =[];
                                                  var newTotalMessageLength =0;
                                                  for (var i = 0; i < totalMessagesLength;i++) {
                                                    //remove all system messages first
                                                    if(totalMessages[i].systemMessage=="false"){
                                                      newTotalMessage.add(totalMessages[i]);
                                                    }
                                                    newTotalMessageLength = newTotalMessage.length;
                                                  }
                                                  for (var j = 0; j < newTotalMessageLength; j++) {
                                                    if(int.parse(newTotalMessage[j].unixTimestamp)>userUnixLogSnapshot.data.unixTimeStamp){
                                                      if(newTotalMessage[j].systemMessage=="false"){
                                                        badgeCount = (newTotalMessageLength - j);
                                                        break;
                                                      }
                                                    }
                                                  }
                                                  return badgeCount!=0 && _messageCon.tappedGroup==false
                                                  ? 
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 0),
                                                    child: CircleAvatar(
                                                      backgroundColor: red,
                                                      foregroundColor: white,
                                                      radius: 10,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(0),
                                                        child: Text(
                                                          badgeCount>=100?'99+':badgeCount.toString(),
                                                          style: badgeCounterTextStyle,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  :const SizedBox();
                                                }
                                              }
                                            )
                                          ],
                                        );
                                      }
                                    }
                                  )
                                ),
                              );
                            },
                          );
                        } 
                      }
                    ),
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}
