import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/models/chatmodels/user.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:substring_highlight/substring_highlight.dart';
class SearchResultPage extends StatefulWidget {
  final dynamic messages;
  const SearchResultPage({ Key? key ,required this.messages}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}
class _SearchResultPageState extends State<SearchResultPage> {
  final MessageController _messageCon = Get.put(MessageController());
  var messageList = [];
  var total = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    messageList.clear();
    _messageCon.totalSearchResult.value=0;
    _messageCon.searchResultIndex.clear();
    total=0;
    for (var i = 0; i < widget.messages.length; i++) {
      if(widget.messages[i].systemMessage!="true"){
        if(widget.messages[i].files.length==0){
          if(_messageCon.chatSearchTextController.text!=''){
            if(widget.messages[i].text.contains(_messageCon.chatSearchTextController.text)){
              total+=1;
              _messageCon.searchResultIndex.add(i);
              messageList.add(widget.messages[i]);
            }
          }
          else{
            messageList.add(widget.messages[i]);
          }
        }
      }
    }
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) { 
        return const SizedBox(height: 24.0);
      },
      padding: const EdgeInsets.all(10.0),
      itemCount: messageList.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (ctx, int index) {
        WidgetsBinding.instance?.addPostFrameCallback((_){
          setState(() {
            _messageCon.totalSearchResult.value = total;
          });
        });
        return StreamBuilder<User>(
          stream: FirestoreServices.getUserProfile(messageList[index].senderId.toString()),
          builder:(BuildContext context, AsyncSnapshot userInfo) {
            return InkWell(
              onTap: ()async{
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                setState(() {
                  _messageCon.searchInChat.value = true;
                });
                Future.delayed(const Duration(seconds: 1), () {
                  _messageCon.jumpToIndex(_messageCon.searchResultIndex[index],index);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40, 
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkimage(
                        height: 40, 
                        width: 40,
                        imageUrl: userInfo.hasError || !userInfo.hasData
                        ?messageList[index].senderProfileImageURl
                        :userInfo.data.profileImageUrl,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userInfo.hasError || !userInfo.hasData
                        ?Text(messageList[index].senderName)
                        :Text(userInfo.data.nickname=="null"||userInfo.data.nickname==""?messageList[index].senderName:userInfo.data.nickname),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SubstringHighlight(
                                term: _messageCon.chatSearchTextController.text,
                                text: messageList[index].text,
                                textAlign: TextAlign.start,
                                textStyle: chatSystemMessageBlackStyle,
                                textStyleHighlight: textHighlightStyle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 500,
                              ),
                            ),
                            Text(DateFormat.Hm().format(messageList[index].datetime).toString(),style: chatDateeStyle),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}