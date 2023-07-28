import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/views/drawerpages/inquirypage.dart';
import 'package:msa/widgets/bottom_navigation.dart';

class InquirySuccessPage extends StatefulWidget {
  const InquirySuccessPage({Key? key}) : super(key: key);

  @override
  State<InquirySuccessPage> createState() => _InquirySuccessPageState();
}

class _InquirySuccessPageState extends State<InquirySuccessPage> {
  
    var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var isPremium = box.read('isPremium');
    var memberType = box.read('memberType');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "お問い合わせ完了",
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
              "お問い合わせいただき",
              style: inquiryTextStyle,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(" ありがとうございました。", style: inquiryTextStyle),
          ),
          const SizedBox(
            height: 50,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(" 折り返し、担当者より", style: inquiryTextStyle),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("ご連絡いたしますので、恐れ入りますが、", style: inquiryTextStyle),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("しばらくお待ちください。", style: inquiryTextStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: white,
              child: ElevatedButton(
                onPressed: () {
                  isPremium || memberType == 'host' ? Get.off(()=>const BottomNavigation()) : Get.off(()=>const InquiryPage());
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
