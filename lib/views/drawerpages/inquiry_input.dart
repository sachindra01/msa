import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/controller/inquiry_controller.dart';

import '../../common/styles.dart';
import '../../widgets/loading_widget.dart';

class InquiryInput extends StatefulWidget {
  const InquiryInput({Key? key}) : super(key: key);

  @override
  State<InquiryInput> createState() => _InquiryInputState();
}

class _InquiryInputState extends State<InquiryInput> {
  var args = Get.arguments;
  final InquiryController _con = Get.put(InquiryController());
  bool isChecked = false;

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
        appBar: AppBar(
          title: const Text(
            "お問い合わせ 入力内容確認",
            style: TextStyle(fontSize: 16.0),
          ),
          foregroundColor: black,
          backgroundColor: white,
          actions: const [],
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "お問い合わせ種類 :",
                  style: catTitleStyle,
                ),
                Text(
                  _con.topic = args[0],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                const Text(
                  "お問い合わせ内容 :",
                  style: catTitleStyle,
                ),
                Text(
                  _con.comment = args[1],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: transparent,
                    child:Obx(()=>  ElevatedButton(
                      onPressed: () {
                        _con.inquiry();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      style:
                          ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                      child:  _con.isLoading.value == true
                      ? Center(
                        child: loadingWidget(white),
                      )
                      : const  Text("送信する"),
                    ),)
                  ),
                )
              ],
            )),
      ),
    );
  }
}
