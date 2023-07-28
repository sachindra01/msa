import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rich_text_view/rich_text_view.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({ Key? key ,required this.forPage,this.data,this.chatRommInfoDetailSnapShot,this.messageList}) : super(key: key);
  final dynamic data;
  final dynamic chatRommInfoDetailSnapShot;
  final String forPage;
  final dynamic messageList;
  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final MessageController _messageCon = Get.put(MessageController());
  int unixTimestamp = 0;
  List mentionSearch = []; 
  @override
  Widget build(BuildContext context) {
    return widget.forPage=='single'
    ?SafeArea(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: white,
            // boxShadow: kElevationToShadow[4],
          ),
          padding: EdgeInsets.zero,
          child: Obx(()=>
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _messageCon.multiImagePicked.value== true
                ?LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 12.0,
                  backgroundColor : const Color(0xFFB8C7CB),
                  animation: false,
                  percent: _messageCon.progress.value,
                  center:Text(
                    _messageCon.completedUploadImages.value.toString(),
                    style: imageUploadCounterTextStyle
                  ),
                  progressColor: buttonPrimaryColor,
                )
                :const SizedBox(),
                Padding(
                  padding: EdgeInsets.only(
                    top: _messageCon.multiImagePicked.value== true
                    ? 0.0
                    : 10.0,
                    bottom: _messageCon.multiImagePicked.value== true?5.0:10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _messageCon.multiImagePicked.value== true
                      ?const SizedBox()
                      :IconButton(
                        constraints: const BoxConstraints(),
                        onPressed: (){
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 50),
                                        const Text('共有',style: chatAddMediaTextHeaderStyle),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          onPressed: (){
                                            Get.back();
                                          }, 
                                          icon: const Icon(Icons.close,color: darkGrey)
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                      leading: const Icon(Icons.photo_library_outlined,color:darkGrey),
                                      title: const Text('メディア',style: chatAddMediaTextHeaderStyle),
                                      subtitle: const Text('写真やビデオを共有',style: chatAddMediaTextSubTitleStyle),
                                      horizontalTitleGap: 0,
                                      minVerticalPadding:0.0,
                                      dense: true,
                                      onTap: (){
                                        setState(() {
                                          _messageCon.imageFile=null;
                                          _messageCon.imagePicked.value = false;
                                        });
                                        _messageCon.pickMultiImage().then((value) {
                                          _messageCon.sendImageMessage(widget.data.userId.toString(),0,'contactUs');
                                          Get.back();
                                        });
                                      },
                                    ),
                                    const Divider(height: 0.5),
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                      leading: const Icon(Icons.camera_alt_outlined,color:darkGrey),
                                      title: const Text('カメラ',style: chatAddMediaTextHeaderStyle),
                                      subtitle: const Text('撮影して共有',style: chatAddMediaTextSubTitleStyle),
                                      dense: true,
                                      horizontalTitleGap: 0,
                                      minVerticalPadding:0.0,
                                      onTap: (){
                                        setState(() {
                                          _messageCon.imageFile=null;
                                          _messageCon.imagePicked.value = false;
                                        });
                                        _messageCon.pickImageCamera().then((value) {
                                          _messageCon.sendImageMessage(widget.data.userId.toString(),0,'contactUs');
                                          Get.back();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }, 
                        icon: const Icon(
                          Icons.add_circle_sharp,
                          color: grey,
                        ),
                      ),
                      _messageCon.multiImagePicked.value== true
                      ?SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          itemCount: _messageCon.multiImagefiles.length,
                          scrollDirection : Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top:4.0,
                                bottom: 4.0, 
                                left: index==0 ?8.0:0.0, 
                                right: index==_messageCon.multiImagefiles.length-1 ?8.0:0.0
                              ),
                              child: Stack(
                                fit: StackFit.passthrough,
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_messageCon.multiImagefiles[index].path),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  _messageCon.imageUploading==false
                                  ?Positioned(
                                    top: -4,
                                    right: -4,
                                    child: GestureDetector(
                                      onTap:(){
                                        if(_messageCon.imageUploading==false){
                                          if(_messageCon.multiImagefiles.length==1){
                                            setState(() {
                                              _messageCon.multiImagefiles = [];
                                              _messageCon.multiImagePicked.value = false;
                                            });
                                          }
                                          else{
                                            setState(() {
                                              _messageCon.multiImagefiles.removeAt(index);
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 12,
                                        )
                                      ),
                                    ),
                                  )
                                  :const SizedBox(),
                                ],
                              ),
                            );
                          }, 
                          separatorBuilder: (BuildContext context, int index) 
                          {  
                            return const SizedBox(width: 10.0);
                          },
                        ),
                      )
                      //Chat Box
                      :GetBuilder(
                        init: MessageController(),
                        builder: (_){
                          return
                          _messageCon.imageFile==null || _messageCon.imageUploading == true
                          ?Flexible(
                            child: SizedBox(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: double.infinity),
                                child: TextFormField(
                                  controller: _messageCon.inquiryChatTextCon,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  minLines: 1,
                                  style: chatBoxTextStyle,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 10,right: 5,top: 10,bottom:10),
                                    filled: true,
                                    fillColor: whiteGrey,
                                    hintText: 'メッセージを入力',
                                    isDense: true,
                                    hintStyle: chatBoxHintStyle,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: transparent,
                                        width: 1.0
                                      )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: transparent,
                                        width: 1.0
                                      )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: transparent,
                                        width: 1.0
                                      )
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                  ),
                                  onTap: () async {
                                    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                                    if(data?.text!=null || data?.text!=''){
                                      if (kDebugMode) {
                                        print(data?.text);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                          :Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: (){
                                    setState(() {
                                      _messageCon.imageFile=null;
                                      _messageCon.imagePicked.value = false;
                                    });
                                  }, 
                                  child: const Text("Cancel"),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      //Send Button
                      _messageCon.multiImagePicked.value == false
                      ?Container(
                        transform: Matrix4.translationValues(0.0, -4.0, 0.0),
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.send,
                            color: primaryColor,
                            size: 34.0,
                          ),
                          onPressed: () async {
                            //Reply Msg
                            if(_messageCon.replyMsg.value==true && _messageCon.inquiryChatTextCon.text.trim()!='' && _messageCon.editId =='' && _messageCon.imageFile==null){
                              FirestoreServices.replyInquiryMessage(
                                docId: widget.data.userId.toString(), 
                                text: _messageCon.inquiryChatTextCon.text.trim(),
                                memberType: _messageCon.memberType, 
                                replyTo: _messageCon.replyData.id, 
                                senderId: _messageCon.userId, 
                                senderName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName, 
                                senderProfileImageUrl: _messageCon.profileImageUrl,
                              );
                              setState(() {
                                _messageCon.replyMsg.value = false;
                                _messageCon.inquiryChatTextCon.text = '';
                                _messageCon.replyData = '';
                              });
                              _messageCon.scrollToBottomInit();
                              _messageCon.hideFloationButton();
                            }
                            //Send Message
                            if(_messageCon.inquiryChatTextCon.text.trim()!='' && _messageCon.editId==''){
                              //send message
                              FirestoreServices.sendMessageInquiry(
                                docId: widget.data.userId.toString(),
                                senderId: _messageCon.userId, 
                                senderName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName, 
                                senderProfileImageUrl: _messageCon.profileImageUrl, 
                                text: _messageCon.inquiryChatTextCon.text.trim(), 
                                memberType: _messageCon.memberType,
                              );
                              setState(() {
                                _messageCon.inquiryChatTextCon.text='';
                              });
                              _messageCon.scrollToBottomInit();
                              _messageCon.hideFloationButton();
                            }
                            //Edit/update message
                            if(_messageCon.editId!='' && _messageCon.inquiryChatTextCon.text.trim()!=''){
                              FirestoreServices.editInquiryMessage(
                                docId: widget.data.userId.toString(), 
                                docId2: _messageCon.editId, 
                                text: _messageCon.inquiryChatTextCon.text.trim()
                              );
                              setState(() {
                                _messageCon.editId = '';
                                _messageCon.inquiryChatTextCon.text = '';
                              });
                            }
                          },
                        ),
                      )
                      :const SizedBox(),
                    ],
                  ),
                ),
              ],
            )
          )
        ),
      ),
    )
    :widget.forPage=='teacher'
    ?SafeArea(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: white,
            // boxShadow: kElevationToShadow[4],
          ),
          padding: EdgeInsets.zero,
          child: Obx(()=> 
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _messageCon.multiImagePicked.value== true
                ?LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 12.0,
                  backgroundColor : const Color(0xFFB8C7CB),
                  animation: false,
                  percent: _messageCon.progress.value,
                  center:Text(
                    _messageCon.completedUploadImages.value.toString(),
                    style: imageUploadCounterTextStyle
                  ),
                  progressColor: buttonPrimaryColor,
                )
                :const SizedBox(),
                Padding(
                  padding: EdgeInsets.only(
                    top: _messageCon.multiImagePicked.value== true
                    ? 0.0
                    : 10.0,
                    bottom: _messageCon.multiImagePicked.value== true?5.0:10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _messageCon.multiImagePicked.value== true
                      ?const SizedBox()
                      :IconButton( 
                        constraints: const BoxConstraints(),
                        onPressed: (){
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 50),
                                        const Text('共有',style: chatAddMediaTextHeaderStyle),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          onPressed: (){
                                            Get.back();
                                          }, 
                                          icon: const Icon(Icons.close,color: darkGrey)
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                      leading: const Icon(Icons.photo_library_outlined,color:darkGrey),
                                      title: const Text('メディア',style: chatAddMediaTextHeaderStyle),
                                      subtitle: const Text('写真やビデオを共有',style: chatAddMediaTextSubTitleStyle),
                                      horizontalTitleGap: 0,
                                      minVerticalPadding:0.0,
                                      dense: true,
                                      onTap: (){
                                        setState(() {
                                          _messageCon.imageFile=null;
                                          _messageCon.imagePicked.value = false;
                                        });
                                        _messageCon.pickMultiImage().then((value) {
                                          _messageCon.sendImageMessage(_messageCon.userId.toString(),0,'contactUs');
                                          Get.back();
                                        });
                                      },
                                    ),
                                    const Divider(height: 0.5),
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                      leading: const Icon(Icons.camera_alt_outlined,color:darkGrey),
                                      title: const Text('カメラ',style: chatAddMediaTextHeaderStyle),
                                      subtitle: const Text('撮影して共有',style: chatAddMediaTextSubTitleStyle),
                                      dense: true,
                                      horizontalTitleGap: 0,
                                      minVerticalPadding:0.0,
                                      onTap: (){
                                        setState(() {
                                          _messageCon.imageFile=null;
                                          _messageCon.imagePicked.value = false;
                                        });
                                        _messageCon.pickImageCamera().then((value) {
                                          _messageCon.sendImageMessage(_messageCon.userId.toString(),0,'contactUs');
                                          Get.back();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }, 
                        icon: const Icon(
                          Icons.add_circle_sharp,
                          color: grey,
                        ),
                      ),
                      _messageCon.multiImagePicked.value== true
                      ?SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          itemCount: _messageCon.multiImagefiles.length,
                          scrollDirection : Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top:4.0,
                                bottom: 4.0, 
                                left: index==0 ?8.0:0.0, 
                                right: index==_messageCon.multiImagefiles.length-1 ?8.0:0.0
                              ),
                              child: Stack(
                                fit: StackFit.passthrough,
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_messageCon.multiImagefiles[index].path),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  _messageCon.imageUploading==false
                                  ?Positioned(
                                    top: -4,
                                    right: -4,
                                    child: GestureDetector(
                                      onTap:(){
                                        if(_messageCon.imageUploading==false){
                                          if(_messageCon.multiImagefiles.length==1){
                                            setState(() {
                                              _messageCon.multiImagefiles = [];
                                              _messageCon.multiImagePicked.value = false;
                                            });
                                          }
                                          else{
                                            setState(() {
                                              _messageCon.multiImagefiles.removeAt(index);
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 12,
                                        )
                                      ),
                                    ),
                                  )
                                  :const SizedBox(),
                                ],
                              ),
                            );
                          }, 
                          separatorBuilder: (BuildContext context, int index) 
                          {  
                            return const SizedBox(width: 10.0);
                          },
                        ),
                      )
                      :GetBuilder(
                        init: MessageController(),
                        builder: (_){
                          return
                          _messageCon.imageFile==null || _messageCon.imageUploading == true
                          ?Flexible(
                            child: SizedBox(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: double.infinity),
                                child: TextFormField(
                                  controller: _messageCon.chatTextCon,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  minLines: 1,
                                  style: chatBoxTextStyle,
                                  textAlign : TextAlign.start,
                                  onTap: () async {
                                    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                                    if(data?.text!=null || data?.text!=''){
                                      if (kDebugMode) {
                                        print(data?.text);
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 10,right: 5,top: 10,bottom:10),
                                    filled: true,
                                    fillColor: whiteGrey,
                                    hintText: 'メッセージを入力',
                                    hintStyle: chatBoxHintStyle,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: transparent,
                                        width: 1.0
                                      )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: transparent,
                                        width: 1.0
                                      )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: transparent,
                                        width: 1.0
                                      )
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                  ),
                                ),
                              ),
                            ),
                          )
                          :Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: (){
                                    setState(() {
                                      _messageCon.imageFile=null;
                                      _messageCon.imagePicked.value = false;
                                    });
                                  }, 
                                  child: const Text("Cancel"),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      //Send Button
                      _messageCon.multiImagePicked.value == false
                      ?Container(
                        transform: Matrix4.translationValues(0.0, -4.0, 0.0),
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          //padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.send,
                            color: primaryColor,
                            size: 34.0,
                          ),
                          onPressed: () async{
                            //Reply Msg
                            if(_messageCon.replyMsg.value==true && _messageCon.chatTextCon.text.trim()!='' && _messageCon.editId =='' && _messageCon.imageFile==null){
                              FirestoreServices.replyInquiryMessage(
                                docId: _messageCon.userId.toString(), 
                                text: _messageCon.chatTextCon.text.trim(),
                                memberType: _messageCon.memberType, 
                                replyTo: _messageCon.replyData.id, 
                                senderId: _messageCon.userId, 
                                senderName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName,
                                senderProfileImageUrl: _messageCon.profileImageUrl,
                              );
                              setState(() {
                                _messageCon.replyMsg.value = false;
                                _messageCon.chatTextCon.text = '';
                                _messageCon.replyData = '';
                              });
                              _messageCon.scrollToBottomInit();
                              _messageCon.hideFloationButton();
                            }
                            //Send Message
                            if(_messageCon.chatTextCon.text.trim()!='' && _messageCon.editId==''){
                              //send message
                              FirestoreServices.sendMessageInquiry(
                                docId: _messageCon.userId.toString(),
                                senderId: _messageCon.userId, 
                                senderName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName, 
                                senderProfileImageUrl: _messageCon.profileImageUrl, 
                                text: _messageCon.chatTextCon.text.trim(), 
                                memberType: _messageCon.memberType,
                              );
                              setState(() {
                                _messageCon.chatTextCon.text='';
                              });
                              _messageCon.scrollToBottomInit();
                              _messageCon.hideFloationButton();
                            }
                            //Edit/update message
                            if(_messageCon.editId!='' && _messageCon.chatTextCon.text.trim()!=''){
                              FirestoreServices.editInquiryMessage(
                                docId: _messageCon.userId.toString(), 
                                docId2: _messageCon.editId, 
                                text: _messageCon.chatTextCon.text.trim()
                              );
                              setState(() {
                                _messageCon.editId = '';
                                _messageCon.chatTextCon.text = '';
                              });
                            }
                          },
                        ),
                      )
                      :const SizedBox(),
                    ],
                  ),
                ),
              ],
            )
          )
        ),
      ),
    )
    :widget.forPage=='group'
    ?SafeArea(
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          color: white,
          // boxShadow: kElevationToShadow[4],
        ),
        padding: EdgeInsets.zero,
        child: Obx(()=>
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _messageCon.multiImagePicked.value== true
              ?LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 12.0,
                backgroundColor : const Color(0xFFB8C7CB),
                animation: false,
                percent: _messageCon.progress.value,
                center:Text(
                  _messageCon.completedUploadImages.value.toString(),
                  style: imageUploadCounterTextStyle
                ),
                progressColor: buttonPrimaryColor,
              )
              :const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 0.0,
                  bottom: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _messageCon.multiImagePicked.value== true
                    ?const SizedBox()
                    :Container(
                      transform: Matrix4.translationValues(0.0, -4, 0.0),
                      child: IconButton(  
                        constraints: const BoxConstraints(),
                        onPressed: (){
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 50),
                                        const Text('共有',style: chatAddMediaTextHeaderStyle),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          onPressed: (){
                                            Get.back();
                                          }, 
                                          icon: const Icon(Icons.close,color: darkGrey)
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                      leading: const Icon(Icons.photo_library_outlined,color:darkGrey),
                                      title: const Text('メディア',style: chatAddMediaTextHeaderStyle),
                                      subtitle: const Text('写真やビデオを共有',style: chatAddMediaTextSubTitleStyle),
                                      horizontalTitleGap: 0,
                                      minVerticalPadding:0.0,
                                      dense: true,
                                      onTap: (){
                                        setState(() {
                                          _messageCon.imageFile=null;
                                          _messageCon.imagePicked.value = false;
                                        });
                                        _messageCon.pickMultiImage().then((value){
                                          for (var i = 0; i < widget.chatRommInfoDetailSnapShot.data.messageReadLogs.length; i++) {
                                            if(widget.chatRommInfoDetailSnapShot.data.messageReadLogs[i]['user_id'] == _messageCon.userId.toString()){
                                              unixTimestamp = widget.chatRommInfoDetailSnapShot.data.messageReadLogs[i]['unix_timestamp'];
                                            }
                                          }
                                          _messageCon.sendImageMessage(widget.data.id,unixTimestamp,'chat');
                                          Get.back();
                                        });
                                      },
                                    ),
                                    const Divider(height: 0.5),
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                      leading: const Icon(Icons.camera_alt_outlined,color:darkGrey),
                                      title: const Text('カメラ',style: chatAddMediaTextHeaderStyle),
                                      subtitle: const Text('撮影して共有',style: chatAddMediaTextSubTitleStyle),
                                      dense: true,
                                      horizontalTitleGap: 0,
                                      minVerticalPadding:0.0,
                                      onTap: (){
                                        setState(() {
                                          _messageCon.multiImagefiles=[];
                                          _messageCon.multiImagePicked.value = false;
                                        });
                                        _messageCon.pickImageCamera().then((value){
                                          for (var i = 0; i < widget.chatRommInfoDetailSnapShot.data.messageReadLogs.length; i++) {
                                            if(widget.chatRommInfoDetailSnapShot.data.messageReadLogs[i]['user_id'] == _messageCon.userId.toString()){
                                              unixTimestamp = widget.chatRommInfoDetailSnapShot.data.messageReadLogs[i]['unix_timestamp'];
                                            }
                                          }
                                          _messageCon.sendImageMessage(widget.data.id,unixTimestamp,'chat');
                                          Get.back();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }, 
                        icon: const Icon(
                          Icons.add_circle_sharp,
                          color: grey,
                        ),
                      ),
                    ),
                    _messageCon.multiImagePicked.value== true
                    ?SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                        itemCount: _messageCon.multiImagefiles.length,
                        scrollDirection : Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top:4.0,
                              bottom: 4.0, 
                              left: index==0 ?8.0:0.0, 
                              right: index==_messageCon.multiImagefiles.length-1 ?8.0:0.0
                            ),
                            child: Stack(
                              fit: StackFit.passthrough,
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_messageCon.multiImagefiles[index].path),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                _messageCon.imageUploading==false
                                ?Positioned(
                                  top: -4,
                                  right: -4,
                                  child: GestureDetector(
                                    onTap:(){
                                      if(_messageCon.imageUploading==false){
                                        if(_messageCon.multiImagefiles.length==1){
                                          setState(() {
                                            _messageCon.multiImagefiles = [];
                                            _messageCon.multiImagePicked.value = false;
                                          });
                                        }
                                        else{
                                          setState(() {
                                            _messageCon.multiImagefiles.removeAt(index);
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 12,
                                      )
                                    ),
                                  ),
                                )
                                :const SizedBox(),
                              ],
                            ),
                          );
                        }, 
                        separatorBuilder: (BuildContext context, int index) 
                        {  
                          return const SizedBox(width: 10.0);
                        },
                      ),
                    )
                    //Chat Box
                    :Flexible(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          backgroundColor: Colors.transparent,
                          brightness: Brightness.dark,
                          canvasColor: Colors.transparent,
                          visualDensity : VisualDensity.adaptivePlatformDensity
                        ),
                        child: Container(
                          transform: Matrix4.translationValues(0.0, -5, 0.0),
                          child: RichTextEditor(
                            key: _messageCon.key,
                            itemHeight: 60,
                            keyboardType: TextInputType.multiline,
                            maxLines  : 4,
                            minLines  : 1,
                            style: chatBoxTextStyle,
                            controller: _messageCon.chatTextCon,
                            suggestionPosition: SuggestionPosition.top,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10,right: 5,top: 10,bottom:10),
                              constraints:const BoxConstraints(),
                              filled: true,
                              fillColor: whiteGrey,
                              hintText: 'メッセージを入力',
                              hintStyle: chatBoxHintStyle,
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: transparent,
                                  width: 1.0
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: transparent,
                                  width: 1.0
                                )
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: transparent,
                                  width: 1.0
                                )
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )
                            ),
                            mentionSuggestions: List<Mention>.generate(
                              _messageCon.mentionNames.length,
                              (i){
                                return Mention(
                                  imageURL: _messageCon.mentionNames[i]['imageUrl'], 
                                  subtitle: '', 
                                  title: _messageCon.mentionNames[i]['title']
                                );
                              }
                            ),
                            onSearchMention: (term) async {
                              mentionSearch.clear();
                              for (var i = 0; i < _messageCon.mentionNames.length; i++) {
                                if(_messageCon.mentionNames[i]['title'].contains(term)){
                                  mentionSearch.add(_messageCon.mentionNames[i]);
                                }
                              }
                              return List.generate(
                                mentionSearch.length,
                                (index) => Mention(
                                  imageURL: mentionSearch[index]['imageUrl'],
                                  subtitle: '',
                                  title: mentionSearch[index]['title']
                                )
                              );
                            },
                            onMentionSelected: (suggestion) {
                              _messageCon.chatTextCon.text=_messageCon.chatTextCon.text.trim()+suggestion.title+' ';
                              _messageCon.chatTextCon.selection = TextSelection.fromPosition(TextPosition(offset: _messageCon.chatTextCon.text.length));
                            },
                            mentionSearchCard:(value){
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    value.title,
                                    style: mentionTextStyle,
                                  ),
                                  leading : CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(value.imageURL),
                                    backgroundColor: primaryColor,
                                  ),
                                )
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                    //Send Button
                    _messageCon.multiImagePicked.value == false
                    ?Container(
                      transform: Matrix4.translationValues(0.0, -8, 0.0),
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.send,
                          color: primaryColor,
                          size: 34.0,
                        ),
                        onPressed: () async{
                          for (var i = 0; i < widget.chatRommInfoDetailSnapShot.data.messageReadLogs.length; i++) {
                            if(widget.chatRommInfoDetailSnapShot.data.messageReadLogs[i]['user_id'] == _messageCon.userId.toString()){
                              unixTimestamp = widget.chatRommInfoDetailSnapShot.data.messageReadLogs[i]['unix_timestamp'];
                            }
                          }
                          //reply Msg
                          if(_messageCon.replyMsg.value==true && _messageCon.chatTextCon.text.trim()!='' && _messageCon.editId =='' && _messageCon.imageFile==null){
                            FirestoreServices.replyMessage(
                              docId: widget.data.id.toString(), 
                              text: _messageCon.chatTextCon.text.trim(),
                              memberType: _messageCon.memberType, 
                              replyTo: _messageCon.replyData.id, 
                              senderId: _messageCon.userId, 
                              senderName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName,
                              senderProfileImageUrl: _messageCon.profileImageUrl,
                            );
                            FirestoreServices.setLastMessageChatRoomInfo(
                              groupId: widget.data.id, 
                              lastMessage: _messageCon.chatTextCon.text.trim()
                            );
                            setState(() {
                              _messageCon.replyMsg.value = false;
                              _messageCon.chatTextCon.text = '';
                              if(_messageCon.key.currentState!=null){
                                _messageCon.key.currentState!.controller!.text = '';
                              }
                            });
                            _messageCon.scrollToBottomInit();
                            _messageCon.hideFloationButton();
                          }
                          //Send Message
                          else if(_messageCon.chatTextCon.text.trim()!='' && _messageCon.editId==''){
                            //send message
                            FirestoreServices.sendMessage(
                              docId: widget.data.id.toString(),
                              senderId: _messageCon.userId, 
                              senderName: _messageCon.nickName!=""&&_messageCon.nickName!="null"?_messageCon.nickName:_messageCon.userName, 
                              senderProfileImageUrl: _messageCon.profileImageUrl, 
                              text: _messageCon.chatTextCon.text.trim(),
                            );
                            FirestoreServices.setLastMessageChatRoomInfo(
                              groupId: widget.data.id, 
                              lastMessage: _messageCon.chatTextCon.text.trim()
                            );
                            setState(() {
                              _messageCon.chatTextCon.text='';
                              // _messageCon.key.currentState!.controller!.text = '';
                            });
                            _messageCon.scrollToBottomInit();
                            _messageCon.hideFloationButton();
                          }
                          //Edit/update message
                          else if(_messageCon.editId!='' && _messageCon.chatTextCon.text.trim()!=''){
                            FirestoreServices.editMessage(
                              docId: widget.data.id.toString(), 
                              docId2: _messageCon.editId, 
                              text: _messageCon.chatTextCon.text.trim()
                            );
                            if(widget.messageList!=null){
                              var allMessages=[];
                              var lastMessage ="";
                              for (var i = 0; i < widget.messageList.length; i++) {
                                if(widget.messageList[i].deleted=='false' && widget.messageList[0].systemMessage=='false' && widget.messageList[0].text!=''){
                                  allMessages.add(widget.messageList[i]);
                                }
                              }
                              if(widget.messageList[_messageCon.currentSelectedIndex].id==allMessages[0].id){
                                lastMessage = _messageCon.chatTextCon.text.trim();
                              }
                              if(lastMessage!=""){
                                FirestoreServices.setLastMessageChatRoomInfo(
                                  groupId: widget.data.id, 
                                  lastMessage: _messageCon.chatTextCon.text.trim()
                                );
                              }
                            }
                            setState(() {
                              _messageCon.editId = '';
                              _messageCon.chatTextCon.text = '';
                              if(_messageCon.key.currentState!=null){
                                _messageCon.key.currentState!.controller!.text = '';
                              }
                            });
                          }
                          FirestoreServices.addChatRoomLogGroupUser(groupId: widget.data.id, userId: _messageCon.userId.toString());
                        },
                      ),
                    )
                    :const SizedBox(),
                  ],
                ),
              ),
            ],
          )
        )
      ),
    )
    :const SizedBox();
  }
}