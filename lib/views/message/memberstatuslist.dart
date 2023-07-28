import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/statuslist_controller.dart';
import 'package:msa/views/message/host_activity_report.dart';
import 'package:msa/widgets/circular_avatar_widget.dart';

import 'package:msa/widgets/loading_widget.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final StatusListController _con = Get.put(StatusListController());
  final args = Get.arguments;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _con.getMemberList(args);
     });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: pagesAppbar,
              foregroundColor: black,
              title: const Text(
                "活動日誌一覧",
               
              ),
            ),
            body: GetBuilder(
                init: StatusListController(),
                builder: (context) {
                  return Obx(() => _con.isLoading.value == true
                      ? Center(child: loadingWidget())
                      : (_con.memberlist.isEmpty)
                          ? const Center(
                              child: Text("該当データがありません"),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: _con.memberlist.length,
                                        itemBuilder: ((context, index) {
                                          return InkWell(
                                            onTap: () {
                                            Get.to(() => const HostActivityReport(),
                                                  arguments: _con.memberlist[index].userId)!.then((value) {
                                                  if(value == 1){setState((){
                                                    _con.getMemberList(args);
                                                  });}
                                                  }
                                                  );
                                            },
                                            child: Card(
                                              margin: const EdgeInsets.all(0.6),
                                              elevation: 5,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                        child: CircleAvatar(
                                                          radius: 32,
                                                          child: CircularAvatarWidget(
                                                            width: 59,
                                                            height: 59,
                                                            imageUrl: _con.memberlist[index].imageUrl,
                                                          ),
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: SizedBox(
                                                      width: width * 0.5,
                                                      child: Text(_con.memberlist[index].nickname,
                                                        maxLines: 2,
                                                        style: catTitleStyle,
                                                      ),
                                                    ),
                                                  ),
                                                 Obx(()=>
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                                    // height: height * 0.06,
                                                    width: width * 0.22,
                                                    decoration: BoxDecoration(
                                                        color:  _con.memberlist[index].labelEn == 'New' 
                                                        ?  red
                                                        : _con.memberlist[index].labelEn == 'Hold'
                                                           ? blue
                                                           : repliedLabelColor,
                                                        borderRadius:BorderRadius.circular(15)),
                                                    child: Center(
                                                        child: Text( _con.memberlist[index].label,
                                                      style: reportTitleStyle,
                                                    )),
                                                  ),),
                                                ],
                                              ),
                                            ),
                                          );
                                        })),
                                  ),
                                ],
                              ),
                            ));
                })));
  }
}
