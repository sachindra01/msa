import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:msa/common/styles.dart';

const routeName = "/chat/userList";

class ChatUserList extends StatefulWidget {
  const ChatUserList({Key? key}) : super(key: key);

  @override
  State<ChatUserList> createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/data/chatuserlist.json'),
        builder: (context, snapshot) {
          var responseData = json.decode(snapshot.data.toString());
          return Scaffold(
            appBar: AppBar(
              backgroundColor: pagesAppbar,
              foregroundColor: black,
              title: const Text(
                "知らせ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                  itemCount: responseData['data'].length,
                  itemBuilder: ((context, index) {
                    var userData = responseData['data'][index];
                    return Card(
                      margin: const EdgeInsets.all(0.5),
                      elevation: 5,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: primaryColor,
                              child: CircleAvatar(
                                backgroundColor: white,
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(userData['image_url']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              width: width * 0.5,
                              child: Text(
                                userData['nickname'],
                                maxLines: 2,
                                style: catTitleStyle,
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.06,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                color: buttonLightColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              userData['label'],
                              style: reportTitleStyle,
                            )),
                          ),
                        ],
                      ),
                    );
                  })),
            ),
          );
        });
  }
}
