import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/constants.dart' as constants;
import 'package:msa/views/message/inquiryuser_list.dart';
const routeName = "/chat/chatinquiry";

class ChatInquiry extends StatefulWidget {
  const ChatInquiry({Key? key}) : super(key: key);

  @override
  State<ChatInquiry> createState() => _ChatInquiryState();
}

class _ChatInquiryState extends State<ChatInquiry> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - 300 -(MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        title: const Text("お問い合わせ"),
        backgroundColor: white,
        foregroundColor: black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //All/''
              GestureDetector(
                onTap: () {
                  Get.to(()=> const ChatInquiryUserList(fromPage: ''),
                  transition: Transition.rightToLeft);
                },
                child: SizedBox(
                  height: height * 0.2,
                  child: Card(
                    margin: const EdgeInsets.all(0.5),
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'すべて',
                            style: catTitleStyle,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['contactUsInfo']).snapshots(),
                          builder:(BuildContext context, AsyncSnapshot contactUsInfo) {
                            if (contactUsInfo.hasError || !contactUsInfo.hasData) {
                              return const Center(
                                child: SizedBox()
                              );
                            }
                            else{
                              return Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: contactUsInfo.data.docs.length != 0
                                ? CircleAvatar(
                                  backgroundColor: red,
                                  foregroundColor: white,
                                  radius: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                      contactUsInfo.data.docs.length>=100?'99+':contactUsInfo.data.docs.length.toString(),
                                      style: badgeCounterTextStyle,
                                    ),
                                  ),
                                )
                                : const SizedBox(),
                              );
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //1
              GestureDetector(
                onTap: () {
                  Get.to(()=> const ChatInquiryUserList(fromPage: '1'),
                  transition: Transition.rightToLeft);
                },
                child: SizedBox(
                  height: height * 0.2,
                  child: Card(
                    margin: const EdgeInsets.all(0.5),
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "要確認",
                            style: catTitleStyle,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['contactUsInfo']).snapshots(),
                          builder:(BuildContext context, AsyncSnapshot contactUsInfo) {
                            if (contactUsInfo.hasError || !contactUsInfo.hasData) {
                              return const Center(
                                child: SizedBox()
                              );
                            }
                            else{
                              int chatStatus1 = 0;
                              for (var i = 0; i < contactUsInfo.data.docs.length; i++) {
                                if(contactUsInfo.data.docs[i]['chat_status']==1){
                                  chatStatus1++;
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: chatStatus1!=0
                                ?CircleAvatar(
                                  backgroundColor: red,
                                  foregroundColor: white,
                                  radius: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      chatStatus1>=100?'99+':chatStatus1.toString(),
                                      style: badgeCounterTextStyle,
                                    ),
                                  ),
                                )
                                :const SizedBox(),
                              );
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //2
              GestureDetector(
                onTap: () {
                  Get.to(()=> const ChatInquiryUserList(fromPage: '2'),
                  transition: Transition.rightToLeft);
                },
                child: SizedBox(
                  height: height * 0.2,
                  child: Card(
                    margin: const EdgeInsets.all(0.5),
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "未返信",
                            style: catTitleStyle,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['contactUsInfo']).snapshots(),
                          builder:(BuildContext context, AsyncSnapshot contactUsInfo) {
                            if (contactUsInfo.hasError || !contactUsInfo.hasData) {
                              return const Center(
                                child: SizedBox()
                              );
                            }
                            else{
                              int chatStatus2 = 0;
                              for (var i = 0; i < contactUsInfo.data.docs.length; i++) {
                                if(contactUsInfo.data.docs[i]['chat_status']==2){
                                  chatStatus2++;
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: chatStatus2!=0
                                ?CircleAvatar(
                                  backgroundColor: red,
                                  foregroundColor: white,
                                  radius: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      chatStatus2>=100?'99+':chatStatus2.toString(),
                                      style: badgeCounterTextStyle,
                                    )
                                  ),
                                )
                                : const SizedBox(),
                              );
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //3
              GestureDetector(
                onTap: () {
                  Get.to(()=> const ChatInquiryUserList(fromPage: '3'),
                  transition: Transition.rightToLeft);
                },
                child: SizedBox(
                  height: height * 0.2,
                  child: Card(
                    margin: const EdgeInsets.all(0.5),
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "確認済",
                            style: catTitleStyle,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['contactUsInfo']).snapshots(),
                          builder:(BuildContext context, AsyncSnapshot contactUsInfo) {
                            if (contactUsInfo.hasError || !contactUsInfo.hasData) {
                              return const Center(
                                child: SizedBox()
                              );
                            }
                            else{
                              int chatStatus3 = 0;
                              for (var i = 0; i < contactUsInfo.data.docs.length; i++) {
                                if(contactUsInfo.data.docs[i]['chat_status']==3){
                                  chatStatus3++;
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: chatStatus3!=0
                                ?CircleAvatar(
                                  backgroundColor: red,
                                  foregroundColor: white,
                                  radius: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      chatStatus3>=100?'99+':chatStatus3.toString(),
                                      style: badgeCounterTextStyle,
                                    )
                                  ),
                                )
                                : const SizedBox(),
                              );
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //4
              GestureDetector(
                onTap: () {
                  Get.to(()=> const ChatInquiryUserList(fromPage: '4'),
                  transition: Transition.rightToLeft);
                },
                child: SizedBox(
                  height: height * 0.2,
                  child: Card(
                    margin: const EdgeInsets.all(0.5),
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "トラブル",
                            style: catTitleStyle,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['contactUsInfo']).snapshots(),
                          builder:(BuildContext context, AsyncSnapshot contactUsInfo) {
                            if (contactUsInfo.hasError || !contactUsInfo.hasData) {
                              return const Center(
                                child: SizedBox()
                              );
                            }
                            else{
                              int chatStatus4 = 0;
                              for (var i = 0; i < contactUsInfo.data.docs.length; i++) {
                                if(contactUsInfo.data.docs[i]['chat_status']==4){
                                  chatStatus4++;
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: chatStatus4!=0
                                ?CircleAvatar(
                                  backgroundColor: red,
                                  foregroundColor: white,
                                  radius: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      chatStatus4>=100?'99+':chatStatus4.toString(),
                                      style: badgeCounterTextStyle,
                                    )
                                  ),
                                )
                                : const SizedBox(),
                              );
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
