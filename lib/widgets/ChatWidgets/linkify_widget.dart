import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';

class LinkifyWidget extends StatelessWidget {
  LinkifyWidget({Key? key,required this.text,required this.userId,required this.senderId}) : super(key: key);
  final String text;
  final String userId;
  final String senderId;
  final MessageController _messageCon = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: primaryColor)),
      child: Linkify(
        text: text,
        style: userId != senderId?chatTextBlackHeaderStyle:chatTextWhiteHeaderStyle,
        textScaleFactor : 0.9,
        options: const LinkifyOptions(humanize: true),
        linkStyle: const TextStyle(color: linkColor),
        onOpen: _messageCon.onOpen,
        strutStyle: const StrutStyle(
          forceStrutHeight: true
        ),
      ),
    );
  }
}