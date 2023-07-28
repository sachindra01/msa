import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/models/chatmodels/message_model.dart';
import 'package:msa/services/firestore_services.dart';
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
import 'package:substring_highlight/substring_highlight.dart';
import '../../models/chatmodels/user.dart';
class InquiryChatPage extends StatefulWidget {
  final dynamic data;
  final String fromPage;
  final String title;
  const InquiryChatPage({Key? key, required this.data,required this.fromPage,required this.title}) : super(key: key);

  @override
  State<InquiryChatPage> createState() => _InquiryChatPageState();
}

class _InquiryChatPageState extends State<InquiryChatPage> {
  final MessageController _messageCon = Get.put(MessageController());
  var currentSelectedValue = '';
  final DateFormat formatter = DateFormat('M/d');
  DateTime lastMessageTime = DateTime.now();
  String lastMessageDay ='';
  String formattedlastMessageDate = '';
  var inquiryMessageslist = [];
  var currentSelectedIndex = 0;

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _messageCon.imageFile=null;
        _messageCon.editId = '';
        _messageCon.replyMsg.value = false;
        _messageCon.replyData = '';
        _messageCon.inquiryChatTextCon.text = '';
        _messageCon.multiImagefiles=[];
        _messageCon.imageUploading = false;
        _messageCon.searchBarDisabled.value = true;
        _messageCon.imagePicked.value = false;
        _messageCon.chatSearchTextController.text='';
        _messageCon.completedUploadImages.value='0.0 %';
        _messageCon.showScrollToBottomBtn = false;
      });
    }
    _messageCon.getPref();
    _messageCon.handleScroll();
    super.initState();
  }

  @override
  void dispose() {
    _messageCon.flutterListController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        setState(() {
          _messageCon.hideChatMenu();
        });
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,60),
          child: _messageCon.searchBarDisabled.value == true
          ? AppBar(
            titleSpacing: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text(
              widget.title.toString(),
              style: catTitleStyle,
            ),
            backgroundColor: white,
            leading: const BackButton(
              color: black,
            ),
            actions: [
              //Status Dropdown
              Container(
                padding: const EdgeInsets.all(5),
                width: width * 0.25,
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: primaryColor),
                        contentPadding: EdgeInsets.zero
                      ),
                      isEmpty: currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          alignment: Alignment.centerRight,
                          menuMaxHeight: 200,
                          dropdownColor : white,
                          borderRadius: BorderRadius.circular(30),
                          icon: const Visibility(
                            visible: false,
                            child: Icon(Icons.arrow_drop_down),
                          ),
                          value: (currentSelectedValue == '')
                          ? widget.data.chatStatus
                          : currentSelectedValue,
                          isDense: false,
                          onChanged: (newValue) {
                            setState(() {
                              currentSelectedValue = newValue!;
                              state.didChange(newValue);
                            });
                            FirestoreServices.editInquiryChatStatus(docId: widget.data.userId, chatStatus: int.parse(newValue!));
                          },
                          items: _messageCon.options.map((String value) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: value,
                              child: Center(
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: _messageCon.chatStatusColor(value),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  padding: const EdgeInsets.all(0),
                                  child: Center(
                                    child: Text(
                                      _messageCon.chatStatusText(value),
                                      style: catTextStyle,
                                    )
                                  ),
                                )
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                onPressed: () {
                  FocusManager.instance.primaryFocus!.requestFocus();
                  setState(() {
                    _messageCon.searchBarDisabled.value = false;
                    _messageCon.totalSearchResult.value = 0;
                    _messageCon.searchResultIndex.clear();
                  });
                },
                icon: const Icon(
                  Icons.search,
                  color: black,
                ),
              ),
            ],
          )
          : AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: TextFormField(
                autofocus: true,
                style: const TextStyle(color: white),
                controller: _messageCon.chatSearchTextController,
                cursorColor: white,
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
                )
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
          ),
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
          }
        ),
        body: _messageCon.chatSearchTextController.text==''
          ? chatWidget(width,height)
          : Obx(()=>
          _messageCon.searchInChat.value == true
          ?SearchResultDetail(widgetChat:chatSearchWidget(width,height))
          :SearchResultPage(messages: inquiryMessageslist)
          )
      ),
    );
  }

  Widget chatWidget(width,height){
    return 
    Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //Message List
        GetBuilder(
          init: MessageController(),
          builder: (_) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right:10.0),
                child: StreamBuilder<List<Message>>(
                  stream: FirestoreServices.getInquiryChatMessages(widget.data.userId.toString(),true),
                  builder:(BuildContext context, AsyncSnapshot messageSnapshot) {
                    if (messageSnapshot.hasError || !messageSnapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor)
                      );
                    } 
                    else{
                      inquiryMessageslist = messageSnapshot.data;
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

                            //Last Message Condition
                            if(index == messageSnapshot.data.length-1)
                            {
                              lastMessageTime = messageSnapshot.data[messageSnapshot.data.length-1].datetime;
                              lastMessageDay = DateFormat('EEEE','ja').format(lastMessageTime).toString();
                              formattedlastMessageDate = formatter.format(lastMessageTime);
                            }
                            //first message Condition
                            else if(index==0){
                              if(index==0 && messageSnapshot.data.length==1){
                                prevMessageTime = messageSnapshot.data[index].datetime;
                              }
                              else{
                                prevMessageTime = messageSnapshot.data[index+1].datetime;
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

                            return Padding(
                              padding: EdgeInsets.only(top:index==messageSnapshot.data.length-1?10.0:0.0),
                              child: Column(
                                children: [
                                  // Message Separator As Per Date
                                  // prevMessageDay != messageDay && prevformattedDate != formattedDate || index == 0
                                  prevMessageDay != curMessageDay && prevMessageDate != curMessageDate
                                  ?SystemMessageBadgeWidget(text: formattedCurDate+' '+'('+curMessageDay+')',msgType: 'date')
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
                                  ?SystemMessageBadgeWidget(text: messageSnapshot.data[index].text,msgType: '')
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
                                  :Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Column(
                                      crossAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId? CrossAxisAlignment.end:CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: currentSelectedIndex == index ? _messageCon.isVisibleMsgMenu.value : false,
                                          child:  Padding(padding: const EdgeInsets.only(bottom: 5),
                                            child: MessageMenuWidget(
                                              messageSnapshot: messageSnapshot, 
                                              index: index, 
                                              chatRoomId: widget.data.userId.toString(), 
                                              globalkey: null, 
                                              fbCollection: "contact-us", 
                                              forChatPage: 'inquiry',
                                              chatContext: context,
                                            ),
                                          ),
                                        ),
                                        StreamBuilder<User>(
                                          stream: FirestoreServices.getUserProfile(messageSnapshot.data[index].senderId.toString()),
                                          builder:(BuildContext context, AsyncSnapshot userInfo) {
                                            return 
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId? MainAxisAlignment.end:MainAxisAlignment.start,
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
                                                //Gap Between Profile and Message
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                //Message Column
                                                GestureDetector(
                                                  onLongPress: (){
                                                    setState(() {
                                                      _messageCon.isVisibleMsgMenu.value = true;
                                                      currentSelectedIndex = index;
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
                                                        padding: const EdgeInsets.only(left:4.0),
                                                        child:  userInfo.hasError || !userInfo.hasData
                                                        ?GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              _messageCon.inquiryChatTextCon.text = _messageCon.inquiryChatTextCon.text +' '+messageSnapshot.data[index].senderName;
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
                                                              _messageCon.inquiryChatTextCon.text = _messageCon.inquiryChatTextCon.text+' '+senderName;
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
                                                              if(jumpToIndex-index>5 || index>4){
                                                                _messageCon.showFloationButton();
                                                              }
                                                            },
                                                            child: MessageBubbleWidget(
                                                              senderId: messageSnapshot.data[index].senderId,
                                                              userId: _messageCon.userId.toString(),
                                                              child: StreamBuilder<Message>(
                                                                stream: FirestoreServices.replyMsgInquiryDetail(widget.data.userId.toString(),messageSnapshot.data[index].reply),
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
                                                                                        replyUserInfo.data.profileImageUrl,
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
                                                                                        ?SelectableText(
                                                                                          messageDetailSnapShot.data.senderName,
                                                                                          maxLines: 1,
                                                                                          style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                        )
                                                                                        : SelectableText(
                                                                                          replyUserInfo.data.nickname,
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
                                                                                        )
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            );
                                                                          }
                                                                        ),
                                                                        Divider(
                                                                          color:_messageCon.userId.toString() != messageSnapshot.data[index].senderId
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
                                                          //else show normal message
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
        //Reply Message Viewer
        Obx(()=>
          _messageCon.replyMsg.value==true
          ?ReplyMessageWidget(userId: widget.data.userId,fbCollectionName: "contact-us")
          :const SizedBox()
        ),
        //message textfield and send buttons
        MessageBar(data: widget.data, forPage: 'single')
      ],
    );
  }

  Widget chatSearchWidget(width,height){
    return 
    Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //Message List
        GetBuilder(
          init: MessageController(),
          builder: (_) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right:10.0),
                child: StreamBuilder<List<Message>>(
                  stream: FirestoreServices.getInquiryChatMessages(widget.data.userId.toString(),true),
                  builder:(BuildContext context, AsyncSnapshot messageSnapshot) {
                    if (messageSnapshot.hasError || !messageSnapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor)
                      );
                    } 
                    else{
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

                            //first message Condition
                            if(index==0){
                              if(index==0 && messageSnapshot.data.length==1){
                                prevMessageTime = messageSnapshot.data[index].datetime;
                              }
                              else{
                                prevMessageTime = messageSnapshot.data[index+1].datetime;
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

                            return Padding(
                              padding: EdgeInsets.only(top:index==messageSnapshot.data.length-1?10.0:0.0),
                              child: Column(
                                children: [
                                  // Message Separator As Per Date
                                  // prevMessageDay != messageDay && prevformattedDate != formattedDate || index == 0
                                  prevMessageDay != curMessageDay && prevMessageDate != curMessageDate
                                  ?SystemMessageBadgeWidget(text: formattedCurDate+' '+'('+curMessageDay+')',msgType: 'date')
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
                                  ?SystemMessageBadgeWidget(text: messageSnapshot.data[index].text,msgType: '')
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
                                      crossAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId? CrossAxisAlignment.end:CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: currentSelectedIndex == index ? _messageCon.isVisibleMsgMenu.value : false,
                                          child:  Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: MessageMenuWidget(
                                              messageSnapshot: messageSnapshot, 
                                              index: index, 
                                              chatRoomId: widget.data.userId.toString(), 
                                              globalkey: null, 
                                              fbCollection: "contact-us", 
                                              forChatPage: 'inquiry',
                                              chatContext: context,
                                            )
                                          ),
                                        ),
                                        StreamBuilder<User>(
                                          stream: FirestoreServices.getUserProfile(messageSnapshot.data[index].senderId.toString()),
                                          builder:(BuildContext context, AsyncSnapshot userInfo) {
                                            return 
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: _messageCon.userId.toString() == messageSnapshot.data[index].senderId
                                              ?MainAxisAlignment.end
                                              :MainAxisAlignment.start,
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
                                                //Gap Between Profile and Message
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                //Message Column
                                                GestureDetector(
                                                  onLongPress: (){
                                                    setState(() {
                                                      _messageCon.isVisibleMsgMenu.value = true;
                                                      currentSelectedIndex = index;
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
                                                        padding: const EdgeInsets.only(bottom:4.0),
                                                        child: userInfo.hasError || !userInfo.hasData
                                                        ?GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              _messageCon.inquiryChatTextCon.text = _messageCon.inquiryChatTextCon.text +' '+messageSnapshot.data[index].senderName;
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
                                                              _messageCon.inquiryChatTextCon.text = _messageCon.inquiryChatTextCon.text +' '+senderName;
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
                                                              if(jumpToIndex-index>5 || index>4){
                                                                _messageCon.showFloationButton();
                                                              }
                                                            },
                                                            child:MessageBubbleWidget(
                                                              senderId: messageSnapshot.data[index].senderId,
                                                              userId: _messageCon.userId.toString(),
                                                              child: StreamBuilder<Message>(
                                                                stream: FirestoreServices.replyMsgInquiryDetail(widget.data.userId.toString(),messageSnapshot.data[index].reply),
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
                                                                                        replyUserInfo.data.profileImageUrl,
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
                                                                                        ?SelectableText(
                                                                                          messageDetailSnapShot.data.senderName,
                                                                                          maxLines: 1,
                                                                                          style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                        )
                                                                                        :SelectableText(
                                                                                          replyUserInfo.data.nickname,
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
                                                                                      :
                                                                                      Theme(
                                                                                        data: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: primaryColor)),
                                                                                        child:Text(
                                                                                          messageDetailSnapShot.data.text,
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatReplyBlackContentStyle:chatReplyWhiteContentStyle,
                                                                                        )
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
                                                                          term: _messageCon.chatSearchTextController.text,
                                                                          textStyleHighlight: textHighlightStyle
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
                                                              text:messageSnapshot.data[index].text,
                                                              textStyle: _messageCon.userId.toString() != messageSnapshot.data[index].senderId?chatTextBlackHeaderStyle:chatTextWhiteHeaderStyle,
                                                              term: _messageCon.chatSearchTextController.text,
                                                              textStyleHighlight: textHighlightStyle
                                                            ),
                                                          ),
                                                          //Message Time if Others Message
                                                          _messageCon.userId.toString() != messageSnapshot.data[index].senderId
                                                          ? Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Column(
                                                              children: [
                                                                //Message menu
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
        //Reply Message Viewer
        Obx(()=>
          _messageCon.replyMsg.value==true
          ?ReplyMessageWidget(userId: widget.data.userId,fbCollectionName: "contact-us")
          :const SizedBox()
        ),
        const SearchResultCountAndButtonWidget(),
        //message textfield and send buttons
        MessageBar(data: widget.data,forPage: 'single')
      ],
    );
  }

}
