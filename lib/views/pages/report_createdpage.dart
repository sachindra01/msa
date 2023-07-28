import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/widgets/bottom_navigation.dart';

class ReportCreatedPage extends StatelessWidget {
  const ReportCreatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "活動日誌記",
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
          
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: const  [
                Text(" 活動日誌報告完了しました！", style: inquiryTextStyle),
                Text(" もりもとらからの回答をお待ちください！", style: inquiryTextStyle),
              ],
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
                  Get.off(()=>const BottomNavigation());
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
