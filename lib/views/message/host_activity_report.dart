import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/statuslist_controller.dart';
import 'package:msa/controller/memberreport_controller.dart';
import 'package:msa/views/message/host_activity_report_Detail.dart';
import 'package:msa/widgets/loading_widget.dart';

class HostActivityReport extends StatefulWidget {
  const HostActivityReport({Key? key}) : super(key: key);

  @override
  State<HostActivityReport> createState() => _HostActivityReportState();
}

class _HostActivityReportState extends State<HostActivityReport> {
  final MemberReportController _con = Get.put(MemberReportController());
  final StatusListController _stCon = Get.put(StatusListController());
  var args = Get.arguments;

  
 List <String> currentSelectedValue = [];
  @override
  void initState() {
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      //  _con.getHostMemberReport(args);
    // });
    _stCon.getStatusList();
    Future.delayed(
      Duration.zero,(() => _con.getHostMemberReport(args)
    ));
   
    
    super.initState();
  }

   

  @override
  Widget build(BuildContext context) {
    final _options = ["1", "2", "3",];
    final _options2 = [ "2", "3",];

    txt(label){
    if(label == 'new'){
      return "1";
    }else if(label == 'hold'){
      return "3";
    } else if(label == 'replied'){
      return "2";
    }return "0";
  }
  
    
    
    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async{
        Get.back(result: 1);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          foregroundColor: black,
          actions: const [],
          title: const Text(
            "活動報告一覧",
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
                      : Column(
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
                                 
                                    currentSelectedValue.add(txt(reportItem.reportStatus));
                                 
                                  return GestureDetector(
                                    onTap: () {
                                      Get.off(() => HostActivityReportDetail(
                                            data: [_con.data[index],args],
                                          ))!.then((value) => setState((){}));
                                    },
                                    child: Card(
                                      elevation: 2,
                                      margin: EdgeInsets.zero,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: height * 0.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              
                                             Container(
                                                padding: const EdgeInsets.all(5),
                                                width: width * 0.25,
                                                child: FormField<String>(
                                                  builder: (FormFieldState<String> state) {
                                                      
                                                    return InputDecorator(
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                        ),
                                                        hintStyle: TextStyle(color: primaryColor),
                                                        contentPadding: EdgeInsets.zero
                                                      ),
                                                      isEmpty: currentSelectedValue.isEmpty,
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<String>(
                                                          isExpanded: true,
                                                          alignment: Alignment.centerRight,
                                                          menuMaxHeight: 200,
                                                          dropdownColor : white,
                                                          borderRadius: BorderRadius.circular(30),
                                                          icon: const Visibility(
                                                            visible: false,
                                                            child: Icon(Icons.arrow_drop_down),
                                                          ),
                                                          // // ignore: prefer_if_null_operators
                                                         value: currentSelectedValue[index] == '' ?txt(reportItem.reportStatus) : currentSelectedValue[index],
                                                          isDense: false,
                                                          onChanged: (newValue) {
                                                             currentSelectedValue[index] = newValue!;
                                                              state.didChange(newValue);
                                                              _con.reportStatus = _stCon.reportStatusEnglish(newValue);
                                                              _con.postHostReply(reportItem.id).then((value){
                                                                 _con.getHostMemberReport(args);
                                                                 _stCon.getStatusList();
                                                                 
                                                              });
                            
                                                            setState(() {
                                                             
                                                            });
                                                          },
                                                          items: currentSelectedValue[index] == "1"? _options.map((String value) {
                                                            return DropdownMenuItem<String>(
                                                              alignment: Alignment.center,
                                                              value: value,
                                                              child: Center(
                                                                child: Container(
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                    color: _stCon.chatStatusColor(value),
                                                                    borderRadius: BorderRadius.circular(30)
                                                                  ),
                                                                  padding: const EdgeInsets.all(0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      _stCon.chatStatusText(value),
                                                                      style: catTextStyle,
                                                                    )
                                                                  ),
                                                                )
                                                              ),
                                                            );
                                                          }).toList()
                                                        :  _options2.map((String value) {
                                                            return DropdownMenuItem<String>(
                                                              alignment: Alignment.center,
                                                              value: value,
                                                              child: Center(
                                                                child: Container(
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                    color: _stCon.chatStatusColor(value),
                                                                    borderRadius: BorderRadius.circular(30)
                                                                  ),
                                                                  padding: const EdgeInsets.all(0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      _stCon.chatStatusText(value),
                                                                      style: catTextStyle,
                                                                    )
                                                                  ),
                                                                )
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                            
                            
                                              Text(
                                                DateTime.parse(reportItem.reportDate.toString()).month.toString()+"月の活動報告",
                                                // monthList[index],
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              color: white,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back(result: 1);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: buttonPrimaryColor),
                                child: const Text("戻る"),
                              ),
                            ),
                          
                          ],
                        ));
            }),
      ),
    );
  }
}
