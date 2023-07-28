import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/views/message/host_activity_report.dart';


class ReportRepliedPage extends StatefulWidget {
  const ReportRepliedPage({Key? key}) : super(key: key);

  @override
  State<ReportRepliedPage> createState() => _ReportRepliedPageState();
}

class _ReportRepliedPageState extends State<ReportRepliedPage> {
  var args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
         Get.off(
            () => const HostActivityReport(),
            arguments: args);
        return true;
      },
      child: Scaffold(
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
            
            const  Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text("  活動日誌を回答しました！", style: inquiryTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: white,
                child: ElevatedButton(
                  onPressed: () {
                    // Get.back();
                    Get.off(
                      () => const HostActivityReport(),
                      arguments: args);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                  child: const Text("戻る"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
