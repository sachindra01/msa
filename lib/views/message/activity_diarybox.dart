import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/statuslist_controller.dart';
import 'package:msa/views/message/memberstatuslist.dart';

import '../../widgets/loading_widget.dart';

const routeName = "/chat/activitydiarybox";

class ActivityDiaryBox extends StatefulWidget {
  const ActivityDiaryBox({Key? key}) : super(key: key);

  @override
  State<ActivityDiaryBox> createState() => _ActivityDiaryBoxState();
}

class _ActivityDiaryBoxState extends State<ActivityDiaryBox> {
  final StatusListController _con = Get.put(StatusListController());


  @override
  void initState() {
    _con.getStatusList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
       appBar: AppBar(
              actions: const [],
              title: const Text("活動日誌一覧"),
              backgroundColor: white,
              foregroundColor: black,
            ),
        body: GetBuilder(
        init: StatusListController(),
        builder: (context) {
          return Obx(() => _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.statuslist == null)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : Padding(
                        padding: EdgeInsets.only(top: height * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                              Get.to(() => const UserListPage(),arguments: 'all');
                              },
                              child: SizedBox(
                                height: height * 0.2,
                                child: Card(
                                  margin: const EdgeInsets.all(0.5),
                                  elevation: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          _con.statuslist.all.label,
                                          style: catTitleStyle,
                                        ),
                                      ),

                                     (_con.allCount.value == 0)   
                                       ?const SizedBox()
                                       : Obx(() => 
                                        Padding(
                                            padding: const EdgeInsets.only(right: 25),
                                            child: CircleAvatar(
                                              backgroundColor: red,
                                              foregroundColor: white,
                                              radius: 12,
                                              child: Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Text(
                                                _con.allCount>99 ?"99+" : _con.allCount.toString(),
                                                  style: badgeCounterTextStyle,
                                                ),
                                              ),
                                            ),
                                        ),
                                       )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                             Get.to(() => const UserListPage(),arguments: 'hold');
                             
                              },
                              child: SizedBox(
                                height: height * 0.2,
                                child: Card(
                                  margin: const EdgeInsets.all(0.5),
                                  elevation: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          _con.statuslist.hold.label,
                                          style: catTitleStyle,
                                        ),
                                      ),
                                       
                                  (_con.holdCount.value == 0)   
                                       ?const SizedBox()
                                       :Obx(() =>  Padding(
                                            padding: const EdgeInsets.only(right: 25),
                                            child: CircleAvatar(
                                              backgroundColor: red,
                                              foregroundColor: white,
                                              radius: 12,
                                              child: Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Text(
                                                   _con.holdCount>99 ?"99+" : _con.holdCount.toString(),
                                                  style: badgeCounterTextStyle,
                                                ),
                                              ),
                                            ),
                                        ), 
                                    )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            InkWell(
                               onTap: () {
                                Get.to(() => const UserListPage(),arguments: 'new');
                              },
                              child: SizedBox(
                                height: height * 0.2,
                                child: Card(
                                  margin: const EdgeInsets.all(0.5),
                                  elevation: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          _con.statuslist.dataNew.label,
                                          style: catTitleStyle,
                                        ),
                                      ),
                                     (_con.newCount.value == 0)   
                                       ?const SizedBox()
                                       :Obx(()=>   Padding(
                                            padding: const EdgeInsets.only(right: 25),
                                            child: CircleAvatar(
                                              backgroundColor: red,
                                              foregroundColor: white,
                                              radius: 12,
                                              child: Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Text(
                                                   _con.newCount>99 ?"99+" : _con.newCount.toString(),
                                                  style: badgeCounterTextStyle,
                                                ),
                                              ),
                                            ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            InkWell(
                               onTap: () {
                             Get.to(() => const UserListPage(),arguments: 'replied');
                             },
                              child: SizedBox(
                                height: height * 0.2,
                                child: Card(
                                  margin: const EdgeInsets.all(0.5),
                                  elevation: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          _con.statuslist.replied.label,
                                          style: catTitleStyle,
                                        ),
                                      ),
                                      
                                   (_con.repliedCount.value == 0)  
                                         ? const SizedBox() 
                                         :Obx(()=>  Padding(
                                            padding: const EdgeInsets.only(right: 25),
                                            child: CircleAvatar(
                                              backgroundColor: red,
                                              foregroundColor: white,
                                              radius: 12,
                                              child: Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Text(
                                                   _con.repliedCount>99 ?"99+" : _con.repliedCount.toString(),
                                                  style: badgeCounterTextStyle,
                                                ),
                                              ),
                                            ),
                                        ),
                                       )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
        })
    );
    
    
  }
}
