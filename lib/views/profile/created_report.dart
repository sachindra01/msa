import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/memberreport_controller.dart';

class CreatedReportPage extends StatefulWidget {
  const CreatedReportPage({Key? key}) : super(key: key);

  @override
  State<CreatedReportPage> createState() => _CreatedReportPageState();
}

class _CreatedReportPageState extends State<CreatedReportPage> {
  final MemberReportController _memCon = Get.find();
  var args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        backgroundColor: white,
        foregroundColor: black,
        title: const Text("活動日誌記入"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                '売上',
                style: formTitleStyle,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              initialValue:  args[0],
              decoration: const InputDecoration(
                prefixText: '¥  ',
                prefixStyle: TextStyle(color: black),
                border: InputBorder.none,
                enabled: false,
                filled: true,
                fillColor: white,
                hintText: "例）¥1,000,000",
                hintStyle: TextStyle(color: primaryColor),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                '粗利',
                style: formTitleStyle,
              ),
            ),
            TextFormField(
              initialValue:  args[1],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixText: '¥  ',
                prefixStyle: TextStyle(color: black),
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                enabled: false,
                hintText: '例）¥1,000,000',
                hintStyle: TextStyle(color: primaryColor),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                '販管費',
                style: formTitleStyle,
              ),
            ),
            TextFormField(
              initialValue: args[2],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixText: '¥  ',
                prefixStyle: TextStyle(color: black),
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                enabled: false,
                hintText: '例）¥1,000,000',
                hintStyle: TextStyle(color: primaryColor),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                '今月の感想',
                style: formTitleStyle,
              ),
            ),
            TextFormField(
              initialValue: args[3],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              maxLines: 8,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                enabled: false,
                hintStyle: TextStyle(color: primaryColor),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'もりもとらに聞きたいこと',
                style: formTitleStyle,
              ),
            ),
            TextFormField(
              initialValue: args[4],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              maxLines: 8,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                enabled: false,
                hintStyle: TextStyle(color: primaryColor),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                '来月の目標と一言',
                style: formTitleStyle,
              ),
            ),
            TextFormField(
              initialValue: args[5],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              maxLines: 8,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                enabled: false,
                hintStyle: TextStyle(color: primaryColor),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: white,
                child: ElevatedButton(
                  onPressed: () {
                    _memCon.saveMemberReport();
                  },
                  style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                  child: const Text("報告する"),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
