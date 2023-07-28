import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/articlefavourite_controller.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/showpremiumAlert.dart';
import 'package:msa/widgets/webview_page.dart';

import '../../common/cached_network_image.dart';

class ArticleFavorite extends StatefulWidget {
  const ArticleFavorite({Key? key}) : super(key: key);

  @override
  State<ArticleFavorite> createState() => _ArticleFavoriteState();
}

class _ArticleFavoriteState extends State<ArticleFavorite> {
  final ArticleFavouriteController _con = Get.put(ArticleFavouriteController());
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());

  var box = GetStorage();
  @override
  void initState() {
    _con.getArticleFavouriteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ArticleFavouriteController(),
        builder: (context) {
          return Obx(() => _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.favourites.isEmpty)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : articleFavBody());
        });
  }

  articleFavBody() {
    var premiumAcc = box.read('isPremium');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: _con.favourites.length,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var currentFavBlog = _con.favourites[index];
          return InkWell(
            onTap: (() {
              if (premiumAcc == true) {
                Get.to(() => const WebviewPage(), arguments: [currentFavBlog.blog.id, 'article']);
              } else if (currentFavBlog.blog.isPremium == false) {
                Get.to(() => const WebviewPage(), arguments: [currentFavBlog.blog.id, 'article']);
              } else {
                 showPremiumAlert(context);
              }
            }),
            child: searchCategoryTile(
              height,
              width,
              currentFavBlog.blog.id, 
              currentFavBlog.blog.profileImage, 
              !currentFavBlog.blog.isPremium,
              currentFavBlog.blog.blogTitle,
              currentFavBlog.blog.isFavorite,
              index
            )
          );
        },
      ),
    );
  }

  searchCategoryTile(height,width, id, profileImg, isVisible, title, isFavorite, index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 5),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                         child: CachedNetworkimage(
                           imageUrl: profileImg,
                          // width: width*0.28,
                          // height: height*0.1425,
                        ),
                          //child: CachedNetworkimage(height: 60,width: 600,imageUrl: profileImg,),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isVisible,
                      child: Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              // color: Colors.black,
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
                  const SizedBox(width: 5.0),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: catTitleStyle,
                      )),
                ],
              ),
               Container(
                padding: const EdgeInsets.only(right: 0),
        
                child: CircleAvatar(
                  backgroundColor:
                      isFavorite ? buttonPrimaryColor : Colors.grey,
                  radius: 15.0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.favorite,
                        size: 16,
                        color: Colors.white ),
                     onPressed: () async {
                      bool isFav = isFavorite == true ? false : true;
                      var success = await _activityCon.favorite([id,'article'], isFav);
                      if(success == true) {
                        setState(() { 
                          _con.favourites.removeAt(index);
                        });
                      }
                    },
                  ),
                ),
              ),
             
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

}
