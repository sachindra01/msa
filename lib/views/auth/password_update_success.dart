import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:msa/common/styles.dart';

class PasswordChangeSuccess extends StatelessWidget {
  const PasswordChangeSuccess({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "パスワード変更",
          style: TextStyle(fontSize: 16.0),
        ),
        foregroundColor: black,
        backgroundColor: white,
        actions: const [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "パスワードが変更されました。",
              style: inquiryTextStyle,
            ),
          ),
          
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: white,
              child: ElevatedButton(
                onPressed: () {
                  
                Get.back();
                FocusManager.instance.primaryFocus?.unfocus();
                },
                style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                child: const Text("戻る"),
              ),
            ),
          )
        ],
      ),
    );
  }
}