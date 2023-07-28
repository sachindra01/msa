import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/models/chatmodels/chat_room_info.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:msa/widgets/bottom_navigation.dart';
import 'package:msa/widgets/showpremiumalert.dart';
import 'package:msa/widgets/toast_message.dart';

class GroupDetail extends StatefulWidget {
  const GroupDetail({ Key? key ,required this.groupData,required this.alreadyMember}) : super(key: key);
  final dynamic groupData;
  final dynamic alreadyMember;

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  final MessageController _messageCon = Get.put(MessageController());

  @override
  void initState() {
    super.initState();
    _messageCon.getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "グループ",
          style: catTitleStyle,
        ),
        backgroundColor: white,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height:30.0),
            CircleAvatar(
              radius: 54,
              backgroundColor: primaryColor,
              child: CircleAvatar(
                backgroundColor: white,
                backgroundImage: NetworkImage(widget.groupData.imageUrl),
                radius: 50,
              ),
            ),
            const SizedBox(height:20.0),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right:10.0),
              child: Column(
                children: [
                  Text(
                    widget.groupData.title,
                    style: catTitleStyle,
                    textAlign:TextAlign.center
                  ),
                  const SizedBox(height:20.0),
                  Text(
                    widget.groupData.description,
                    style: catTitleStyle,
                    textAlign:TextAlign.center
                  ),
                ],
              ),
            ),
            const SizedBox(height:10.0),
            StreamBuilder<ChatRoomInfo>(
              stream: FirestoreServices.getChatRoomInfoDetail(widget.groupData.id),
              builder:(BuildContext context, AsyncSnapshot chatRoomDetailSnapShot) {
                if (chatRoomDetailSnapShot.hasError || !chatRoomDetailSnapShot.hasData) {
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
                  return Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    color: Colors.transparent,
                    child: ElevatedButton(
                      onPressed: () async{
                        //NOT Premium Group
                        if(widget.groupData.isPremium=="false"){
                          //NOT Already Group Member 
                          //On Click Button Join Group
                          if(widget.alreadyMember=="no"){
                            await _messageCon.addMember(widget.groupData.id).then((value){
                              if(value==true){
                                FirestoreServices.participateInGroup(
                                  docId: widget.groupData.id, 
                                  userId: _messageCon.userId.toString(), 
                                  userName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName
                                );
                                Get.to(() => const BottomNavigation(), arguments: 2);
                              }
                              else{
                                showToastMessage('something went wrong');
                              }  
                            });
                          }
                          //Already Group Member
                          //On Click Button Levae Group
                          else{
                            int unixTimestamp = 0;
                            await _messageCon.leaveGroup(widget.groupData.id).then((value){
                              if(value==true){
                                for (var i = 0; i < chatRoomDetailSnapShot.data.messageReadLogs.length; i++) {
                                  if(chatRoomDetailSnapShot.data.messageReadLogs[i]['user_id'].toString() == _messageCon.userId.toString()){
                                    unixTimestamp = chatRoomDetailSnapShot.data.messageReadLogs[i]['unix_timestamp'];
                                  }
                                }
                                FirestoreServices.leaveGroup(
                                  docId: widget.groupData.id, 
                                  userId: _messageCon.userId.toString(), 
                                  userName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName, 
                                  unixTimestamp: unixTimestamp
                                );
                                Get.to(() => const BottomNavigation(), arguments: 2);
                              }
                              else{
                                showToastMessage('something went wrong');
                              }
                            });
                          }
                        }
                        //Premium Group
                        else if(widget.groupData.isPremium=="true"){
                          //if user is member and not premium show alert 
                          if(_messageCon.memberType=="member" && _messageCon.isPremium=='false'){
                            showPremiumAlert(context);
                          }
                          //if user is host and already joined or not
                          else{
                            if(widget.alreadyMember=="no"){
                              await _messageCon.addMember(widget.groupData.id).then((value){
                                if(value==true){
                                  FirestoreServices.participateInGroup(
                                    docId: widget.groupData.id, 
                                    userId: _messageCon.userId.toString(), 
                                    userName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName
                                  );
                                  Get.to(() => const BottomNavigation(), arguments: 2,transition: Transition.rightToLeftWithFade);
                                }
                                else{
                                  showToastMessage('something went wrong');
                                }
                              });
                            }
                            else{
                              int unixTimestamp = 0;
                              await _messageCon.leaveGroup(widget.groupData.id).then((value){
                                if(value==true){
                                  for (var i = 0; i < widget.groupData.messageReadLogs.length; i++) {
                                    if(widget.groupData.messageReadLogs[i]['user_id'] == _messageCon.userId){
                                      unixTimestamp = widget.groupData.messageReadLogs[i]['unix_timestamp'];
                                    }
                                  }
                                  FirestoreServices.leaveGroup(
                                    docId: widget.groupData.id, 
                                    userId: _messageCon.userId.toString(), 
                                    userName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName,
                                    unixTimestamp: unixTimestamp
                                  );
                                  Get.to(() => const BottomNavigation(), arguments: 2);
                                }
                                else{
                                  showToastMessage('something went wrong');
                                }
                              });
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: black),
                      child: Text(
                        widget.alreadyMember=="no"?"参加する":"退室する",
                        style: buttonBoldTextStyle,
                      ),
                    ),
                  );
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}