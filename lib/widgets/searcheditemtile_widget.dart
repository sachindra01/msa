// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';

 final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());

buildmoviesearchTile(
  double height,
  double width,
  int id,
  String imageUrl,
  bool isVisible,
  String title,
  String movieDuration,
  bool isLiked,
) {
  RxBool x = isLiked.obs;
  return Column(
    children: [
      const Divider(
        height: 0.5,
        thickness: 1,
      ),
      Card(
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 0,left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,right: 5
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: height*0.13,
                      width: width*0.30,
                      fit: BoxFit.fill,
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
                          height: 16,
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
              const SizedBox(width: 8,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.58,
                    child: Text(
                      title,
                      maxLines: 2,
                      style: catTitleStyle,
                    ),
                  ),
                  Visibility(
                    visible: movieDuration == '0' ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only( bottom: 8),
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
                                  movieDuration,
                                  
                                  style: movieCountTextStyle,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: InkWell(
                               onTap: () async {
                                  var success = await _activityCon.updateIsOnPlaylist([id,'movie'], x.value);
                                  if(success) {
                                       x.value = !x.value;
                                     } },
                              child:  Obx(()=>Container(
                                     decoration: BoxDecoration(
                                    color: x.value ? primaryColor : grey,
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5))),
                                width: 80,
                                height: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:  const[
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
                              )),
                             
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
