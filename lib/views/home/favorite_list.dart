import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/controller/playlist_controller.dart';
import 'package:msa/views/home/movie_detail.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/showpremiumalert.dart';

class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({Key? key}) : super(key: key);

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  final PlayListController _con = Get.put(PlayListController());
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  var box = GetStorage();

  @override
  void initState() {
    _con.getPlayList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: PlayListController(),
        builder: (context) {
          return Obx(() => _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.playlists.isEmpty)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : playListBody());
        });
  }

  playListBody() {
    var premiumAcc = box.read('isPremium');
    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _con.playlists.length,
        itemBuilder: (context, indexAt) {
          var productData = _con.playlists[indexAt];
          return Padding(
            padding: EdgeInsets.only(bottom: height * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productData.categoryName.toString(),
                  style: movielistCatStyle,
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: productData.playlist.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                              onTap: (() {
                                if (premiumAcc == true ||
                                    productData.playlist[index].product.isPremium == false) {
                                  Get.to(() => const MovieDetailPage(),
                                      arguments: productData.playlist[index].product.id);
                                } else {
                                  showPremiumAlert(context);
                                }
                              }),
                              child: Card(
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
                                                imageUrl: productData.playlist[index].product.profileImage,
                                                height: height*0.1325,
                                                width: width*0.30,
                                                fit: BoxFit.fill,
                                              ),
                                            // child: CachedNetworkimage(
                                            //     height: 55, width: 0, imageUrl: productData.playlist[index].product.profileImage),
                                          ),
                                        ),
                                        Visibility(
                                          visible: !productData.playlist[index].product.isPremium,
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
                                              productData.playlist[index].product.productTitle,
                                              maxLines: 2,
                                              style: formTitleStyle,
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
                                                        productData.playlist[index].product.movieDuration,
                                                        style: movieCountTextStyle,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      var product = productData.playlist[index].product;
                                                      var success = await _activityCon.updateIsOnPlaylist([product.id,'article'], product.isOnPlaylist);
                                                      if(success) {
                                                        setState(() {
                                                          product.isOnPlaylist = !product.isOnPlaylist;
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: productData.playlist[index].product.isOnPlaylist ? primaryColor : grey,
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
                                                  )
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      InkWell(
                                        
                                        onTap: () async {
                                              var product = productData.playlist[index].product;
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
                                              backgroundColor: productData.playlist[index].product.isChecked == true ? primaryColor : grey,
                                              child: const Icon(
                                                 Icons.check,
                                                color: white,
                                                size: 15,
                                              ),
                                          ),
                                          // child: CircleAvatar(
                                          // radius: 15,
                                          //  backgroundColor: productData.playlist[index].product.isChecked ? primaryColor : white,
                                          //   child: const  Icon(
                                          //     Icons.check, 
                                          //     color: white,
                                          //     size: 15,
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              )
                          ),
                          productData.playlist.length > index + 1
                              ? const Divider(
                                height: 20,
                                thickness: 1,
                              )
                              : const SizedBox(),
                        ],
                      );
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}
