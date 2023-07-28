import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/memberreport_controller.dart';
import 'package:msa/views/profile/activityreport_list.dart';

class ActivityReportDetail extends StatefulWidget {
  
  // ignore: prefer_typing_uninitialized_variables
  final data;

  static const routeName = '/activitydetail';
  const ActivityReportDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<ActivityReportDetail> createState() => _ActivityReportDetailState();
}

class _ActivityReportDetailState extends State<ActivityReportDetail> {
  final MemberReportController _memCon = Get.put(MemberReportController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(()=> const ActivityReportPage());
       return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
          backgroundColor: white,
          foregroundColor: black,
          title: const Text("活動報告"),
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
                initialValue: NumberFormat.decimalPattern().format(int.parse( widget.data.earning)),
                textInputAction: TextInputAction.next,
                readOnly: true,
                decoration: const InputDecoration(
                  prefixText: '¥  ',
                  prefixStyle: TextStyle(color: black),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: white,
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
                keyboardType: TextInputType.emailAddress,
                initialValue: NumberFormat.decimalPattern().format(int.parse( widget.data.grossProfit)),
                textInputAction: TextInputAction.next,
                readOnly: true,
                decoration: const InputDecoration(
                  prefixText: '¥  ',
                  prefixStyle: TextStyle(color: black),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: white,
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
                keyboardType: TextInputType.emailAddress,
                initialValue: widget.data.expenses == null ? '' : NumberFormat.decimalPattern().format(int.parse( widget.data.expenses)),
                textInputAction: TextInputAction.next,
                readOnly: true,
                decoration: const InputDecoration(
                  prefixText: '¥  ',
                  prefixStyle: TextStyle(color: black),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: white,
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
                keyboardType: TextInputType.emailAddress,
                initialValue: widget.data.monthGoal,
                textInputAction: TextInputAction.next,
                readOnly: true,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: white,
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
                keyboardType: TextInputType.emailAddress,
                initialValue: widget.data.askHost,
                textInputAction: TextInputAction.next,
                readOnly: true,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: white,
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
                keyboardType: TextInputType.emailAddress,
                initialValue: widget.data.nextMonthGoal,
                textInputAction: TextInputAction.next,
                readOnly: true,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: white,
                  hintStyle: TextStyle(color: primaryColor),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'もりもとらからの回答',
                  style: formTitleStyle,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                initialValue: widget.data.nextMonthGoalReply,style: const TextStyle(color: red),
                textInputAction: TextInputAction.next,
                readOnly: true,
                maxLines: 4,
                decoration: const InputDecoration(
                  
                  border: InputBorder.none,
                  filled: true,
                  fillColor: white,
                  hintStyle: TextStyle(color: red),
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
                      // Get.back();
                      !widget.data.clientReplySeen && widget.data.reportStatus == "replied"
                            ? _memCon.clientReportSeen(widget.data.id)
                            : Get.off(()=> const ActivityReportPage()); 
                            
                              
                            
                    },
                    style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                    child: widget.data.reportStatus == "replied" &&  !widget.data.clientReplySeen
                              ? const Text("確認しました ")
                              : const Text("閉じる ")
                              
                   // child:   widget.data.clientReplySeen!  && widget.data.label == "確認済"  ? const Text("確認しました ") :
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
