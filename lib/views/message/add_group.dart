import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/constants.dart' as constants;
import 'package:msa/controller/message_controller.dart';
import 'package:msa/views/message/group_detail.dart';
import '../../models/chatmodels/chat_room_info.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  final MessageController _messageCon = Get.put(MessageController());

  @override
  void initState() {
    super.initState();
    setState(() {
      _messageCon.searchText ="";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "グループの追加",
            style: catTitleStyle,
          ),
          backgroundColor: white,
          leading: const BackButton(
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: const Icon(Icons.search, color: black),
                  disabledBorder: OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(color: grey),
                  hintText: "検索",
                  fillColor: Colors.black12
                ),
                onChanged: (text){
                  setState(() {
                    _messageCon.searchText = text.trim();
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(constants.firebaseCollection['chatRoomInfo'])
                .where("delete_flg",isEqualTo: false)
                .where("status",isEqualTo: true)
                .orderBy("id",descending: true)
                .snapshots(),
                builder:(BuildContext context, AsyncSnapshot chatRoomInfoDetailSnapShot) {
                  if (chatRoomInfoDetailSnapShot.hasError || !chatRoomInfoDetailSnapShot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryColor)
                    );
                  }
                  else{
                    return ListView.builder(
                      padding: const EdgeInsets.only(top:5.0,bottom:8.0,left:14.0,right:8.0),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: chatRoomInfoDetailSnapShot.data.docs.length,
                      itemBuilder: (BuildContext context, int index){
                        //not show groups in add group page if already a member
                        if(chatRoomInfoDetailSnapShot.data.docs[index].data().containsKey('members')){
                          if(chatRoomInfoDetailSnapShot.data.docs[index]["members"].length!=0){
                            if(chatRoomInfoDetailSnapShot.data.docs[index]["members"] is List){
                              if(chatRoomInfoDetailSnapShot.data.docs[index]["members"].contains(_messageCon.userId)){
                                return const SizedBox();
                              }
                            }
                            else if(chatRoomInfoDetailSnapShot.data.docs[index]["members"] is Map)
                            {
                              if(chatRoomInfoDetailSnapShot.data.docs[index]["members"].containsValue(_messageCon.userId)){
                                return const SizedBox();
                              }
                            }
                          }
                        }
                        if(_messageCon.searchText!=''){
                          if(chatRoomInfoDetailSnapShot.data.docs[index]["title"].toLowerCase().contains(_messageCon.searchText)){
                            return Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Get.to(()=>GroupDetail(groupData: chatRoomInfoDetailSnapShot.data.docs[index],alreadyMember: 'no'),transition: Transition.rightToLeftWithFade);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 26,
                                            backgroundColor:primaryColor,
                                            child: CircleAvatar(
                                              backgroundColor: white,
                                              backgroundImage: NetworkImage(chatRoomInfoDetailSnapShot.data.docs[index]["image_url"]),
                                              radius: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 20.0),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width*0.6,
                                                child: Text(
                                                  chatRoomInfoDetailSnapShot.data.docs[index]["title"]??'',
                                                  style: grouptitleStyle,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width*0.6,
                                                child: Text(
                                                  chatRoomInfoDetailSnapShot.data.docs[index]["description"]??'',
                                                  maxLines: 1,
                                                  style: groupSubTitleStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: const [
                                          CircleAvatar(
                                            backgroundColor: blogCountTextColor,
                                            radius: 10.0,
                                            child: Icon(
                                              Icons.add,
                                              size: 16,
                                              color: white,
                                            ),
                                          ),
                                          SizedBox(width: 10.0)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14.0),
                              ],
                            );
                          }
                          else{
                            return const SizedBox();
                          }
                        }
                        //Search condition is empty
                        else{
                          return Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  Get.to(()=>GroupDetail(groupData: ChatRoomInfo.fromDocumentSnapshot(doc: chatRoomInfoDetailSnapShot.data.docs[index]),alreadyMember: 'no'),transition: Transition.rightToLeft);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 26,
                                          backgroundColor: primaryColor,
                                          child: CircleAvatar(
                                            backgroundColor: white,
                                            backgroundImage: NetworkImage(chatRoomInfoDetailSnapShot.data.docs[index]["image_url"]),
                                            radius: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 20.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*0.6,
                                              child: Text(
                                                chatRoomInfoDetailSnapShot.data.docs[index]["title"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: grouptitleStyle,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*0.6,
                                              child: Text(
                                                chatRoomInfoDetailSnapShot.data.docs[index]["description"],
                                                maxLines: 1,
                                                style: groupSubTitleStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        CircleAvatar(
                                          backgroundColor: blogCountTextColor,
                                          radius: 10.0,
                                          child: Icon(
                                            Icons.add,
                                            size: 16,
                                            color: white,
                                          ),
                                        ),
                                        SizedBox(width: 10.0)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14.0),
                            ],
                          );
                        }
                      },
                    );
                  } 
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
