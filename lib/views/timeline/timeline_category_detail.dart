import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/timeline_controller.dart';
import 'package:msa/views/home/movie_detail.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/music_player_widget.dart';
import 'package:msa/widgets/webview_page.dart';

class TimeLineCategoryDetail extends StatefulWidget {
  const TimeLineCategoryDetail({ Key? key}) : super(key: key);

  @override
  State<TimeLineCategoryDetail> createState() => _TimeLineCategoryDetailState();
}

class _TimeLineCategoryDetailState extends State<TimeLineCategoryDetail> {
  var args = Get.arguments;
  final TimeLineController _con = Get.put(TimeLineController());


  @override
  void initState() {
    _con.getTimelineCategoryList(args[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args[1],
          style: const TextStyle(
            fontSize: 16
          )
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        
      
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GetBuilder(
          init: TimeLineController(),
          builder: (_) {
            return Obx(() => _con.isCatLoading.value == true
              ? Center(
                child: loadingWidget(),
              )
              : (_con.timeline.isEmpty)
                ? const Center(
                    child: Text("該当データがありません"),
                  )
                : timelineCategoryBody());
          },
        ),
      )
    );
  }

  timelineCategoryBody() {
    var catData = _con.timelineCat;
    return Stack(
      children: [ListView.separated(
        itemCount: catData.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (_,__) {
          return const SizedBox(height: 0.0);
        },
        itemBuilder: (context, index) {
          var data = catData[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: (() => timeLineDetailRoute(catData[index])), 
              child: Card(
                elevation: 5.0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    children: [
                      SizedBox( 
                        height: MediaQuery.of(context).size.height * 0.245,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.loose,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkimage(
                                imageUrl: data.profileImage, 
                                width: MediaQuery.of(context).size.width*0.95, 
                                height: MediaQuery.of(context).size.height*0.25,
                              ),
                            ),
                            catData[index].isPremium == false
                              ? Positioned.fill(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            // color: Colors.black,
                                            width: 25,
                                            height: 20,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: black,
                                                border: Border.all(
                                                  color: Colors.yellow,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(Radius.circular(5))),
                                            child: SvgPicture.asset(
                                              'assets/images/premium-tag.svg',
                                              width: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                              : const SizedBox(),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.95,
                            child: Text(
                              data.timelineTitle,
                              style: catTitleStyle,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: Text(
                            data.publishDateFrom,
                            style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
       const Positioned(
                bottom: 0,
                child:  Player()
       ),
      ]
    );
  }

  timeLineDetailRoute(data) {
    if(data.linkType == 'product') {
      Get.to(() => const MovieDetailPage(), 
        arguments: data.productLink.split('/')[1]
      );
    } else if(data.linkType == 'blog' || data.linkType == 'article') {
      Get.to(() => const WebviewPage(), 
        arguments: [data.blogLink, 'article'],
      );
    } else if(data.linkType == 'detail') {
      Get.to(() => const WebviewPage(), 
        arguments: [data.id, 'timeline']
      );
    }
  }

}