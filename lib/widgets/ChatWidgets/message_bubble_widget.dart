import 'package:flutter/material.dart';
import 'package:msa/common/styles.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({Key? key,required this.child,required this.userId,required this.senderId}) : super(key: key);
  final dynamic child;
  final String userId;
  final String senderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width*0.6,
        minWidth: MediaQuery.of(context).size.width*0.1
      ),
      decoration: BoxDecoration(
        color: userId != senderId?white:primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(12.0),
          topLeft: userId == senderId ? const Radius.circular(12.0):const Radius.circular(0),
          topRight: userId == senderId?const Radius.circular(0):const Radius.circular(12),
          bottomRight: const Radius.circular(12.0),
        ),
        boxShadow:[
          BoxShadow(
            color: Colors.white.withOpacity(0.2), //New
            blurRadius: 1.0,
            offset: const Offset(-0, 2))
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: child
    );
  }
}