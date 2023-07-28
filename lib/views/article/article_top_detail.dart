import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/articletop_controller.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/music_player_widget.dart';
import 'package:msa/widgets/showpremiumAlert.dart';
import 'package:msa/widgets/webview_page.dart';

class ArticleTopDetail extends StatefulWidget {
  const ArticleTopDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<ArticleTopDetail> createState() => _ArticleTopDetailState();
}

class _ArticleTopDetailState extends State<ArticleTopDetail> {
  final ArticleTopController _con = Get.put(ArticleTopController());
  final LikeUnlikeFavController _activityCon =
      Get.put(LikeUnlikeFavController());
  var box = GetStorage();

  var args = Get.arguments;
  @override
  void initState() {
    _con.getArticleCatSearchList(args[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          args[1],
          style: catTitleStyle,
        ),
        backgroundColor: white,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: GetBuilder(
          init: ArticleTopController(),
          builder: (context) {
            return Obx(() => _con.isCatSearchLoading.value == true
                ? Center(child: loadingWidget())
                : _con.searchCategories.isEmpty
                    ? const Center(
                        child: Text("該当データがありません"),
                      )
                    : articleTopDetailsBody());
          }),
    );
  }

  articleTopDetailsBody() {
    var premiumAcc = box.read('isPremium');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: _con.searchCategories.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: (() {
                    if (premiumAcc == true ||
                        _con.searchCategories[index].isPremium == false) {
                      Get.to(() => const WebviewPage(),
                          arguments: [_con.searchCategories[index].id, 'article']);
                    } else {
                      showPremiumAlert(context);
                    }
                  }),
                  child: searchCategoryTile(
                      height,
                      width,
                      _con.searchCategories[index].id,
                      _con.searchCategories[index].profileImage,
                      !_con.searchCategories[index].isPremium,
                      _con.searchCategories[index].blogTitle,
                      _con.searchCategories[index].isFavorite,
                      index)
              );
            },
          ),
        ),  const Positioned(
                       bottom: 0,
                       child:  Player()),]
      ),
    );
  }

  searchCategoryTile(height,width, id, profileImg, isVisible, title, isFavorite, index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkimage(
                          imageUrl: profileImg,
                          // fit: BoxFit.fill,
                          //  placeholder: (context, url) => Image.asset(
                          //   'assets/images/no_image_new.png',
                          //   width: width*0.3,
                          //   fit: BoxFit.fill,
                          // )
          
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
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
                padding: const EdgeInsets.only(right: 5),
        
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
                      var success =
                          await _activityCon.favorite([id, 'article'], isFav);
                      if (success == true) {
                        setState(() {
                          _con.searchCategories[index].isFavorite = isFav;
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
