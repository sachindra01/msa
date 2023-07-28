import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';

class SearchResultCountAndButtonWidget extends StatefulWidget {
  const SearchResultCountAndButtonWidget({Key? key}) : super(key: key);

  @override
  State<SearchResultCountAndButtonWidget> createState() => _SearchResultCountAndButtonWidgetState();
}

class _SearchResultCountAndButtonWidgetState extends State<SearchResultCountAndButtonWidget> {
  final MessageController _messageCon = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MessageController(),
      builder: (_) { 
        return _messageCon.chatSearchTextController.text!=''
        ?Container(
          color: grey.withOpacity(0.5),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left:20.0,right: 20.0,bottom: 10.0,top: 10.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        _messageCon.jumpUp();
                      }, 
                      icon: const Icon(
                        Icons.keyboard_arrow_up,
                        size: 30.0,
                      )
                    ),
                    const SizedBox(width: 20.0),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        _messageCon.jumpDown();
                      }, 
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 30.0,
                      )
                    ),
                  ],
                ),
                Text((_messageCon.currentSearchJumpIndex+1).toString()+'/'+_messageCon.totalSearchResult.value.toString()),
              ],
            ),
          ),
        )
        :const SizedBox();
      }
    );
  }
}