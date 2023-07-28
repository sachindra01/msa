import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:msa/common/styles.dart';

class SystemMessageBadgeWidget extends StatelessWidget {
  const SystemMessageBadgeWidget({Key? key,required this.text,required this.msgType}) : super(key: key);
  final String text;
  final String msgType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:10.0),
      child: Badge(
        toAnimate: false,
        shape: BadgeShape.square,
        badgeColor: grey,
        borderRadius: BorderRadius.circular(10),
        position: BadgePosition.center(),
        padding: const EdgeInsets.all(6.0),
        elevation: 1.0,
        alignment: Alignment.center,
        badgeContent: Text(
          text,
          textAlign: TextAlign.center,
          style: chatSystemMessageWhiteStyle,
        ),
      ),
    );
  }
}