import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/models/chatmodels/chat_room_info.dart';
import 'package:msa/models/chatmodels/message_model.dart';
import 'package:msa/models/chatmodels/user.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:msa/views/message/group_detail.dart';
import 'package:msa/views/message/search_result_detail.dart';
import 'package:msa/views/message/search_result_page.dart';
import 'package:msa/views/pages/member_info_page.dart';
import 'package:msa/widgets/ChatWidgets/aligned_image_widget.dart';
import 'package:msa/widgets/ChatWidgets/linkify_widget.dart';
import 'package:msa/widgets/ChatWidgets/message_bar.dart';
import 'package:msa/widgets/ChatWidgets/message_bubble_widget.dart';
import 'package:msa/widgets/ChatWidgets/message_menu_widget.dart';
import 'package:msa/widgets/ChatWidgets/reply_message_widget.dart';
import 'package:msa/widgets/ChatWidgets/search_result_count_and_buttons_widget.dart';
import 'package:msa/widgets/ChatWidgets/system_message_badge_widget.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:substring_highlight/substring_highlight.dart';

class ChatPage extends StatefulWidget {
  final dynamic data;
  const ChatPage({Key? key, required this.data}) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessageController _messageCon = Get.put(MessageController());
  int unixTimestamp = 0;
  var messageslist = [];
  final DateFormat formatter = DateFormat('y/M/d');
  DateTime lastMessageTime = DateTime.now();
  String lastMessageDay ='';
  String formattedlastMessageDate = '';
  int firstMessageUnix = 0;
  // var currentSelectedIndex = 0;

  @override
  void initState() {
    //reset unseen counter on enter as it scroll to bottom / new messages
    FirestoreServices.addChatRoomLogGroupUser(groupId: widget.data.id, userId: _messageCon.userId.toString());
    getMemberInfo();
    if (mounted) {
      setState(() {
        _messageCon.editId = '';
        _messageCon.replyMsg.value = false;
        _messageCon.replyData = '';
        _messageCon.chatTextCon.text = '';
        _messageCon.searchBarDisabled.value = true;
        _messageCon.showScrollToBottomBtn = false;
        _messageCon.multiImagefiles=[];
        _messageCon.imageUploading = false;
        _messageCon.multiImagePicked.value = false;
        _messageCon.chatSearchTextController.text='';
        _messageCon.completedUploadImages.value='0.0 %';
        _messageCon.tappedGroup=false;
        unixTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
      });
    }
    _messageCon.handleScroll();
    _messageCon.getPref();
    super.initState();
  }

  //for Group Users as mention [] list
  getMemberInfo()async{
    _messageCon.mentionNames.clear();
    for (var i = 0; i < widget.data.members.length; i++) {
      await _messageCon.getMemberInfo(widget.data.members[i]);
    }
  }

