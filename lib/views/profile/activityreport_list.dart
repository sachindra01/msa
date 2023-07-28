import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/memberreport_controller.dart';
import 'package:msa/views/profile/activityreport_detail.dart';
import 'package:msa/widgets/loading_widget.dart';

class ActivityReportPage extends StatefulWidget {
  static const routeName = "/profile/activity_report";
  const ActivityReportPage({Key? key}) : super(key: key);

  @override
  State<ActivityReportPage> createState() => _ActivityReportPageState();
}

class _ActivityReportPageState extends State<ActivityReportPage> {
  final MemberReportController _con = Get.put(MemberReportController());
  // var args = Get.arguments;

  @override
  void initState() {
    Future.delayed(Duration.zero,(() => _con.getMemberReport()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        foregroundColor: black,
        actions: const [],
        title: const Text(
          "活動報告一覧 ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: GetBuilder(
        init: MemberReportController(),
        builder: (_) {
          return Obx(() => _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.data.isEmpty)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : buildActivityReport());
        }));
  }

  buildActivityReport() {
    // var monthList = ["1月の活動報告", "2月の活動報告", "3月の活動報告"];
    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    var width = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          ListView.builder(
            shrinkWrap: true,
              itemCount: _con.data.length,
              itemBuilder: ((context, index) {
                var reportItem = _con.data[index];
                return GestureDetector(
                  onTap: () {
                     Get.off(()=>  ActivityReportDetail(data: _con.data[index],), 
                    transition: Transition.rightToLeft);
                  },
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              children:[ 
                              Container(
                                height: height * 0.06,
                                width: width * 0.18,
                                decoration: BoxDecoration(
                                   color:  reportItem.labelEn == 'New' 
                                                        ?  red
                                                        : reportItem.labelEn == 'Hold'
                                                           ? blue
                                                           : buttonLightColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text(
                                  reportItem.labelMember,
                                  style: reportTitleStyle,
                                )),
                              ),
                            reportItem.reportStatus == "replied" && reportItem.clientReplySeen == false
                              ? Container(
                                height: 10,
                                width: 10,
                                 decoration: const BoxDecoration(
                                  color: red,
                                 borderRadius:  BorderRadius.all(Radius.circular(20))
                              )) : const SizedBox()
                              ],
                            ),
                            Text(
                              DateTime.parse(reportItem.reportDate.toString()).month.toString()+"月の活動報告",
                              style: catTitleStyle,
                            ),
                            Text(
                              reportItem.reportDate
                                      .toString()
                                      .substring(0, 4) +
                                  "年",
                              style: reportDateTitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
          ),
            const SizedBox(height: 20,),
             Container(
               
                height: 70,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                color: white,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                  child: const Text("戻る"),
                ),
              ),
         
        ],
      );
    
  }
}
