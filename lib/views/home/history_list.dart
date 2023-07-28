import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/history_controller.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/views/home/movie_detail.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/showpremiumalert.dart';

class HistoryListPage extends StatefulWidget {
  const HistoryListPage({Key? key}) : super(key: key);

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  final HistoryController _con = Get.put(HistoryController());
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  var box = GetStorage();

  @override
  void initState() {
    _con.getHistoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HistoryController(),
      builder: (x) {
        return Obx(() => _con.isLoading.value == true
          ? Center(child: loadingWidget())
          : (_con.historyLists.isEmpty)
            ? const Center(
                child: Text("該当データがありません"),
              )
            : historyListBody()
        );
      }
    );
  }

  historyListBody() {
    var premiumAcc = box.read('isPremium');
    var height = MediaQuery.of(context).size.height - 300 - (MediaQuery.of(context).padding.top + kToolbarHeight);
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: _con.historyLists.length,
          itemBuilder: (context, index) {
            var productData = _con.historyLists[index];
            return GestureDetector(
              onTap: (() {
                if (premiumAcc == true ||
                    productData.product.isPremium == false) {
                  Get.to(() => const MovieDetailPage(),
                      arguments: productData.product.id);
                } else {
                  showPremiumAlert(context);
                }
              }),
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.transparent,
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0, right: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: productData.product.profileImage,
                                    height: height*0.1325,
                                    width: width*0.30,
                                    fit: BoxFit.fill,
                                  ),
                                  // child: CachedNetworkimage(
                                  //     height: 50, width: 80, imageUrl: productData.product.profileImage),
                                ),
                              ),
                              Visibility(
                                visible: !productData.product.isPremium,
                                child: Positioned.fill(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        width: 20,
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
                                ),
                              ),
                            ]),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width * 0.50,
                                  child: Text(
                                    productData.product.productTitle,
                                    maxLines: 2,
                                    style: catTitleStyle,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(Radius.circular(5))),
                                        width: 40,
                                        height: 16,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                            Text(
                                              productData.product.movieDuration,
                                              style: movieCountTextStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: InkWell(
                                          onTap: () async {
                                            bool condition = isItOnPlayList(productData.isOnPlaylist);
                                            var success = await _activityCon.updateIsOnPlaylist([productData.product.id,'article'], condition);
                                            if(success) {
                                              setState(() {
                                                productData.isOnPlaylist = (condition == true ? "0" : "1");
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isItOnPlayList(productData.isOnPlaylist) ? primaryColor : grey,
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(5))
                                            ),
                                            width: 80,
                                            height: 16,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                 Text(
                                                  " お気に入り",
                                                  style: movieCountTextStyle,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            InkWell(         
                                onTap: () async {
                                      var product = productData.product;
                                      var success = await _activityCon.updateIsCheck([product.id,'article'], product.isChecked);
                                      if(success) {
                                        setState(() {
                                          product.isChecked = !product.isChecked;
                                        });
                                      }
                                    },
                                child: Padding(
                                   padding:  EdgeInsets.only( left:MediaQuery.of(context).size.width*0.03),
                                  child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: productData.product.isChecked == true ? primaryColor : grey,
                                      child: const Icon(
                                         Icons.check,
                                        color: white,
                                        size: 15,
                                      ),
                                  ),
                                ),
                              ),
                            
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 5,
                      thickness: 2,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  isItOnPlayList(playList) {
    if(playList == "1" || playList == null )  {
      return true;
    } else if(playList == "0"){
      return false;
    } else {
      return false;
    }

  }

}
