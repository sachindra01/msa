// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/memberreport_controller.dart';
import 'package:msa/views/message/host_activity_report.dart';
import 'package:msa/views/pages/report_repliedpage.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/toast_message.dart';


class HostActivityReportDetail extends StatefulWidget {
  final data;
  const HostActivityReportDetail({Key? key, required this.data})
      : super(key: key);

  @override
  State<HostActivityReportDetail> createState() =>
      _HostActivityReportDetailState();
}

class _HostActivityReportDetailState extends State<HostActivityReportDetail> {
  final MemberReportController _con = Get.put(MemberReportController());
  final _txtcon = TextEditingController();
  final _options = ["未返信", "要対応", "確認済"];
  final _options2 = [ "要対応", "確認済"];
  var _currentSelectedValue;
  @override
  void initState() {
    _currentSelectedValue = widget.data[0].label;
    _con.earning =widget.data[0].earning ?? '0';
    _con.grossProfit =widget.data[0].grossProfit ?? '0';
    _con.expenses = widget.data[0].expenses ?? '0';
    _txtcon.text = widget.data[0].nextMonthGoalReply ?? '';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    txt(label){
    if(label == '未返信'){
      return "new";
    }else if(label == '要対応'){
      return "hold";
    } else if(label == '確認済'){
      return "replied";
    }return "0";
  }



    return WillPopScope(
      onWillPop: () async {
        Get.off(() => const HostActivityReport(), 
          arguments: widget.data[1]
        );
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
                initialValue: widget.data[0].earning != null ? NumberFormat.decimalPattern().format(int.parse( widget.data[0].earning)) : '',
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
                initialValue: widget.data[0].grossProfit != null ? NumberFormat.decimalPattern().format(int.parse( widget.data[0].grossProfit)) : '',
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
                initialValue: widget.data[0].expenses != null ? NumberFormat.decimalPattern().format(int.parse( widget.data[0].expenses)) :'' ,
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
                initialValue: widget.data[0].monthGoal ?? '',
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
                initialValue: widget.data[0].askHost ?? '',
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
                initialValue: widget.data[0].nextMonthGoal ?? '',
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
                controller: _txtcon,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                maxLines: 4,
                style: const TextStyle(color: red),
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
                  'ステータス',
                  style: formTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: const InputDecoration(
                        border:  OutlineInputBorder(),
                        filled: true,
                        fillColor: white,
                        hintStyle: TextStyle(color: primaryColor),
                      ),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        
                        child: DropdownButton<String>(
                    
                          value: _currentSelectedValue == '' ? widget.data[0].label : _currentSelectedValue,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              _currentSelectedValue = newValue!;
                              _con.reportStatus = txt(_currentSelectedValue);
                              state.didChange(newValue);
                            });
                          },
                          items: _currentSelectedValue == '未返信' 
                          ? _options.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: value == _currentSelectedValue
                              ? Text(value, style: const TextStyle(color: primaryColor,fontWeight: FontWeight.w600),)
                              : Text(value)
                            );
                          }).toList()
                         :_options2.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: value == _currentSelectedValue
                              ? Text(value, style: const TextStyle(color: primaryColor,fontWeight: FontWeight.w600),)
                              : Text(value)
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext ctx){
                            return _currentSelectedValue == '未返信' 
                          ? _options.map((String value) {
                            return Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.32,right: 10),child: Text(_currentSelectedValue,style: const TextStyle(color: primaryColor, fontSize: 16,fontWeight: FontWeight.w600),),);
                          }).toList()
                         :_options2.map((String value) {
                            return Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.32,right: 10), child: Text(_currentSelectedValue ,style: const TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w600),),);
                          }).toList();
                          } ,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: white,
                  child: Obx(()=> _con.isLoading.value == true 
                    ?Center(child: loadingWidget()) 
                    :ElevatedButton(
                      onPressed: () {
                        if(_currentSelectedValue == "未返信"){
                          showToastMessage("ステータスを選択");
                        }else{
                        _con.nextMonthGoalReply = _txtcon.text;
                        _con.postHostReply(widget.data[0].id).then((value){
                          Get.off(() => const ReportRepliedPage(),
                          arguments: widget.data[1]);
                          
                        });}
                      
                      },
                      style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                      child: const Text("保存する"),
                  ),)
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
