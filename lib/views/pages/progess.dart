import 'package:flutter/material.dart';
import 'package:msa/common/styles.dart';

class ProgressPage extends StatelessWidget {
  static const routeName = '/progress';
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pagesAppbar,
        iconTheme: const IconThemeData(
          color: black, //change your color here
        ),
        title: const Text(
          '学習進捗率とは？',
          style: TextStyle(color: black),
          textAlign: TextAlign.justify,
        ),
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: const Text(
            " コンテンツの学習が完了したら「✔受講済」ボタンを押すことで、どのくらい学習が進んでいるかをご確認いただけます。\n 全ての学習を完了しますと100％となります。",style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600
            ),),
      ),
    );
  }
}
