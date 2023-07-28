import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:msa/common/styles.dart';

class LevelPage extends StatelessWidget {
  static const routeName = '/level';
  const LevelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pagesAppbar,
        iconTheme: const IconThemeData(
          color: black, //change your color here
        ),
        title: const Text(
          'レベルとは？',
          style: TextStyle(color: black, fontSize: 16),
          textAlign: TextAlign.justify,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                "コンテンツの学習が完了したら「✔受講済」ボタンを押すことで、どのくらい学習が進んでいるかをご確認いただけます。学習進捗確認としてご活用ください。レベルは、ビギナーからマスターまでで5段階となります。ぜひ、マスターを目指してください。",
                style: TextStyle(color: primaryColor,fontWeight: FontWeight.w600),
              ),
             const  SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/level-1.svg",
                        width: 70,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ビギナー",
                        style: catTitleStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/level-two.svg",
                        width: 70,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ベーシック",
                        style: catTitleStyle,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/level-three.svg",
                        width: 70,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "アドバンス",
                        style: catTitleStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/level-four.svg",
                        width: 70,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "エキスパート",
                        style: catTitleStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/level-five.svg",
                        width: 70,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "マスター",
                        style: catTitleStyle,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}