  @override
  void dispose() async{
    super.dispose();
    _messageCon.flutterListController.removeListener(() {});
    await FirestoreServices.addChatRoomLogGroupUser(groupId: widget.data.id, userId: _messageCon.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        _messageCon.hideChatMenu();
      },
      child: Scaffold(
        backgroundColor: whiteGrey,
        extendBodyBehindAppBar: false,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 60),
          child: _messageCon.searchBarDisabled.value == true
          ?AppBar(
            titleSpacing: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text(
              widget.data.title.toString(),
              style: catTitleStyle,
            ),
            backgroundColor: white,
            leading: const BackButton(
              color: black,
            ),
            actions: [
              //search button
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  FocusManager.instance.primaryFocus!.requestFocus();
                  setState(() {
                    _messageCon.searchBarDisabled.value = false;//Enabled Search Bar
                    _messageCon.totalSearchResult.value = 0;
                    _messageCon.searchResultIndex.clear();
                  });
                },
                icon: const Icon(
                  Icons.search,
                  color: black,
                ),
              ),
              //group detail icon
              IconButton(
                constraints: const BoxConstraints(),
                onPressed: (){
                  FocusManager.instance.primaryFocus!.unfocus();
                  Get.to(()=>GroupDetail(groupData: widget.data,alreadyMember: 'yes'),transition: Transition.rightToLeftWithFade);
                }, 
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.black,
                )
              ),
            ],
          )
          :AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: TextFormField(
                autofocus: true,
                style: const TextStyle(color: white),
                cursorColor: white,
                controller: _messageCon.chatSearchTextController,
                onChanged: (x) {
                  setState(() {
                    _messageCon.searchInChat.value = false;
                    _messageCon.showScrollToBottomBtn=false;
                  });
                },
                decoration: InputDecoration(
                  focusColor: white,
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: white,
                    ),
                    onPressed: () {},
                  ),
                  contentPadding: const EdgeInsets.only(left: 4, right: 4),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 31, 124, 113),
                  hintText: '検索',
                  hintStyle: const TextStyle(color: primaryColor),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: (){
                  setState(() {
                    if(_messageCon.searchText!=""){
                      _messageCon.showScrollToBottomBtn=false;
                    }else if(_messageCon.searchInChat.value==true){
                      _messageCon.showScrollToBottomBtn=false;
                    }
                    _messageCon.searchBarDisabled.value = true;
                    _messageCon.chatSearchTextController.text = '';
                    _messageCon.searchInChat.value = false;
                    _messageCon.totalSearchResult.value = 0;
                    _messageCon.currentSearchJumpIndex = 0;
                  });
                }, 
                icon: const Icon(Icons.close),
              )
            ],
          )
        ),
        floatingActionButton: 
        GetBuilder(
          init: MessageController(),
          builder: (_) {
            return Visibility(
              visible: _messageCon.showScrollToBottomBtn,
              child: Padding(
                padding: EdgeInsets.only(bottom: _messageCon.searchInChat.value?height * 0.11:height * 0.08),
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    _messageCon.scrollToBottomInit();
                    _messageCon.hideFloationButton();
                  },
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ),
            );
          },
        ),
        body: _messageCon.chatSearchTextController.text==''
        ? chatMsgWidget(width,height)
        : Obx(()=>
          _messageCon.searchInChat.value == true
          ?SearchResultDetail(widgetChat:chatSearchWidget(width,height))
          :SearchResultPage(messages: messageslist)
        )
      )
    );
  }

  Widget chatMsgWidget(width,height){
    return 
    Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GetBuilder(
          init: MessageController(),
          builder: (_) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right:10.0),
                child: StreamBuilder<List<Message>>(
                  stream: FirestoreServices.getChatMessages(widget.data.id.toString(),true),
                  builder:(BuildContext context, AsyncSnapshot messageSnapshot) {
                    if (messageSnapshot.hasError || !messageSnapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor)
                      );
                    } 
                    else{
                      messageslist = messageSnapshot.data;
                      return FlutterListView(
                        controller: _messageCon.flutterListController,
                        shrinkWrap: true,
                        reverse: true,
                        delegate: FlutterListViewDelegate(
                          (BuildContext context, int index)
                          {
                            // For Grouping Message into Seperate Days
                            var curMessageTime = messageSnapshot.data[index].datetime;//Current Msg Time
                            var prevMessageTime = DateTime.now(); //Prev Msg Time

                            //last message Condition
                            if(index == messageSnapshot.data.length-1)
                            {
                              lastMessageTime = messageSnapshot.data[messageSnapshot.data.length-1].datetime;
                              lastMessageDay = DateFormat('EEEE','ja').format(lastMessageTime).toString();
                              formattedlastMessageDate = formatter.format(lastMessageTime);
                            }
                            //first message Condition
                            else if(index==0){
                              if(index==0&&messageSnapshot.data.length==1){
                                prevMessageTime = messageSnapshot.data[index].datetime;
                              }
                              else{
                                prevMessageTime = messageSnapshot.data[index+1].datetime;
                              }
                              firstMessageUnix = int.tryParse(messageSnapshot.data[index].unixTimestamp)??0;
                              if( firstMessageUnix>unixTimestamp 
                                && messageSnapshot.data[index].senderId.toString()!=_messageCon.userId.toString()
                                && unixTimestamp != 0  
                              ){
                                FirestoreServices.addChatRoomLogGroupUser(groupId: widget.data.id, userId: _messageCon.userId.toString());
                                unixTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
                              }
                            }
                            else{
                              prevMessageTime = messageSnapshot.data[index+1].datetime;
                            }
                            final String formattedCurDate = formatter.format(curMessageTime);
                            String curMessageDay = DateFormat('EEEE','ja').format(curMessageTime).toString(); // Current Msg Day
                            String prevMessageDay = DateFormat('EEEE','ja').format(prevMessageTime).toString(); // Prev Msg Day
                            String curMessageDate = DateFormat('yy/MM/dd','ja').format(curMessageTime).toString();
                            String prevMessageDate = DateFormat('yy/MM/dd','ja').format(prevMessageTime).toString();
                            return
                            Padding(
                              padding: EdgeInsets.only(top:index==messageSnapshot.data.length-1?10.0:0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Message Separator As Per Date
                                  prevMessageDay != curMessageDay && prevMessageDate != curMessageDate
                                  ?SystemMessageBadgeWidget(text: formattedCurDate+' '+'('+curMessageDay+')',msgType: 'date')
                                  //lastMessage date setup
                                  //if message day is same as last msg
                                  :index == messageSnapshot.data.length-1
                                  && DateFormat('EEEE','ja').format(messageSnapshot.data[index].datetime).toString() == curMessageDay
                                  ?SystemMessageBadgeWidget(text:formattedlastMessageDate+' '+'('+lastMessageDay+')',msgType: 'date')
                                  :const SizedBox(),
                                  //Message Day Separator
                                  
                                  //if message type is SYSTEM MESSAGE == TRUE // メッセージの送信を取り消しました
                                  messageSnapshot.data[index].deleted == "true"
                                  ?const SystemMessageBadgeWidget(text:"メッセージの送信を取り消しました",msgType: '')
                                  :messageSnapshot.data[index].systemMessage == "true" && messageSnapshot.data[index].text == "メッセージの送信を取り消しました"
                                  ?SystemMessageBadgeWidget(text:messageSnapshot.data[index].text,msgType: '') 
                                  :messageSnapshot.data[index].systemMessage == "true"
                                  //No Badge Message leave/joined
                                  ?Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text(
                                      messageSnapshot.data[index].text,
                                      textAlign: TextAlign.center,
                                      style: chatSystemMessageBlackStyle,
                                    ),
                                  )
                                  //MESSAGES
                                  :Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Column(
                                      crossAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Visibility(
                                          visible: _messageCon.currentSelectedIndex == index 
                                          ?_messageCon.isVisibleMsgMenu.value 
                                          :false,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom : 5.0),
                                            child: MessageMenuWidget(
                                              messageSnapshot: messageSnapshot, 
                                              index: index, 
                                              chatRoomId: widget.data.id.toString(), 
                                              globalkey: _messageCon.key, 
                                              fbCollection: "chat-rooms", 
                                              forChatPage: 'groupChat',
                                              chatContext: context,
                                            ),
                                          ),
                                        ),
                                        StreamBuilder<User>(
                                          stream: FirestoreServices.getUserProfile(messageSnapshot.data[index].senderId.toString()),
                                          builder:(BuildContext context, AsyncSnapshot userInfo) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Profile Image if Others Message
                                                _messageCon.userId.toString()!= messageSnapshot.data[index].senderId
                                                ?InkWell(
                                                  onTap: (){
                                                    Get.to(()=>const MemberInfoPage(),arguments: messageSnapshot.data[index].senderId,transition: Transition.rightToLeftWithFade);
                                                  },
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
                                                )
                                                :const SizedBox(),
                                                //Profile and Message Gap
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                //Message Contents
                                                GestureDetector( 
                                                  onLongPress: (){
                                                    setState(() {
                                                      _messageCon.isVisibleMsgMenu.value = true;
                                                      _messageCon.currentSelectedIndex = index;
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                                    ?CrossAxisAlignment.end
                                                    :CrossAxisAlignment.start,
                                                    children: [
                                                      //Show Sender Name if others msg
                                                      _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                      ?
                                                      Container(
                                                        constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(context).size.width*0.7,
                                                        ),
                                                        padding: const EdgeInsets.only(bottom: 4.0),
                                                        child: userInfo.hasError || !userInfo.hasData
                                                        ?GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              _messageCon.key.currentState!.controller!.text = _messageCon.chatTextCon.text+' '+messageSnapshot.data[index].senderName;
                                                            });
                                                          },
                                                          child: Text(
                                                            messageSnapshot.data[index].senderName,
                                                            style: chatUserNameStyle,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ) 
                                                        :GestureDetector(
                                                          onTap: (){
                                                            String senderName = '';
                                                            if(userInfo.data.nickname!=''||userInfo.data.nickname!='null'){
                                                              senderName = userInfo.data.nickname;
                                                            }
                                                            else{
                                                              senderName = messageSnapshot.data[index].senderName;
                                                            }
                                                            setState(() {
                                                              _messageCon.key.currentState!.controller!.text = _messageCon.chatTextCon.text+' '+senderName;
                                                            });
                                                          },
                                                          child: Text(
                                                            userInfo.data.nickname!=''&&userInfo.data.nickname!='null'
                                                            ?userInfo.data.nickname
                                                            :messageSnapshot.data[index].senderName,
                                                            style: chatUserNameStyle,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      )
                                                      :const SizedBox(),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          //Message Time if Own Message
                                                          _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                                          ? Padding(
                                                            padding: const EdgeInsets.only(right:5.0),
                                                            child: Column(
                                                              children: [
                                                                Text(DateFormat.Hm().format(messageSnapshot.data[index].datetime).toString(),style: chatDateeStyle),
                                                              ],
                                                            ),
                                                          )
                                                          : const SizedBox(),
                                                          //Image Message
                                                          messageSnapshot.data[index].files.length!=0
                                                          ? AlignedImageWidget(
                                                            imageUrl: messageSnapshot.data[index].files[0]["downloadURL"].toString(), 
                                                            userId: _messageCon.userId.toString(), 
                                                            senderId: messageSnapshot.data[index].senderId
                                                          )
                                                          //else if reply field not empty show reply 
                                                          : messageSnapshot.data[index].reply != ''
                                                          ? GestureDetector(
                                                            onTap: (){
                                                              var jumpToIndex = 0;
                                                              for (var i = 0; i < messageSnapshot.data.length; i++) {
                                                                if(messageSnapshot.data[i].id == messageSnapshot.data[index].reply){
                                                                  jumpToIndex = i;
                                                                }
                                                              }
                                                              _messageCon.flutterListController.sliverController.jumpToIndex(jumpToIndex);
                                                              if(jumpToIndex-index>5 || index >= 4){
                                                                _messageCon.showFloationButton();
                                                              }
                                                            },
                                                            child: MessageBubbleWidget(
                                                              senderId: messageSnapshot.data[index].senderId,
                                                              userId: _messageCon.userId.toString(),
                                                              child: StreamBuilder<Message>(
                                                                stream: FirestoreServices.replyMsgDetail(widget.data.id.toString(),messageSnapshot.data[index].reply),
                                                                builder:(BuildContext context, AsyncSnapshot messageDetailSnapShot) {
                                                                  if (messageDetailSnapShot.hasError || !messageDetailSnapShot.hasData) {
                                                                    return SizedBox(
                                                                      height: 50,
                                                                      child: Center(
                                                                        child: SizedBox(
                                                                          height: 20,
                                                                          width: 20,
                                                                          child: CircularProgressIndicator(
                                                                            strokeWidth: 1,
                                                                            color: _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                                            ? primaryColor
                                                                            : white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } 
                                                                  else{
                                                                    return Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        //Reply Message and user info 
                                                                        StreamBuilder<User>(
                                                                          stream: FirestoreServices.getUserProfile(messageDetailSnapShot.data.senderId.toString()),
                                                                          builder:(BuildContext context, AsyncSnapshot replyUserInfo) {
                                                                            return Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 28, 
                                                                                  width: 28,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(80),
                                                                                    child: CachedNetworkimage(
                                                                                      height: 28, 
                                                                                      width: 28,
                                                                                      imageUrl: replyUserInfo.hasError || !replyUserInfo.hasData
                                                                                        ?messageDetailSnapShot.data.senderProfileImageURl:
                                                                                        replyUserInfo.data.profileImageUrl
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(width: 5.0),
                                                                                Flexible(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Theme(
                                                                                        data: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: primaryColor)),
                                                                                        child: replyUserInfo.hasError || !replyUserInfo.hasData
                                                                                        ?Text(
                                                                                          messageDetailSnapShot.data.senderName,
                                                                                          maxLines: 1,
                                                                                          style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                        )
                                                                                        :Text(
                                                                                          replyUserInfo.data.nickname==""||replyUserInfo.data.nickname=="null"?messageDetailSnapShot.data.senderName:replyUserInfo.data.nickname,
                                                                                          maxLines: 1,
                                                                                          style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                        )
                                                                                      ),
                                                                                      messageDetailSnapShot.data.files.length!=0
                                                                                      ?Container(
                                                                                        padding: const EdgeInsets.only(top:6.0),
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
                                                                                              width: MediaQuery.of(context).size.width *0.4,
                                                                                              height: MediaQuery.of(context).size.height *0.0,
                                                                                              color: grey,
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
                                                                                        child: Text(
                                                                                          messageDetailSnapShot.data.text,
                                                                                          maxLines: 1,
                                                                                          style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            );
                                                                          }
                                                                        ),
                                                                        Divider(
                                                                          color: _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                                          ? black
                                                                          : white
                                                                        ),
                                                                        //Reply message
                                                                        LinkifyWidget(
                                                                          text: messageSnapshot.data[index].text, 
                                                                          userId: _messageCon.userId.toString(), 
                                                                          senderId: messageSnapshot.data[index].senderId,
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }
                                                                }
                                                              ),
                                                            ),
                                                          )
                                                          //Normal message
                                                          : MessageBubbleWidget(
                                                            senderId: messageSnapshot.data[index].senderId,
                                                            userId: _messageCon.userId.toString(),
                                                            child: LinkifyWidget(
                                                              text: messageSnapshot.data[index].text, 
                                                              userId: _messageCon.userId.toString(), 
                                                              senderId: messageSnapshot.data[index].senderId,
                                                            ),
                                                          ),
                                                          //Message Time if Others Message
                                                          _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                          ? Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Column(
                                                              children: [
                                                                Text(DateFormat.Hm().format(messageSnapshot.data[index].datetime).toString(),style: chatDateeStyle),
                                                              ],
                                                            ),
                                                          )
                                                          : const SizedBox(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: messageSnapshot.data.length,
                        ),
                      );
                    }
                  }
                ),
              ),
            );
          }
        ),
        //Reply Message
        Obx(()=>
          _messageCon.replyMsg.value==true
          ?ReplyMessageWidget(userId: widget.data.id, fbCollectionName: "chat-rooms")
          :const SizedBox()
        ), 
        //message textfield and send buttons
        StreamBuilder<ChatRoomInfo>(
          stream: FirestoreServices.getChatRoomInfoDetail(widget.data.id),
          builder:(BuildContext context, AsyncSnapshot chatRommInfoDetailSnapShot) {
            if (chatRommInfoDetailSnapShot.hasError || !chatRommInfoDetailSnapShot.hasData) {
              return const SizedBox();
            } 
            else{
              for (var i = 0; i < chatRommInfoDetailSnapShot.data.messageReadLogs.length; i++) {
                if(chatRommInfoDetailSnapShot.data.messageReadLogs[i]['user_id'] == _messageCon.userId.toString()){
                  unixTimestamp = chatRommInfoDetailSnapShot.data.messageReadLogs[i]['unix_timestamp'];
                }
              }
              return MessageBar(forPage:'group',chatRommInfoDetailSnapShot:chatRommInfoDetailSnapShot,data: widget.data,messageList: messageslist);
            }
          }
        ),
      ],
    );
  }

  Widget chatSearchWidget(width,height){
    return 
    Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //Messages List
        GetBuilder(
          init: MessageController(),
          builder: (_) {
            return 
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right:10.0),
                child: StreamBuilder<List<Message>>(
                  stream: FirestoreServices.getChatMessages(widget.data.id.toString(),true),
                  builder:(BuildContext context, AsyncSnapshot messageSnapshot) {
                    if (messageSnapshot.hasError || !messageSnapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor)
                      );
                    } 
                    else{
                      messageslist = messageSnapshot.data;
                      return FlutterListView(
                        controller: _messageCon.flutterListController,
                        shrinkWrap: true,
                        reverse: true,
                        physics:const AlwaysScrollableScrollPhysics(),
                        delegate: FlutterListViewDelegate(
                        (BuildContext context, int index)
                          {
                            // For Grouping Message into Seperate Days
                            var curMessageTime = messageSnapshot.data[index].datetime;//Current Msg Time
                            var prevMessageTime = DateTime.now(); //Prev Msg Time

                            //first message Condition
                            if(index==0){
                              if(index==0 && messageSnapshot.data.length==1){
                                prevMessageTime = messageSnapshot.data[index].datetime;
                              }
                              else{
                                prevMessageTime = messageSnapshot.data[index+1].datetime;
                              }
                              firstMessageUnix = int.tryParse(messageSnapshot.data[index].unixTimestamp)??0;
                              if( firstMessageUnix>unixTimestamp 
                                && messageSnapshot.data[index].senderId.toString()!=_messageCon.userId.toString()
                                && unixTimestamp != 0  
                              ){
                                FirestoreServices.addChatRoomLogGroupUser(groupId: widget.data.id, userId: _messageCon.userId.toString());
                                unixTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
                              }
                            }
                            //last message Condition
                            else if(index == messageSnapshot.data.length-1)
                            {
                              lastMessageTime = messageSnapshot.data[messageSnapshot.data.length-1].datetime;
                              lastMessageDay = DateFormat('EEEE','ja').format(lastMessageTime).toString();
                              formattedlastMessageDate = formatter.format(lastMessageTime);
                            }
                            else{
                              prevMessageTime = messageSnapshot.data[index+1].datetime;
                            }
                            final String formattedCurDate = formatter.format(curMessageTime);
                            String curMessageDay = DateFormat('EEEE','ja').format(curMessageTime).toString(); // Current Msg Day
                            String prevMessageDay = DateFormat('EEEE','ja').format(prevMessageTime).toString(); // Prev Msg Day
                            String curMessageDate = DateFormat('yy/MM/dd','ja').format(curMessageTime).toString();
                            String prevMessageDate = DateFormat('yy/MM/dd','ja').format(prevMessageTime).toString();

                            return
                            Padding(
                              padding: EdgeInsets.only(top:index==messageSnapshot.data.length-1?10.0:0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Message Separator As Per Date
                                  prevMessageDay != curMessageDay && prevMessageDate != curMessageDate
                                  ?SystemMessageBadgeWidget(text: formattedCurDate+' '+'('+curMessageDay+')', msgType: 'date')
                                  //lastMessage date setup
                                  //if message day is same as last msg
                                  :index == messageSnapshot.data.length-1 
                                  && DateFormat('EEEE','ja').format(messageSnapshot.data[index].datetime).toString() == curMessageDay
                                  ?SystemMessageBadgeWidget(text: formattedlastMessageDate+' '+'('+lastMessageDay+')',msgType: 'date')
                                  :const SizedBox(),
                                  //if message type is SYSTEM MESSAGE == TRUE
                                  messageSnapshot.data[index].deleted == "true"
                                  ?const SystemMessageBadgeWidget(text:"メッセージの送信を取り消しました",msgType: '')
                                  :messageSnapshot.data[index].systemMessage == "true" && messageSnapshot.data[index].text == "メッセージの送信を取り消しました"
                                  ? SystemMessageBadgeWidget(text: messageSnapshot.data[index].text,msgType: '')
                                  :messageSnapshot.data[index].systemMessage == "true"
                                  //No Badge Message leave/joined
                                  ?Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text(
                                      messageSnapshot.data[index].text,
                                      textAlign: TextAlign.center,
                                      style: chatSystemMessageBlackStyle,
                                    ),
                                  )
                                  //MESSAGES
                                  :Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Column(
                                      crossAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: _messageCon.currentSelectedIndex == index ? _messageCon.isVisibleMsgMenu.value : false,
                                          child:  Padding(
                                            padding: const EdgeInsets.only(bottom : 5.0),
                                            child: MessageMenuWidget(
                                              messageSnapshot: messageSnapshot, 
                                              index: index, 
                                              chatRoomId: widget.data.id.toString(), 
                                              globalkey: _messageCon.key, 
                                              fbCollection: "chat-rooms", 
                                              forChatPage: 'groupChat',
                                              chatContext: context,
                                            ),
                                          ),
                                        ),
                                        StreamBuilder<User>(
                                          stream: FirestoreServices.getUserProfile(messageSnapshot.data[index].senderId.toString()),
                                          builder:(BuildContext context, AsyncSnapshot userInfo) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Show Profile Image For others msg
                                                _messageCon.userId.toString()!= messageSnapshot.data[index].senderId
                                                ?InkWell(
                                                  onTap: (){
                                                    Get.to(()=>const MemberInfoPage(),arguments: messageSnapshot.data[index].senderId,transition: Transition.rightToLeftWithFade);
                                                  },
                                                  child: SizedBox(
                                                    height: 28, 
                                                    width: 28,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(80),
                                                      child: userInfo.hasError || !userInfo.hasData
                                                      ?const CachedNetworkimage(
                                                        height: 28, 
                                                        width: 28,
                                                        imageUrl: '',
                                                      )
                                                      :CachedNetworkimage(
                                                        height: 28, 
                                                        width: 28,
                                                        imageUrl: userInfo.data.profileImageUrl,
                                                      )
                                                    ),
                                                  ),
                                                )
                                                :const SizedBox(),
                                                //Gap Between Profile and Message
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                //Message Column
                                                GestureDetector(
                                                  onLongPress: (){
                                                    setState(() {
                                                      _messageCon.isVisibleMsgMenu.value = true;
                                                      _messageCon.currentSelectedIndex = index;
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                                    ?CrossAxisAlignment.end
                                                    :CrossAxisAlignment.start,
                                                    children: [
                                                      //Show Sender Name if others msg
                                                      _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                      ?Container(
                                                        constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(context).size.width*0.7
                                                        ),
                                                        padding: const EdgeInsets.only(bottom:4.0),
                                                        child: userInfo.hasError || !userInfo.hasData
                                                        ?GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              _messageCon.key.currentState!.controller!.text = _messageCon.chatTextCon.text+' '+messageSnapshot.data[index].senderName;
                                                            });
                                                          },
                                                          child: Text(
                                                            messageSnapshot.data[index].senderName,
                                                            style: chatUserNameStyle,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        )
                                                        :GestureDetector(
                                                          onTap: (){
                                                            String senderName = '';
                                                            if(userInfo.data.nickname!=''||userInfo.data.nickname!='null'){
                                                              senderName = userInfo.data.nickname;
                                                            }
                                                            else{
                                                              senderName = messageSnapshot.data[index].senderName;
                                                            }
                                                            setState(() {
                                                              _messageCon.key.currentState!.controller!.text = _messageCon.chatTextCon.text+' '+senderName;
                                                            });
                                                          },
                                                          child: Text(
                                                            userInfo.data.nickname!=''&&userInfo.data.nickname!='null'
                                                            ?userInfo.data.nickname
                                                            :messageSnapshot.data[index].senderName,
                                                            style: chatUserNameStyle,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      )
                                                      :const SizedBox(),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          //Message Time if Own Message
                                                          _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                                          ? Padding(
                                                            padding: const EdgeInsets.only(right:5.0),
                                                            child: Column(
                                                              children: [
                                                                Text(DateFormat.Hm().format(messageSnapshot.data[index].datetime).toString(),style: chatDateeStyle),
                                                              ],
                                                            ),
                                                          )
                                                          : const SizedBox(),
                                                          //if File is not empty show Image
                                                          messageSnapshot.data[index].files.length!=0
                                                          ?AlignedImageWidget(
                                                            imageUrl: messageSnapshot.data[index].files[0]["downloadURL"].toString(), 
                                                            userId: _messageCon.userId.toString(), 
                                                            senderId: messageSnapshot.data[index].senderId
                                                          )
                                                          //else if reply field not empty show reply 
                                                          : messageSnapshot.data[index].reply != ''
                                                          ? GestureDetector(
                                                            onTap: (){
                                                              var jumpToIndex = 0;
                                                              for (var i = 0; i < messageSnapshot.data.length; i++) {
                                                                if(messageSnapshot.data[i].id == messageSnapshot.data[index].reply){
                                                                  jumpToIndex = i;
                                                                }
                                                              }
                                                              _messageCon.flutterListController.sliverController.jumpToIndex(jumpToIndex);
                                                              if(jumpToIndex-index>5 || index >= 4){
                                                                _messageCon.showFloationButton();
                                                              }
                                                            },
                                                            child:MessageBubbleWidget(
                                                              senderId: messageSnapshot.data[index].senderId,
                                                              userId: _messageCon.userId.toString(),
                                                              child: StreamBuilder<Message>(
                                                                stream: FirestoreServices.replyMsgDetail(widget.data.id.toString(),messageSnapshot.data[index].reply),
                                                                builder:(BuildContext context, AsyncSnapshot messageDetailSnapShot) {
                                                                  if (messageDetailSnapShot.hasError || !messageDetailSnapShot.hasData) {
                                                                    return SizedBox(
                                                                      height: 50,
                                                                      child: Center(
                                                                        child: SizedBox(
                                                                          height: 20,
                                                                          width: 20,
                                                                          child: CircularProgressIndicator(
                                                                            strokeWidth: 1,
                                                                            color: _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                                            ? primaryColor
                                                                            : white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } 
                                                                  else{
                                                                    return Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        //Reply Message and user info 
                                                                        StreamBuilder<User>(
                                                                          stream: FirestoreServices.getUserProfile(messageDetailSnapShot.data.senderId.toString()),
                                                                          builder:(BuildContext context, AsyncSnapshot replyUserInfo) {
                                                                            return 
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 28, 
                                                                                  width: 28,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(80),
                                                                                    child: CachedNetworkimage(
                                                                                      height: 28, 
                                                                                      width: 28,
                                                                                      imageUrl: replyUserInfo.hasError || !replyUserInfo.hasData
                                                                                        ?messageDetailSnapShot.data.senderProfileImageURl:
                                                                                        replyUserInfo.data.profileImageUrl
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(width: 5.0),
                                                                                Flexible(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      replyUserInfo.hasError || !replyUserInfo.hasData
                                                                                      ?Text(
                                                                                        messageDetailSnapShot.data.senderName,
                                                                                        maxLines: 1,
                                                                                        style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                      )
                                                                                      :Text(
                                                                                        replyUserInfo.data.nickname,
                                                                                        maxLines: 1,
                                                                                        style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                      ),
                                                                                      messageDetailSnapShot.data.files.length!=0
                                                                                      ?Container(
                                                                                        padding: const EdgeInsets.only(top:6.0),
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
                                                                                              width: MediaQuery.of(context).size.width *0.4,
                                                                                              height: MediaQuery.of(context).size.height *0.0,
                                                                                              color: grey,
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
                                                                                        child:Text(
                                                                                          messageDetailSnapShot.data.text,
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            );
                                                                          }
                                                                        ),
                                                                        Divider(
                                                                          color: _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                                          ? black
                                                                          : white
                                                                        ),
                                                                        //Reply message
                                                                        SubstringHighlight(
                                                                          text:messageSnapshot.data[index].text,
                                                                          textStyle: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatTextBlackHeaderStyle:chatTextWhiteHeaderStyle,
                                                                          textStyleHighlight: textHighlightStyle,
                                                                          term: _messageCon.chatSearchTextController.text, 
                                                                        )
                                                                      ],
                                                                    );
                                                                  }
                                                                }
                                                              ),
                                                            ),
                                                          )
                                                          //else show normal message
                                                          : MessageBubbleWidget(
                                                            senderId: messageSnapshot.data[index].senderId,
                                                            userId: _messageCon.userId.toString(),
                                                            child: SubstringHighlight(
                                                              text: messageSnapshot.data[index].text,
                                                              textStyle: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatTextBlackHeaderStyle:chatTextWhiteHeaderStyle,
                                                              textStyleHighlight: textHighlightStyle,
                                                              term: _messageCon.chatSearchTextController.text, 
                                                            )
                                                          ),
                                                          //Message Time if Others Message
                                                          _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                          ? Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Column(
                                                              children: [
                                                                Text(DateFormat.Hm().format(messageSnapshot.data[index].datetime).toString(),style: chatDateeStyle),
                                                              ],
                                                            ),
                                                          )
                                                          : const SizedBox(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: messageSnapshot.data.length,
                        )
                      );
                    }
                  }
                ),
              ),
            );
          }
        ),
        Obx(()=>
          _messageCon.replyMsg.value==true
          ?ReplyMessageWidget(userId: widget.data.id, fbCollectionName: "chat-rooms")
          :const SizedBox()
        ),
        const SearchResultCountAndButtonWidget(),
        //message textfield and send buttons
        StreamBuilder<ChatRoomInfo>(
          stream: FirestoreServices.getChatRoomInfoDetail(widget.data.id),
          builder:(BuildContext context, AsyncSnapshot chatRommInfoDetailSnapShot) {
            if (chatRommInfoDetailSnapShot.hasError || !chatRommInfoDetailSnapShot.hasData) {
              return const SizedBox();
            } 
            else{
              for (var i = 0; i < chatRommInfoDetailSnapShot.data.messageReadLogs.length; i++) {
                if(chatRommInfoDetailSnapShot.data.messageReadLogs[i]['user_id'] == _messageCon.userId.toString()){
                  unixTimestamp = chatRommInfoDetailSnapShot.data.messageReadLogs[i]['unix_timestamp'];
                }
              }
              return MessageBar(forPage:'group',chatRommInfoDetailSnapShot:chatRommInfoDetailSnapShot,data: widget.data,messageList: messageslist);
            }
          }
        ),
      ],
    );
  }
}
