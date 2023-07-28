import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/controller/timeline_controller.dart';
import 'package:msa/views/home/movie_detail.dart';
import 'package:msa/views/timeline/timeline_category_detail.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/search_page.dart';
import 'package:msa/widgets/showpremiumAlert.dart';
import 'package:msa/widgets/webview_page.dart';

class TimeLinePage extends StatefulWidget {
  static const routeName = '/timeline';
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  final TimeLineController _con = Get.put(TimeLineController());
  final SearchController _scon = Get.put(SearchController());

  final box = GetStorage();

  @override
  void initState() {
    _scon.movieList.clear();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
       _con.getTimelineList();
   
     });
      _scon.type.value = 'timeline';
    
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder(
            init: TimeLineController(),
            builder: (context) {
              return Obx(() => _con.isLoading.value == true
                  ? loadingWidget()
                  : (_con.timeline.isEmpty)
                      ? const Center(
                          child: Text("該当データがありません"),
                        )
                      : _scon.searchBoxEnabled.value == false || _scon.keyword.value == ''
                          ? timelineBody()
                          : const SearchPage());
            }));
  }

  timelineBody() {
    // var premiumAcc = box.read('isPremium');
    var newData = _con.timeline;
    return ListView.builder(
      padding: const EdgeInsets.only(top:8,left: 10,right: 8,bottom: 0),
      itemBuilder: (context, index) {
        var timelineData = newData[index].timelines;
        return InkWell(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        newData[index].categoryName,
                        style: movielistCatStyle,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      child: Row(
                        children: const [
                          Text(
                            'もっと見る',
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                          SizedBox(width: 8.0),
                          Icon(Icons.arrow_forward_ios_outlined,
                              size: 16, color: primaryColor),
                        ],
                      ),
                      onTap: () {
                         

                        Get.to(() => const TimeLineCategoryDetail(),
                            arguments: [
                              newData[index].id,
                              newData[index].categoryName
                            ],
                            transition: Transition.rightToLeftWithFade);
                      },
                    ),
                    const SizedBox(width: 8.0)
                  ],
                ),
              ),
              SizedBox(
              height: MediaQuery.of(context).size.height*0.255,
               width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.60,
                      child: InkWell(
                        onTap: () {
                          timeLineDetailRoute(timelineData[i], newData[index]);
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                fit: StackFit.loose,
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkimage(
                                      imageUrl: timelineData[i].profileImage,
                                      height: MediaQuery.of(context).size.height*0.15,
                                      width: MediaQuery.of(context).size.width*0.606,
                                    ),
                                  ),
                                    
                                  timelineData[i].isPremium == false
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
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width /1.8,
                                    
                                    child: Text(
                                      timelineData[i].timelineTitle,
                                      style: catTitleStyle,
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(right: 8.0, left: MediaQuery.of(context).size.width*0.43),
                                child: Text(
                                  timelineData[i].publishDateFrom,
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.right,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: timelineData == null ? 0 : timelineData.length,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // newData['data']['category'][0]['products'][0]['product_title']
            ],
          ),
        );
      },
      itemCount: newData.isEmpty ? 0 : newData.length,
    );
  }

  timeLineDetailRoute(data, newData) {
    var premiumAcc = box.read('isPremium');
      if (premiumAcc == true || data.isPremium == false) {
          if (data.linkType == 'product') {
            Get.to(() => const MovieDetailPage(), arguments: data.productLink.split('/')[1]);
          } else if (data.linkType == 'blog' || data.linkType == 'article') {
            Get.to(() => const WebviewPage(), arguments: [data.blogLink, 'article']);
          } else if (data.linkType == 'detail') {
            Get.to(() => const WebviewPage(), arguments: [data.id, 'timeline']);
          }
                          
      } else {
          showPremiumAlert(context);
      }
  }
}




