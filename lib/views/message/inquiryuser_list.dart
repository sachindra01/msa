import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/constants.dart' as constants;
import 'package:msa/controller/message_controller.dart';
import 'package:msa/models/chatmodels/contact_us_info.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:msa/views/message/inquiry_chat_page.dart';

const routeName = "/chat/inquiryuserList";
class ChatInquiryUserList extends StatefulWidget {
  final String fromPage;
  const ChatInquiryUserList({Key? key,required this.fromPage}) : super(key: key);
  @override
  State<ChatInquiryUserList> createState() => _ChatInquiryUserListState();
}

class _ChatInquiryUserListState extends State<ChatInquiryUserList> {
  final MessageController _messageCon = Get.put(MessageController());
  final _options = ["1", "2", "3", "4"];
  List<String> currentSelectedValue = [];

  @override
  void initState() {
    setState(() {
      _messageCon.inquirySearchUserTextCon.text = '';
      _messageCon.inquirySearchText = '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pagesAppbar,
          foregroundColor: black,
          title: const Text(
            "お問い合わせ一覧",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.95,
                child: TextFormField(
                  controller: _messageCon.inquirySearchUserTextCon,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(27.5),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: black,
                    ),
                    fillColor: activityDivider,
                    hintText: '検索',
                    hintStyle: const TextStyle(color: grey),
                    contentPadding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: primaryColor, width: 2.0)
                    ),
                  ),
                  onChanged: (text){
                    setState(() {
                      _messageCon.inquirySearchText = text.trim();
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['contactUsInfo']).snapshots(),
                  builder:(BuildContext context, AsyncSnapshot contactUsInfo) {
                    if (contactUsInfo.hasError || !contactUsInfo.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor)
                      );
                    }
                    else{
                      return ListView.separated(
                        padding: const EdgeInsets.only(top:10.0,bottom:8.0,left:14.0,right:8.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: contactUsInfo.data.docs.length,
                        separatorBuilder: (BuildContext context, int index) { 
                          return const SizedBox(height: 1.0);
                        }, 
                        itemBuilder: (BuildContext context, int dataIndex) {
                          var userData = ContactUsInfo.fromDocumentSnapshot(doc: contactUsInfo.data.docs[dataIndex]);
                          //widget.fromPage => 1,2,3,4 chat status
                          //userData.chatStatus.toString()==widget.fromPage filter as per chat status
                          if(widget.fromPage == ''|| userData.chatStatus.toString()==widget.fromPage){
                            //Search Text not Empty
                            if(_messageCon.inquirySearchText!=''){
                              if(userData.nickName!.toLowerCase().contains(_messageCon.inquirySearchText)){
                                return InkWell(
                                  onTap: () async{
                                    FirestoreServices.updateHostUnreadCount(type: 'decrement', userId: contactUsInfo.data.docs[dataIndex].id.toString());
                                    Get.to(()=> InquiryChatPage(
                                      data: userData, 
                                      fromPage: widget.fromPage,
                                      title:userData.nickName.toString()
                                    ),
                                    transition: Transition.rightToLeft);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: primaryColor,
                                          child: CircleAvatar(
                                            backgroundColor: white,
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              userData.profileImageUrl!
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.3,
                                          child: Text(
                                            userData.nickName!,
                                            maxLines: 1,
                                            style: catTitleStyle,
                                          ),
                                        ),
                                        userData.hostUnreadMessage.toString()!='0'
                                        ?Badge(
                                          badgeContent: Text(
                                            int.parse(userData.hostUnreadMessage.toString())>=100
                                            ?'99+'
                                            :userData.hostUnreadMessage.toString(),
                                            style: badgeCounterTextStyle
                                          ),
                                        )
                                        :const SizedBox(),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          width: width * 0.25,
                                          child: FormField<String>(
                                            builder: (FormFieldState<String> state) {
                                              currentSelectedValue.clear();
                                              if(currentSelectedValue.length<dataIndex){
                                                for (var i = 0; i <= dataIndex; i++) {
                                                  currentSelectedValue.add(userData.chatStatus!);    
                                                }  
                                              }else{
                                                currentSelectedValue.add(userData.chatStatus!);
                                              }
                                              return InputDecorator(
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintStyle: TextStyle(color: primaryColor),
                                                  contentPadding: EdgeInsets.zero
                                                ),
                                                isEmpty: currentSelectedValue.isEmpty,
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
                                                    value: currentSelectedValue.isEmpty
                                                      ? userData.chatStatus
                                                      : currentSelectedValue[dataIndex],
                                                    isDense: false,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        currentSelectedValue[dataIndex] = newValue!;
                                                        state.didChange(newValue);
                                                      });
                                                      FirestoreServices.editInquiryChatStatus(docId: userData.userId!, chatStatus: int.parse(newValue!));
                                                    },
                                                    items: _options.map((String value) {
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
                                      ],
                                    ),
                                  ),
                                );
                              }
                              else{
                                return const SizedBox();
                              }
                            }
                            //Search Text Empty
                            else{
                              return InkWell(
                                onTap: () {
                                  FirestoreServices.updateHostUnreadCount(type: 'decrement', userId: contactUsInfo.data.docs[dataIndex].id.toString());
                                  Get.to(()=> InquiryChatPage(
                                      data: userData, 
                                      fromPage: widget.fromPage,
                                      title:userData.nickName.toString()
                                    ),
                                    transition: Transition.rightToLeft
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundColor: primaryColor,
                                        child: CircleAvatar(
                                          backgroundColor: white,
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            userData.profileImageUrl!
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.3,
                                        child: Text(
                                          userData.nickName.toString(),
                                          maxLines: 1,
                                          style: catTitleStyle,
                                        ),
                                      ),
                                      userData.hostUnreadMessage.toString()!='0'
                                      ? Badge(
                                        badgeContent: Text(
                                          int.parse(userData.hostUnreadMessage!)>=100
                                          ?'99+'
                                          :userData.hostUnreadMessage.toString(),
                                          style: badgeCounterTextStyle
                                        ),
                                      )
                                      :const SizedBox(),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        width: width * 0.25,
                                        child: FormField<String>(
                                          builder: (FormFieldState<String> state) {
                                            currentSelectedValue.clear();
                                            if(currentSelectedValue.length<dataIndex){
                                              for (var i = 0; i <= dataIndex; i++) {
                                                currentSelectedValue.add(userData.chatStatus.toString());    
                                              }  
                                            }else{
                                              currentSelectedValue.add(userData.chatStatus.toString());
                                            }
                                            return InputDecorator(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintStyle: TextStyle(color: primaryColor),
                                                contentPadding: EdgeInsets.zero
                                              ),
                                              isEmpty: currentSelectedValue.isEmpty,
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
                                                  value: currentSelectedValue.isEmpty
                                                    ? userData.chatStatus
                                                    : currentSelectedValue[dataIndex],
                                                  isDense: false,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      currentSelectedValue[dataIndex] = newValue!;
                                                      state.didChange(newValue);
                                                    });
                                                    FirestoreServices.editInquiryChatStatus(docId: userData.userId!, chatStatus: int.parse(newValue!));
                                                  },
                                                  items: _options.map((String value) {
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
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                          else{
                            return const SizedBox();
                          }
                        },
                      );
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
