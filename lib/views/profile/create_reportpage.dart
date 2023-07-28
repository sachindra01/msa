// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/memberreport_controller.dart';

import 'package:msa/views/profile/created_report.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({Key? key}) : super(key: key);

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _salescon = TextEditingController();
  final MemberReportController _memCon = Get.put(MemberReportController());

  static const _locale = 'en';
  String _formatNumber(String s) =>s.isNotEmpty ? NumberFormat.decimalPattern(_locale).format(int.parse(s)) : '';

  final _profitcon = TextEditingController();
  final _expensescon = TextEditingController();
  final _impcon = TextEditingController();
  final _querycon = TextEditingController();
  final _goalcon = TextEditingController();
  bool _validateSales = true;
  bool _validateProfit = true;
  bool _validateExpenses = true;
  bool _validateImp = true;
  bool _validateQuery = true;
  bool _validateGoal = true;

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
            const Text(
              "講師のアドバイスをもとに",
              style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            const Text(
              "部活の活動レポートを作成していきましょう！",
              style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            const Text(
              "*すべて必須項目となります",
              style: TextStyle(
                  fontSize: 14, color: red, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                '売上',
                style: formTitleStyle,
              ),
            ),
            TextFormField(
              controller: _salescon,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
             // inputFormatters: [ CustomTextInputFormatter() ],
              onChanged: (x) {
                _memCon.earning = x.replaceAll(',', '');
                  x = _formatNumber(x.replaceAll(',', ''));
                  _salescon.value = TextEditingValue(
                  text: x,
                  selection: TextSelection.collapsed(offset: x.length),
                   );
                      setState(() {
                    _validateSales = x.isEmpty ? false : true;
                });  
                },
            
              decoration: InputDecoration(
                errorText: !_validateSales ? '必須項目を入力してください。' : null,
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                prefixText: '¥  ',
                prefixStyle: const TextStyle(color: black),
                hintText: "例）¥  1,000,000",
                hintStyle: const TextStyle(color: primaryColor),
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
              controller: _profitcon,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              
              onChanged: (x) {
                _memCon.grossProfit = x.replaceAll(',', '');
                  x = _formatNumber(x.replaceAll(',', ''));
                  _profitcon.value = TextEditingValue(
                  text: x,
                  selection: TextSelection.collapsed(offset: x.length),
                   );
                      setState(() {
                    _validateProfit = x.isEmpty ? false : true;
                });  
                },
              decoration: InputDecoration(
                errorText: !_validateProfit ? '必須項目を入力してください。' : null,
                prefixText: '¥  ',
                prefixStyle: const TextStyle(color: black),
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                hintText: '例）¥  1,000,000',
                hintStyle: const TextStyle(color: primaryColor),
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
              controller: _expensescon,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
                onChanged: (x) {
                  _memCon.expenses = x.replaceAll(',', '');
                  x = _formatNumber(x.replaceAll(',', ''));
                  _expensescon.value = TextEditingValue(
                  text: x,
                  selection: TextSelection.collapsed(offset: x.length),
                   );
                      setState(() {
                    _validateExpenses = x.isEmpty ? false : true;
                });  
                },
              decoration: InputDecoration(
                errorText: !_validateExpenses ? '必須項目を入力してください。' : null,
                prefixText: '¥  ',
                prefixStyle: const TextStyle(color: black),
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                hintText: '例）¥  1,000,000',
                hintStyle: const TextStyle(color: primaryColor),
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
              controller: _impcon,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              maxLines: 8,
                onChanged: (x){
                  _memCon.monthGoal = x;
                
                setState(() {
                  _validateImp = x.isEmpty ? false : true;
                });
              },
              decoration: InputDecoration(
                errorText: !_validateImp ? '必須項目を入力してください。' : null,
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                hintStyle: const TextStyle(color: primaryColor),
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
              controller: _querycon,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
                onChanged: (x){
                  _memCon.askHost = x;
                
                setState(() {
                  _validateQuery = x.isEmpty ? false : true;
                });
              },
              maxLines: 8,
              decoration: InputDecoration(
                errorText: !_validateQuery ? '必須項目を入力してください。' : null,
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                hintStyle: const TextStyle(color: primaryColor),
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
              controller: _goalcon,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              maxLines: 8,
              onChanged: (x){
                _memCon.nextMonthGoal = x;
                setState(() {
                  _validateGoal = x.isEmpty ? false : true;
                });
              },
              decoration: InputDecoration(
                errorText: !_validateGoal ? '必須項目を入力してください。' : null,
                border: InputBorder.none,
                filled: true,
                fillColor: white,
                hintStyle: const TextStyle(color: primaryColor),
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
                    setState(() {
                      _salescon.text.isEmpty
                          ? _validateSales = false
                          : _validateSales = true;

                      _profitcon.text.isEmpty
                          ? _validateProfit = false
                          : _validateProfit = true;

                      _expensescon.text.isEmpty
                          ? _validateExpenses = false
                          : _validateExpenses = true;

                      _impcon.text.isEmpty
                          ? _validateImp = false
                          : _validateImp = true;

                      _querycon.text.isEmpty
                          ? _validateQuery = false
                          : _validateQuery = true;

                      _goalcon.text.isEmpty
                          ? _validateGoal = false
                          : _validateGoal = true;
                    });
                    if ((_validateSales == true) &&
                        (_validateProfit == true) &&
                        (_validateExpenses == true) &&
                        (_validateImp == true) &&
                        (_validateQuery == true) &&
                        (_validateGoal == true)) {
                      Get.to(()=> const CreatedReportPage(), arguments: [
                        _salescon.text,
                        _profitcon.text,
                        _expensescon.text,
                        _impcon.text,
                        _querycon.text,
                        _goalcon.text,
                      ]);
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                  child: const Text("作成する"),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      List<String> chars = newValue.text.replaceAll(',', '').split('');
      String newString = '';
      for (int i = 0; i < chars.length; i++) {
        if (i % 3 == 0 && i != 0) newString += ',';
          newString +=  i>2 
          ? chars[i-2] 
          : chars[i]   ;
      }

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
