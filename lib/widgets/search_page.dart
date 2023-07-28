import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/views/home/movie_detail.dart';
import 'package:msa/views/home/radio_detail.dart';

import 'package:msa/widgets/searcheditemtile_widget.dart';
import 'package:msa/widgets/showpremiumalert.dart';
import 'package:msa/widgets/webview_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _con = Get.put(SearchController());
  final _activitycon = Get.put(LikeUnlikeFavController());
  final box = GetStorage();

  @override
  void initState() {
    _con.movieList.clear();
    if (_con.textcon.value.text.trim() != '') {
      _con.searchMovieList();
    }

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var premiumAcc = box.read('isPremium');

    var height = MediaQuery.of(context).size.height -
        300 -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Flexible(
              child: GetBuilder(
                  init: SearchController(),
                  builder: (context) {
                    return Obx(() => ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _con.movieList.length,
                        itemBuilder: (context, index) {
                          
                          final movie = _con.movieList[index];
                          // final user = userController.userList[index];
                          return Padding(
                              padding: EdgeInsets.only(bottom: height * 0.025),

                              child: _con.type.value == 'movie' || _con.type.value == 'radio'
                              //Movie And Radio Search
                                  ? GestureDetector(
                                      onTap: (() {
                                      FocusManager.instance.primaryFocus!.unfocus;
                                      if(_con.type.value == 'movie') {  
                                        if (premiumAcc == true) {
                                          Get.to(() => const MovieDetailPage(),
                                              arguments: movie.id);
                                        } else if (movie.isPremium == false) {
                                          Get.to(() => const MovieDetailPage(),
                                              arguments: movie.id);
                                        } else {
                                         showPremiumAlert(context);
                                        } }else{
                                            if (premiumAcc == true) {
                                          Get.to(() =>  RadioDetailPage(data: movie,),
                                             );
                                        } else if (movie.isPremium == false) {
                                           Get.to(() =>  RadioDetailPage(data: movie,),);
                                        } else {
                                          showPremiumAlert(context);
                                        } 
                                        }
                                      }),
                                      child: _con.type.value == 'movie' 
                                      //Movie Search Tile
                                      ? buildmoviesearchTile(
                                        height,
                                        width,
                                        movie.id,
                                        movie.profileImage,
                                        movie.isPremium,
                                        movie.productTitle,
                                        movie.movieDuration,
                                        movie.isOnPlaylist,
                                        )
                                        //Radio Search Tile
                                      :  buildmoviesearchTile(
                                        height,
                                        width,
                                        movie.id,
                                        movie.profileImage,
                                        movie.isPremium,
                                        movie.radioTitle,
                                        '0',
                                        movie.liked

                                      )
                                    )
                                    //Search For Blogs/Article
                                  : _con.type.value == 'blogs'
                                      ? InkWell(
                                          onTap: (() {
                                            if (premiumAcc == true) {
                                              Get.to(() => const WebviewPage(),
                                                  arguments: [
                                                    movie.id,
                                                    'article'
                                                  ]);
                                            } else if (movie.isPremium ==
                                                false) {
                                              Get.to(() => const WebviewPage(),
                                                  arguments: [
                                                    movie.id,
                                                    'article'
                                                  ]);
                                            } else {
                                             showPremiumAlert(context);
                                            }
                                          }),
                                          //Article Search Tile
                                          child: searchCategoryTile(
                                              height,
                                              width,
                                              movie.id,
                                              movie.profileImage,
                                              movie.isPremium,
                                              movie.blogTitle,
                                              movie.isFavorite,
                                              index),
                                        )

                                        //Time Line Search
                                      : InkWell(
                                          onTap: (() {
                                            if (premiumAcc == true) {
                                              timeLineDetailRoute(movie);
                                            } else if (movie.isPremium == false) {
                                              timeLineDetailRoute(movie);
                                            } else {
                                              showPremiumAlert(context);
                                            }
                                          }),
                                          child: searchTimeLineTile(
                                              width,
                                              movie.id,
                                              movie.profileImage,
                                              movie.isPremium,
                                              movie.timelineTitle,
                                              movie.shortDescription,
                                              movie.isFavorite,
                                              index),
                                        ));
                        }));
                  }))
        ],
      ),
    );
  }
  //timeline route
  timeLineDetailRoute(data) {
    FocusManager.instance.primaryFocus!.unfocus();
    if (data.linkType == 'product') {
      Get.to(() => const MovieDetailPage(), arguments: data.productLink);
    } else if (data.linkType == 'blog' || data.linkType == 'article') {
      Get.to(() => const WebviewPage(), arguments: [data.blogLink, 'article']);
    } else if (data.linkType == 'detail') {
      Get.to(() => const WebviewPage(), arguments: [data.id, 'timeline']);
    }
  }
  searchCategoryTile(
      height, width,  id,  profileImg,  isVisible,  title,  isFavorite,  index) {
 //   RxBool fav = isFavorite.obs;
    return Column(
      children: [
        const Divider(
          height: 0.5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 5),
                      child: SizedBox(
                        // width: width * 0.25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkimage(
                              imageUrl: profileImg,
                              height: height*0.1325,
                              width: width * 0.30,
                            ),
                         
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isVisible,
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
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        title,
                        style: catTitleStyle,
                      )),
                ],
              ),
              CircleAvatar(
                backgroundColor:
                      isFavorite ? buttonPrimaryColor : grey,
                radius: 15.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon:  const Icon(Icons.favorite,
                      size: 16,
                       color: Colors.white ),
                   onPressed: () async {
                      bool isFav = isFavorite == true ? false : true;
                   
                    var success =  await _activitycon.favorite([id, 'article'], isFav);
                    if(success == true) {
                      setState(() { 
                        _con.movieList[index].isFavorite = isFav;
                      });
                    }
                  },
                ),
              ),
              // Obx(
              //   ()=> CircleAvatar(
              //   backgroundColor:
              //        fav.value ? buttonPrimaryColor : grey,
              //   radius: 15.0,
              //   child: IconButton(
              //     padding: EdgeInsets.zero,
              //     icon:  const Icon(Icons.favorite,
              //         size: 16,
              //           color:white),
              //      onPressed: () async {
              //       var success = await _activitycon.favorite([id, 'article'], fav.value);
              //       if(success == true) {
              //         setState(() { 
              //           fav.value = !fav.value;
              //         });
              //       }
              //     },
              //   ),
              // ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  searchTimeLineTile(
      width, id, profileImg, isVisible, title, subtitle, isFavorite, index) {
      // var height = MediaQuery.of(context).size.height -
      //  300 - (MediaQuery.of(context).padding.top + kToolbarHeight);
      var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Divider(
          height: 0.5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: SizedBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                                    imageUrl: profileImg,
                                    height: MediaQuery.of(context).size.height*0.09,
                                    width: width*0.30,
                                    fit: BoxFit.cover,
                                  ),
                        
                          // ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isVisible,
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
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: catTitleStyle,
                          ),
                          Text(
                            subtitle ?? '',
                            style: catChatTitleStyle,
                          )
                        ],
                      )),
                ],
              ),
              CircleAvatar(
                backgroundColor:
                      isFavorite ? buttonPrimaryColor : grey,
                radius: 15.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon:  const Icon(Icons.favorite,
                      size: 16,
                       color: Colors.white ),
                   onPressed: () async {
                      bool isFav = isFavorite == true ? false : true;
                   
                    var success =  await _activitycon.favorite([id, 'timeline'], isFav);
                    if(success == true) {
                      setState(() { 
                        _con.movieList[index].isFavorite = isFav;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
