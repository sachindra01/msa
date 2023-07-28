import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/widgets/ChatWidgets/message_delete_alert.dart';
import 'package:msa/widgets/toast_message.dart';

class MessageMenuWidget extends StatefulWidget {
  const MessageMenuWidget({ Key? key ,required this.messageSnapshot,required this.index,required this.chatRoomId,required this.globalkey,required this.fbCollection,required this.forChatPage,required this.chatContext}) : super(key: key);
  final dynamic messageSnapshot;
  final int index;
  final dynamic globalkey;
  final String chatRoomId;
  final String fbCollection;
  final String forChatPage;
  final BuildContext chatContext;
  @override
  State<MessageMenuWidget> createState() => _MessageMenuWidgetState();
}

class _MessageMenuWidgetState extends State<MessageMenuWidget> {
  final MessageController _messageCon = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return 
    _messageCon.userId.toString()== widget.messageSnapshot.data[widget.index].senderId
    ?Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.messageSnapshot.data[widget.index].files.length == 0 
        ? Row(
          mainAxisSize: MainAxisSize.min,
            children: [
            //copy
            InkWell(
              onTap: () async {
                _messageCon.hideChatMenu();
                setState(() {
                  if(widget.forChatPage=="inquiry"){
                    Clipboard.setData(ClipboardData(text: widget.messageSnapshot.data[widget.index].text) ).then((value) => [setState((){}), showToastMessage("コピーしました")]); 
                  }
                  else{
                    Clipboard.setData(ClipboardData(text: widget.messageSnapshot.data[widget.index].text) ).then((value) => [showToastMessage("コピーしました"),setState((){})]);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left:10.0,right: 10.0,top: 6.0,bottom: 6.0),
                decoration: const BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.only(
                    topRight:Radius.circular(0.0),
                    bottomRight:Radius.circular(0.0),
                    topLeft:Radius.circular(8.0),
                    bottomLeft:Radius.circular(8.0),
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(Icons.file_copy_outlined,color:white,size: 15,),
                    Text("コピー",style: radioTitle2Style)
                  ]
                ),
              ),
            ),
            const VerticalDivider(width: 0.5),
            //edit
            InkWell(
              onTap: () async {
                _messageCon.hideChatMenu();
                setState(() {
                  if(widget.forChatPage=="inquiry"){
                    _messageCon.inquiryChatTextCon.text = widget.messageSnapshot.data[widget.index].text;
                  }
                  else{
                    _messageCon.chatTextCon.text = widget.messageSnapshot.data[widget.index].text;
                  }
                  _messageCon.editId = widget.messageSnapshot.data[widget.index].id;
                  if(widget.globalkey!=null)
                  {
                    if(widget.globalkey.currentState!=null){
                      widget.globalkey.currentState!.controller!.text = widget.messageSnapshot.data[widget.index].text;
                    }
                  }
                  FocusScopeNode currentFocus = FocusScope.of(widget.chatContext);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 6.0,bottom: 6.0),
                decoration: const BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.only(
                    topRight:Radius.circular(0.0),
                    bottomRight:Radius.circular(0.0),
                    topLeft:Radius.circular(0.0),
                    bottomLeft:Radius.circular(0.0),
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(Icons.edit,color:white,size: 15,),
                    Text("編集",style: radioTitle2Style)
                  ]
                ),
              ),
            ),
            const VerticalDivider(width: 0.5),
          ],
        )
        : const SizedBox(),
        // reply
        InkWell(
          onTap: ()async{
            _messageCon.hideChatMenu();
            setState(() {
              _messageCon.editId="";
              _messageCon.replyMsg.value = true;
              _messageCon.replyData = widget.messageSnapshot.data[widget.index];
              FocusScopeNode currentFocus = FocusScope.of(widget.chatContext);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 6.0,bottom: 6.0),
            decoration:  BoxDecoration(
              color: black,
              borderRadius: BorderRadius.only(
                topLeft:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
                bottomLeft:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
                topRight:const Radius.circular(0.0),
                bottomRight:const Radius.circular(0.0),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.reply_all,color:white,size: 15,),
                Text("返信",style: radioTitle2Style)
              ]
            ),
          ),
        ),
        const VerticalDivider(width: 0.5),
        // delete
        InkWell(
          onTap: () async {
            var allMessages=[];
            dynamic lastMessage;
            for (var i = 0; i < widget.messageSnapshot.data.length; i++) {
              if(widget.messageSnapshot.data[i].deleted=='false' && widget.messageSnapshot.data[i].systemMessage=='false' && widget.messageSnapshot.data[i].text!=''){
                allMessages.add(widget.messageSnapshot.data[i]);
              }
            }
            if(widget.messageSnapshot.data[widget.index].id==allMessages[0].id){
              lastMessage = allMessages[1].text;
            }
            _messageCon.editId="";
            _messageCon.hideChatMenu();
            _messageCon.openDeleteDialog(
              MessageDeleteAlert(
                doc1: widget.chatRoomId.toString(), 
                doc2: widget.messageSnapshot.data[widget.index].id, 
                collection: widget.fbCollection=="chat-rooms"?'chatRoom':"contactUs",
                lastMsgText: lastMessage,
              ),
              context
            );
          },
          child: Container(
            padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 6.0,bottom: 6.0),
            decoration: const BoxDecoration(
              color: black,
              borderRadius: BorderRadius.only(
                topRight:Radius.circular(8.0),
                bottomRight:Radius.circular(8.0),
                topLeft:Radius.circular(0.0),
                bottomLeft:Radius.circular(0.0),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.delete, color:white,size: 15,),
                Text("消去",style: radioTitle2Style)
              ]
            ),
          ),
        ),
      ] 
    )
    // //If Host Copy ,Reply and Delete 
    :_messageCon.memberType=="host"
    ?Row(
      mainAxisSize: MainAxisSize.min,
      children:  [
        widget.messageSnapshot.data[widget.index].files.length == 0
        ?InkWell(
          onTap: () async {
            _messageCon.hideChatMenu();
            setState(() {
              _messageCon.editId="";
              if(widget.forChatPage=="inquiry"){
                Clipboard.setData(ClipboardData(text: widget.messageSnapshot.data[widget.index].text) ).then((value) => [setState((){}), showToastMessage("コピーしました")]); 
              }
              else{
                Clipboard.setData(ClipboardData(text: widget.messageSnapshot.data[widget.index].text) ).then((value) => [showToastMessage("コピーしました"),setState((){})]);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.only(left:10.0,right: 10.0,top: 6.0,bottom: 6.0),
            decoration: const BoxDecoration(
              color: black,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(8.0),
                bottomLeft:Radius.circular(8.0),
                topRight:Radius.circular(0.0),
                bottomRight:Radius.circular(0.0),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.file_copy_outlined,color:white,size: 15,),
                Text("コピー",style: radioTitle2Style)
              ]
            ),
          ),
        )
        :const SizedBox(),

        const VerticalDivider(width: 0.5),
        //reply
        InkWell(
          onTap: ()async{
            _messageCon.hideChatMenu();
            setState(() {
              _messageCon.editId="";
              _messageCon.replyMsg.value = true;
              _messageCon.replyData = widget.messageSnapshot.data[widget.index];
              FocusScopeNode currentFocus = FocusScope.of(widget.chatContext);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 6.0,bottom: 6.0),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.only(
                topRight:const Radius.circular(0.0),
                bottomRight:const Radius.circular(0.0),
                topLeft:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
                bottomLeft:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.reply_all ,color:white,size: 15,),
                Text("返信",style: radioTitle2Style)
              ]
            ),
          ),
        ),
        const VerticalDivider(width: 0.5),
        //delete
        InkWell(
          onTap: () async {
            var allMessages=[];
            dynamic lastMessage;
            for (var i = 0; i < widget.messageSnapshot.data.length; i++) {
              if(widget.messageSnapshot.data[i].deleted=='false' && widget.messageSnapshot.data[i].systemMessage=='false' && widget.messageSnapshot.data[i].text!=''){
                allMessages.add(widget.messageSnapshot.data[i]);
              }
            }
            if(widget.messageSnapshot.data[widget.index].id==allMessages[0].id){
              lastMessage = allMessages[1].text;
            }
            _messageCon.editId="";
            _messageCon.hideChatMenu();
            _messageCon.openDeleteDialog(
              MessageDeleteAlert(
                doc1: widget.chatRoomId.toString(), 
                doc2: widget.messageSnapshot.data[widget.index].id,
                collection: widget.fbCollection=="chat-rooms"?'chatRoom':"contactUs", 
                lastMsgText: lastMessage,
              ),
              context
            );
          },
          child: Container(
            padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 6.0,bottom: 6.0),
            decoration: const BoxDecoration(
              color: black,
              borderRadius: BorderRadius.only(
                topRight:Radius.circular(8.0),
                bottomRight:Radius.circular(8.0),
                topLeft:Radius.circular(0.0),
                bottomLeft:Radius.circular(0.0),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.delete,color:white,size: 15,),
                Text("消去",style: radioTitle2Style)
              ]
            ),
          ),
        ),
      ]
    )
    //If Member Copy && Reply only
    :Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //copy
        widget.messageSnapshot.data[widget.index].files.length == 0
        ?InkWell(
          onTap: () async {
            _messageCon.hideChatMenu();
            setState(() {
              if(widget.forChatPage=="inquiry"){
                Clipboard.setData(ClipboardData(text: widget.messageSnapshot.data[widget.index].text) ).then((value) => [setState((){}), showToastMessage("コピーしました")]); 
              }
              else{
                Clipboard.setData(ClipboardData(text: widget.messageSnapshot.data[widget.index].text) ).then((value) => [showToastMessage("コピーしました"),setState((){})]);
              }
            });
            
          },
          child: Container(
            padding: const EdgeInsets.only(left:10.0,right: 10.0,top: 6.0,bottom: 6.0),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.only(
                topRight:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
                bottomRight:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
                topLeft:const Radius.circular(8.0),
                bottomLeft:const Radius.circular(8.0),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.copy_outlined,color:white,size: 15),
                Text("コピー",style: radioTitle2Style)
              ]
            ),
          ),
        )
        :const SizedBox(),
        const VerticalDivider(width: 0.5),
        //reply
        InkWell(
          onTap: ()async{
            _messageCon.hideChatMenu();
            setState(() {
              _messageCon.replyMsg.value = true;
              _messageCon.replyData = widget.messageSnapshot.data[widget.index];
              FocusScopeNode currentFocus = FocusScope.of(widget.chatContext);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 6.0,bottom: 6.0),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.only(
                topRight:const Radius.circular(8.0),
                bottomRight:const Radius.circular(8.0),
                topLeft:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
                bottomLeft:widget.messageSnapshot.data[widget.index].files.length != 0?const Radius.circular(8.0):const Radius.circular(0.0),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.reply_all,color:white,size: 15,),
                Text("返信",style: radioTitle2Style)
              ]
            ),
          ),
        ),
      ],
    );
  }
}