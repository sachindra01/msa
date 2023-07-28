import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/notification_controller.dart';
import 'package:msa/controller/product_list_controller.dart';
import 'package:msa/controller/radio_list_controller.dart';
import 'package:msa/views/home/movie_detail.dart';
import 'package:msa/views/home/radio_detail.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/showpremiumalert.dart';
import 'package:msa/widgets/webview_page.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = '/profile/notification';
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NoitificationController _con = Get.put(NoitificationController());
  final ProductListController _pCon = Get.put(ProductListController());
  final RadioController _rCon = RadioController();
var box=GetStorage();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      _con.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pagesAppbar,
        foregroundColor: black,
        title: const Text(
          "お知らせ",
          style: catTitleStyle,
        ),
      ),
      body: GetBuilder(
        init: NoitificationController(),
        builder: (_) {
          return Obx(() =>
            _con.isLoading.value == true
              ? Center(
                child: loadingWidget(),
              )
              : _con.notificationList.isEmpty
                ? const Center(child: Text('No notification to show'))
                : notificationBody()
          );
        }
      ),
    );
  }

  notificationBody() {
    var width = MediaQuery.of(context).size.width;
    var premiumAcc=box.read('isPremium');
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: _con.notificationList.length,
        itemBuilder: ((context, index) {
          var notificationData = _con.notificationList[index];
          return InkWell(
            onTap: (){
              if(premiumAcc == true || notificationData.allowPremiumAccess == true){
                notificationRoute(notificationData);
              } else {
                showPremiumAlert(context);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 1,top: 1.5,bottom: 1.5,right: 1),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: grey.shade200),
                color: white
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkimage(
                        imageUrl: notificationData.image,
                        // fit: BoxFit.fill,
                        // width: 50.0,
                        // height: 50.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.65,
                          child: Text(
                            notificationData.type == "news" ? notificationData.title : notificationData.title + " が公開されました。",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: formTitleStyle,
                          ),
                        ),
                        Text(
                          DateTime.parse(notificationData.publishDateFrom).month.toString() + "月" +
                           DateTime.parse(notificationData.publishDateFrom).day.toString() + "日 ",
                          // notificationData.publishDateTo,
                          style: dateTextStyle,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        })
      ),
    );
  }

  notificationRoute(notificationData){
    // if(notificationData.newsModule.moduleType == ' radio' ){
      
    // Get.to(()=> const RadioDetailPage(data: "a"));
    // }if(notificationData.newsModule.moduleType == 'blogs'){
    //   Get.to(()=> const WebviewPage(),arguments: []);
    // }
    if(notificationData.newsModule.isEmpty){
      if(notificationData.type == 'timeline') {
        notificationData.linkType=='product'
          ? _pCon.getMovieDetail(notificationData.productLink.split('/')[1]).then((_){
            Get.to(() => const MovieDetailPage(), 
            arguments: [notificationData.productLink.split('/')[1],_pCon.videoId]
          );    
          })
            
          : notificationData.linkType == 'blog' || notificationData.linkType == 'article'
            ? Get.to(() => const WebviewPage(), 
              arguments: [notificationData.blogLink, 'article']
            )
            : Get.to(() => const WebviewPage(), 
              arguments: [notificationData.id, 'timeline']
            );
      } else {
        notificationData.type == 'blog'
          ? Get.to(()=>const WebviewPage(),
            arguments: [ notificationData.id, 'article']
          )
          : notificationData.type=='news'
            ? Get.to(()=>const WebviewPage(),
              arguments: [notificationData.id,'news']
            )
            : notificationData.type=='1'
              ? 
                _pCon.getMovieDetail(notificationData.id).then((_){
                Get.to(()=>const MovieDetailPage(),
                  arguments: [notificationData.id,_pCon.videoId]
                  );
              })
                
              : const NotificationPage();
      }
    }else{
      if(notificationData.newsModule['module_type'] == 'radio' ) {
        _rCon.getRadioDetail(notificationData.newsModule['id']).then((value){
          if(value == true ) {Get.to(()=> RadioDetailPage(data: _rCon.radioDetail));}
        });
      }
      if(notificationData.newsModule['module_type'] == 'blog'){
        Get.to(()=> const WebviewPage(),arguments: [
          notificationData.newsModule['id'].toString(),
          'article'
        ]);
      }
    }
  }
}
