import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/pages/level.dart';
import 'package:msa/views/pages/progess.dart';
// import 'package:msa/views/profile/activityreport_list.dart';
// import 'package:msa/views/profile/bar_chart.dart';
// import 'package:msa/views/profile/create_reportpage.dart';
// import 'package:msa/views/profile/new_bar_chart.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:msa/views/profile/edit_profile.dart';

import 'package:msa/widgets/circular_avatar_widget.dart';
import 'package:msa/widgets/line_register_pop_up.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/premium_alert.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _con = Get.put(AuthController());
  final box = GetStorage();
  var  index = 0;

  @override
  void initState() {
    index=0;
    Future.delayed(Duration.zero, () {
      _con.getUserInfo();
      _con.getBarInfo();
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if(box.read('firstLogin')==true){
        showLineRegisterPopUp(context);
        box.write('firstLogin',false);
      }
    });
    super.initState();
  }
  // bool firstGraph =  true;
  // _selectedGraph( firstGraph){
  //     return   firstGraph? const SizedBox(
  //             height: 330,
  //             child: Barchart1())
  //       : Bargraphchart(
  //           index: index,
  //         );
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AuthController(),
      builder: (context) {
        return Obx(() => _con.isLoading.value == true
        ? Center(child: loadingWidget())
        : (_con.userInfo == null)
        ? const Center(
            child: Text("該当データがありません"),
          )
        : profileBody());
      },
    );
  }

  profileBody() {
    // var memberType = _box.read('memberType');
    // var premiumAcc = _box.read('isPremium').toString();
    final List<ChartData> chartData = [
      ChartData(
          'David',
          _con.userInfo.checkedProducts /
              _con.userInfo.totalProductsCount *
              360,
          const Color(0xFF26a69a)),
      ChartData(
          'Steve',
          (_con.userInfo.totalProductsCount - _con.userInfo.checkedProducts) /
              _con.userInfo.totalProductsCount *
              360,
          Colors.grey.shade300),
    ];

   
    var myDouble = _con.userInfo.learnedRate != "null"
        ? double.parse(_con.userInfo.learnedRate ?? '0')
        : 0.0;
    var indicatorValue = myDouble / 100;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: pagesAppbar,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //block 1
              Container(
                color: white,
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: InkWell(
                  onTap: () => Get.to(() => const ProfileEditPage(),
                    arguments: _con.userInfo)
                      ?.then((x) =>  x ?_con.getUserInfo() : null),
                  child: Row(
                    children: [
                      CircularAvatarWidget(
                        imageUrl: _con.userInfo.profileImage,
                        width: 80,
                        height: 80
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.58,
                            child: Text(
                              _con.userInfo.nickname ?? '',
                              maxLines: 5,
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: textColor1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          _con.userInfo.designation == 'null'
                              ? const SizedBox()
                              : Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: SizedBox(
                                   width: MediaQuery.of(context).size.width*0.58,
                                  child: Text(_con.userInfo.designation ?? '')),
                              ),
                        // premiumAcc == 'true'
                        //   ? Padding(
                        //     padding: const EdgeInsets.only(top: 5),
                        //     child: SizedBox(
                        //       height: 30,
                        //       child: ElevatedButton.icon(
                        //         style: ElevatedButton.styleFrom(
                        //             primary: catTitleyColor,
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 10, vertical: 5),
                        //             side: const BorderSide(
                        //                 width: 2.0, color: borderWrapper)),
                        //         onPressed: () {
                        //           // showPremiumDialog();
                        //         },
                        //         icon: SvgPicture.asset(
                        //           'assets/images/premium-tag.svg',
                        //           width: 10,
                        //         ),
                        //         label: const Text(
                        //           "プレミアム",
                        //           style: TextStyle(fontSize: 10),
                        //         ),
                        //       ),
                        //     ),
                        //   ) 
                        //   : const SizedBox(),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //block 2
              Container(
                color: white,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/ic_progress.svg",
                          color: Colors.red,
                          cacheColorFilter: false,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "総学習進捗率",
                          style: catTitleStyle,
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '学習進捗率とは？',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xff9c9c9c),
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  Get.to(const ProgressPage());
                                  })
                          ]),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width - 20,
                      height: 15,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: indicatorValue,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(primaryColor),
                          backgroundColor: const Color(0xffbee4e1),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        _con.userInfo.learnedRate == 'null'
                            ? const Text(
                                '0 %',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              )
                            : Text(
                                '${_con.userInfo.learnedRate ?? '0'}  %',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/ic_level.svg",
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "レベル",
                          style: catTitleStyle,
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'レベルとは？',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xff9c9c9c),
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(()=> const LevelPage());
                                  }),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    circularProgressAnnotation(chartData)
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              // memberType == 'member'
              //     ? Column(
              //         children: [
              //           //block 3
              //           Container(
              //             padding: const EdgeInsets.all(10.0),
              //             color: white,
              //             child: Column(
              //               children: [
              //                 Row(
              //                   children: [
              //                     SvgPicture.asset(
              //                       "assets/images/activity.svg",
              //                     ),
              //                     const SizedBox(
              //                       width: 10,
              //                     ),
              //                     const Text(
              //                       "活動報告",
              //                       style: catTitleStyle,
              //                     ),
              //                   ],
              //                 ),
              //                 const SizedBox(
              //                   height: 10,
              //                 ),
              //                 Visibility(
              //                   visible: (isReportTime(int.parse(
              //                           _con.profileInfo.reportDay)) &&
              //                       !_con.profileInfo.reportSentFlg),
              //                   child: const Text(
              //                     "●今月のレポートが未提出です",
              //                     style: TextStyle(color: Colors.red),
              //                   ),
              //                 ),
              //                 Container(
              //                   height: 70,
              //                   width: MediaQuery.of(context).size.width,
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 50, vertical: 10),
              //                   color: white,
              //                   child: ElevatedButton(
              //                     onPressed: () {
              //                       (!isReportTime(int.parse(
              //                                   _con.profileInfo.reportDay)) ||
              //                               _con.profileInfo.reportSentFlg)
              //                           ? null
              //                           : Get.to(
              //                               () => const CreateReportPage());

              //                       // _memCon.saveMemberReport();
              //                     },
              //                     style: ElevatedButton.styleFrom(
              //                         primary: (!isReportTime(int.parse(_con
              //                                     .profileInfo.reportDay)) ||
              //                                 _con.profileInfo.reportSentFlg)
              //                             ? buttonDisableColor
              //                             : const Color(0xff5e81f4)),
              //                     child: Text(
              //                       "活動報告作成する",
              //                       style: TextStyle(
              //                           color: (!isReportTime(int.parse(_con
              //                                       .profileInfo.reportDay)) &&
              //                                   _con.profileInfo.reportSentFlg)
              //                               ? textColor1
              //                               : white),
              //                     ),
              //                   ),
              //                 ),
              //                 Text(
              //                  _con.profileInfo.reportRepliedFlg 
              //                       ? "●今月の活動報告に回答がありました"
              //                       : _con.profileInfo.reportSentFlg
              //                           ? "今月の報告ありがとうございました。"
              //                           : '',
              //                   style: const TextStyle(color: Colors.red),
              //                 ),
              //                 Container(
              //                   height: 70,
              //                   width: MediaQuery.of(context).size.width,
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 50, vertical: 10),
              //                   color: white,
              //                   child: ElevatedButton(
              //                     onPressed: () {
              //                       Get.to(()=> const ActivityReportPage(),
              //                        transition: Transition.rightToLeftWithFade);
              //                       // Navigator.pushNamed(
              //                       //     context, '/profile/activity_report');
              //                     },
              //                     style: ElevatedButton.styleFrom(
              //                         primary: buttonPrimaryColor),
              //                     child: const Text("活動報告一覧"),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           //block 4
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Obx(
              //             () => _con.isLoading.value == true
              //                 ? Center(child: loadingWidget())
              //                 : Container(
              //                     padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
              //                     color: white,
              //                     child: Column(
              //                       children: [
              //                         Padding(
              //                           padding: const EdgeInsets.only(left: 15.0),
              //                        child:  InkWell(
              //                           onTap: (){
              //                             setState(() {
              //                               firstGraph = !firstGraph;
              //                             });
              //                           },
              //                           child: Row(
              //                             children: [
              //                               SvgPicture.asset(
              //                                 "assets/images/activity.svg",
              //                               ),
              //                               const SizedBox(
              //                                 width: 10,
              //                               ),
              //                               const Text(
              //                                 "年間売上",
              //                                 style: catTitleStyle,
              //                               ),
              //                             ],
              //                           ),
              //                         )),
              //                         _selectedGraph(firstGraph)
              //                       //   // const SizedBox(
              //                       //   //   height: 330,
              //                       //   //   child: Barchart1())
              //                       //  Bargraphchart(
              //                       //   index: index,
              //                       // ),
              //                       ],
              //                     ),
              //                   ),
              //           ),
              //         ],
              //       )
              //     : const SizedBox(),
              // _con.memberType == 'member' && premiumAcc == 'false'
              //     ? Column(
              //         children: [
              //           //block 5
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Container(
              //             padding: const EdgeInsets.all(10.0),
              //             color: catTitleyColor,
              //             child: Row(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               children: [
              //                 Expanded(
              //                   flex: 1,
              //                   child: CircleAvatar(
              //                     backgroundColor: borderWrapper,
              //                     radius: 35.0,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(5.0),
              //                       child: Image.asset(
              //                           'assets/images/ic_logo.png'),
              //                     ),
              //                   ),
              //                 ),
              //                 Expanded(
              //                   flex: 3,
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       SizedBox(
              //                         height: 30,
              //                         child: ElevatedButton.icon(
              //                           style: ElevatedButton.styleFrom(
              //                               primary: catTitleyColor,
              //                               padding: const EdgeInsets.symmetric(
              //                                   horizontal: 10, vertical: 2),
              //                               side: const BorderSide(
              //                                   width: 2.0,
              //                                   color: borderWrapper)),
              //                           onPressed: () {},
              //                           icon: SvgPicture.asset(
              //                             'assets/images/premium-tag.svg',
              //                             width: 10,
              //                           ),
              //                           label: const Text(
              //                             "プレミアム",
              //                             style: TextStyle(fontSize: 10),
              //                           ),
              //                         ),
              //                       ),
              //                       const SizedBox(
              //                         height: 10.0,
              //                       ),
              //                       const Text(
              //                         ' プレミアム会員について もりもとらせどりコミュニティに 今すぐ登録して、 プレミアム会員限定の機能を使おう！ 詳しくは「MSA もりもとらコミュニティ」で検索！ もしくは、お問い合わせフォームからご連絡ください。 ',
              //                         style: TextStyle(
              //                             color: white,
              //                             fontSize: 12,
              //                             height: 2),
              //                         textAlign: TextAlign.left,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           //block 6
              //           Container(
              //             height: 70,
              //             width: MediaQuery.of(context).size.width,
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 50, vertical: 10),
              //             color: catTitleyColor,
              //             child: ElevatedButton(
              //               onPressed: () {
              //                 showPremiumDialog();
              //               },
              //               style: ElevatedButton.styleFrom(
              //                   primary: buttonPrimaryColor),
              //               child: const Text("プレミアムサービスについて"),
              //             ),
              //           ),
              //         ],
              //       )
              //     : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  circularProgressAnnotation(chartData) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("現状のレベル"),
              // const SizedBox(height: 8.0),
              _con.userInfo.studyLevel == null
                ? const SizedBox()
                : CircleAvatar(
                  backgroundColor: transparent,
                  radius: 35,
                  child: SvgPicture.network(
                    _con.userInfo.levelImage,
                    height: 70,
                  ),
                ),
              // const SizedBox(height: 8.0),
              Text(_con.userInfo.levelName),
            ],
          ),
          const VerticalDivider(
            width: 20,
            color: primaryColor,
            indent: 30,
            endIndent: 30,
            thickness: 1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("次のレベルまで"),
              SizedBox(
                height: 100.0,
                width: 100.0,
                child: SfCircularChart(
                  annotations: <
                  CircularChartAnnotation>[
                      CircularChartAnnotation(
                          widget: SizedBox(
                              height: 30,
                              width: 30,
                              child: PhysicalModel(
                                  child: Container(),
                                  shape: BoxShape.circle,
                                  elevation: 0.0,
                                  shadowColor: Colors.transparent,
                                  color: Colors.transparent
                              )
                          )
                      ),
                      CircularChartAnnotation(
                          widget: SizedBox(
                              height: 30,
                              width: 30,
                              child: Center(
                                  child:RichText(
                                      text: TextSpan(
                                          text: _con.userInfo.checkedProducts.toString(),
                                          style:  const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: black
                                          ),
                                          children:  <TextSpan>[
                                              TextSpan(
                                                  text:'/'+ _con.userInfo .totalProductsCount.toString(), 
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 8
                                                  )
                                              ),
                                          ],
                                      ),
                                  ),
                              ),
                          ),
                      )
                  ], 
                  series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper: (ChartData data, _) =>
                              data.color,
                          xValueMapper: (ChartData data, _) =>
                              data.x,
                          yValueMapper: (ChartData data, _) =>
                              data.y,
                          explode: true,
                          explodeIndex: 1,
                          explodeOffset: '3%',
                      )
                  ]
                ),
              ),
              const Text("学習数"),
            ]
          )
        ],
      ),
    );
  }

  Future<Object?> showPremiumDialog() {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child:
                Opacity(opacity: a1.value, child: const PremiumAlertWidget()),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  Future<Object?> showLevelDialog() {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: const LevelPage()),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  isReportTime(int reportday) {
    return reportday < DateTime.now().day.toInt();
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color? color;
}
