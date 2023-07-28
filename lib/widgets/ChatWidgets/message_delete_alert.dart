import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/services/firestore_services.dart';

class MessageDeleteAlert extends StatefulWidget {
  const MessageDeleteAlert({Key? key,required this.doc1,required this.doc2,required this.collection,required this.lastMsgText}) : super(key: key);
  final String doc1;
  final String doc2;
  final String collection;
  final dynamic lastMsgText;

  @override
  State<MessageDeleteAlert> createState() => _MessageDeleteAlertState();
}

class _MessageDeleteAlertState extends State<MessageDeleteAlert> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
         width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '送信を取り消します',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Yes
                  SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width/5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: lightgrey,elevation: 1),
                      onPressed: () async {
                        if(widget.collection=='chatRoom'){
                          FirestoreServices.deleteMessageChatRoom(docId1: widget.doc1.toString(), docId2: widget.doc2.toString());
                          if(widget.lastMsgText!=null){
                            FirestoreServices.setLastMessageChatRoomInfo(
                              groupId: widget.doc1.toString(), 
                              lastMessage: widget.lastMsgText
                            );
                          }
                        }
                        else if(widget.collection=='contactUs'){
                          FirestoreServices.deleteMessageContactUs(docId1: widget.doc1.toString(), docId2: widget.doc2.toString());
                        }
                        Get.back();
                      },
                      child: const Text(
                        'はい',
                        style: TextStyle(color: black,fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 20,
                  ),
                  //No
                  SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width/5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: white,elevation: 0.3),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'いいえ',
                        style: TextStyle(color: black,fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
