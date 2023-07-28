import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/models/chatmodels/message_model.dart';
import 'package:msa/models/chatmodels/user.dart';
import 'package:msa/services/firestore_services.dart';

class ReplyMessageWidget extends StatefulWidget {
  const ReplyMessageWidget({Key? key,required this.userId,required this.fbCollectionName}) : super(key: key);
  final dynamic userId;
  final dynamic fbCollectionName;
  @override
  State<ReplyMessageWidget> createState() => _ReplyMessageWidgetState();
}

class _ReplyMessageWidgetState extends State<ReplyMessageWidget> {
  final MessageController _messageCon = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MessageController(),
      builder: (_) {
        return _messageCon.replyMsg.value==true
        ? Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top:10.0),
          color: white,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              widget.fbCollectionName == "chat-rooms"
              ?StreamBuilder<Message>(
                stream: FirestoreServices.replyMsgDetail(widget.userId.toString(),_messageCon.replyData.id),
                builder:(BuildContext context, AsyncSnapshot messageDetailSnapShot) {
                  if (messageDetailSnapShot.hasError || !messageDetailSnapShot.hasData) {
                    return const Center(
                      child: SizedBox()
                    );
                  } 
                  else{
                    return StreamBuilder<User>(
                      stream: FirestoreServices.getUserProfile(messageDetailSnapShot.data.senderId.toString()),
                      builder:(BuildContext context, AsyncSnapshot userInfo) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:10.0,right: 10.0),
                              child: SizedBox(
                                height: 28, 
                                width: 28,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: userInfo.hasError || !userInfo.hasData
                                  ? const CachedNetworkimage(
                                    height: 28, 
                                    width: 28,
                                    imageUrl: '',
                                  )
                                  : CachedNetworkimage(
                                    height: 28, 
                                    width: 28,
                                    imageUrl: userInfo.data.profileImageUrl,
                                  )
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Theme(
                                    data: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: primaryColor)),
                                    child: userInfo.hasError || !userInfo.hasData
                                    ?SelectableText(
                                      messageDetailSnapShot.data.senderName,
                                      style: chatReplyWidgetUserNameStyle,
                                      maxLines: 1,
                                    )
                                    :SelectableText(
                                      userInfo.data.nickname!=''&&userInfo.data.nickname!='null'
                                      ?userInfo.data.nickname
                                      :messageDetailSnapShot.data.senderName,
                                      style: chatReplyWidgetUserNameStyle,
                                      maxLines: 1,
                                    ),
                                  ),
                                  messageDetailSnapShot.data.files.length!=0
                                  ?Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: transparent,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *0.2,
                                      child: CachedNetworkImage(
                                        imageUrl:messageDetailSnapShot.data.files[0]['downloadURL'],
                                        placeholder: (context, url) => Container(
                                          color: transparent,
                                          padding: const EdgeInsets.all(0.0),
                                          child: const SizedBox(
                                            width: 4.0,
                                            height: 4.0,
                                            child:Center(
                                              child: CircularProgressIndicator(color: primaryColor)
                                            )
                                          )
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        fit: BoxFit.fitWidth,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      clipBehavior : Clip.antiAlias,
                                    ),
                                  )
                                  :Theme(
                                    data: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:10.0),
                                      child: SelectableText(
                                        messageDetailSnapShot.data.text,
                                        style: chatReplyWidgetSubTextStyle,
                                        maxLines: 5,
                                        minLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    );
                  }
                }
              )
              :const SizedBox(),
              //
              widget.fbCollectionName == "contact-us"
              ?StreamBuilder<Message>(
                stream: FirestoreServices.replyMsgInquiryDetail(widget.userId.toString(),_messageCon.replyData.id),
                builder:(BuildContext context, AsyncSnapshot messageDetailSnapShot) {
                  if (messageDetailSnapShot.hasError || !messageDetailSnapShot.hasData) {
                    return const Center(
                      child: SizedBox()
                    );
                  } 
                  else{
                    return StreamBuilder<User>(
                      stream: FirestoreServices.getUserProfile(messageDetailSnapShot.data.senderId.toString()),
                      builder:(BuildContext context, AsyncSnapshot userInfo) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:10.0,right: 10.0),
                              child: SizedBox(
                                height: 28, 
                                width: 28,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: userInfo.hasError || !userInfo.hasData
                                  ? const CachedNetworkimage(
                                    height: 28, 
                                    width: 28,
                                    imageUrl: '',
                                  )
                                  : CachedNetworkimage(
                                    height: 28, 
                                    width: 28,
                                    imageUrl: userInfo.data.profileImageUrl,
                                  )
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Theme(
                                    data: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: primaryColor)),
                                    child: userInfo.hasError || !userInfo.hasData
                                    ?SelectableText(
                                      messageDetailSnapShot.data.senderName,
                                      style: chatReplyWidgetUserNameStyle,
                                      maxLines: 1,
                                    )
                                    :SelectableText(
                                      userInfo.data.nickname!=''&&userInfo.data.nickname!='null'
                                      ?userInfo.data.nickname
                                      :messageDetailSnapShot.data.senderName,
                                      style: chatReplyWidgetUserNameStyle,
                                      maxLines: 1,
                                    ),
                                  ),
                                  messageDetailSnapShot.data.files.length!=0
                                  ?Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: transparent,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *0.2,
                                      child: CachedNetworkImage(
                                        imageUrl:messageDetailSnapShot.data.files[0]['downloadURL'],
                                        placeholder: (context, url) => Container(
                                          color: transparent,
                                          padding: const EdgeInsets.all(0.0),
                                          child: const SizedBox(
                                            width: 4.0,
                                            height: 4.0,
                                            child:Center(
                                              child: CircularProgressIndicator(color: primaryColor)
                                            )
                                          )
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        fit: BoxFit.fitWidth,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      clipBehavior : Clip.antiAlias,
                                    ),
                                  )
                                  :Theme(
                                    data: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:10.0),
                                      child: Text(
                                        messageDetailSnapShot.data.text,
                                        style: chatReplyWidgetSubTextStyle,
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    );
                  }
                }
              )
              :const SizedBox(),
              //Close Button
              Positioned(
                right:-6,
                top: -16,
                child: IconButton(
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.close,
                    color: grey
                  ),
                  onPressed: (){
                    setState(() {
                      _messageCon.replyMsg.value=false;
                      _messageCon.replyData = '';
                    });
                  }, 
                ),
              ),
            ],
          ),
        )
        :const SizedBox();  
      }
    );
  }
}