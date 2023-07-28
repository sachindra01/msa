// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';

//widget for Item Tiles on Article Top Page

buildItemTile(double width, String imageUrl, bool isPremium, String title,BuildContext context) {
  // var height = MediaQuery.of(context).size.height -
  //       300 -
  //       (MediaQuery.of(context).padding.top + kToolbarHeight);
  return Card(
    color: Colors.transparent,
    margin: EdgeInsets.zero,
    elevation: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          clipBehavior: Clip.hardEdge,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 0),
              child: SizedBox(
                  // width: MediaQuery.of(context).size.width*0.25,
                  height: MediaQuery.of(context).size.height * 0.09,
                  // color:red,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkimage(
                        imageUrl: imageUrl,
                         // use this
                      ),
                    ),
                  ),
                ),
            ),
            Visibility(
              visible: !isPremium ? true : false,
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
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: catTitleStyle,
              textAlign: TextAlign.justify,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}


// Card(
//                                 color: Colors.transparent,
//                                 margin: EdgeInsets.zero,
//                                 elevation: 0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 10, bottom: 0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Stack(children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(left: 0, right: 5),
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(5),
//                                              child: CachedNetworkImage(
//                                                 imageUrl: productData.playlist[index].product.profileImage,
//                                                 height: height*0.1325,
//                                                 width: width*0.30,
//                                                 fit: BoxFit.fill,
//                                               ),
//                                             // child: CachedNetworkimage(
//                                             //     height: 55, width: 0, imageUrl: productData.playlist[index].product.profileImage),
//                                           ),
//                                         ),
//                                         Visibility(
//                                           visible: !productData.playlist[index].product.isPremium,
//                                           child: Positioned.fill(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//                                               child: Align(
//                                                 alignment: Alignment.bottomLeft,
//                                                 child: Container(
//                                                   width: 20,
//                                                   height: 20,
//                                                   padding: const EdgeInsets.all(2),
//                                                   decoration: BoxDecoration(
//                                                       color: black,
//                                                       border: Border.all(
//                                                         color: Colors.yellow,
//                                                       ),
//                                                       borderRadius:
//                                                           const BorderRadius.all(Radius.circular(5))),
//                                                   child: SvgPicture.asset(
//                                                     'assets/images/premium-tag.svg',
//                                                     width: 10,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ]),
//                                       Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             width: width * 0.50,
//                                             child: Text(
//                                               productData.playlist[index].product.productTitle,
//                                               maxLines: 2,
//                                               style: formTitleStyle,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(bottom: 8),
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.redAccent,
//                                                       border: Border.all(
//                                                         color: Colors.white,
//                                                       ),
//                                                       borderRadius:
//                                                           const BorderRadius.all(Radius.circular(5))),
//                                                   width: 40,
//                                                   height: 16,
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                     children: [
//                                                       const Icon(
//                                                         Icons.access_time,
//                                                         color: Colors.white,
//                                                         size: 10,
//                                                       ),
//                                                       Text(
//                                                         productData.playlist[index].product.movieDuration,
//                                                         style: movieCountTextStyle,
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 5),
//                                                   child: InkWell(
//                                                     onTap: () async {
//                                                       var product = productData.playlist[index].product;
//                                                       var success = await _activityCon.updateIsOnPlaylist([product.id,'article'], product.isOnPlaylist);
//                                                       if(success) {
//                                                         setState(() {
//                                                           product.isOnPlaylist = !product.isOnPlaylist;
//                                                         });
//                                                       }
//                                                     },
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         color: productData.playlist[index].product.isOnPlaylist ? primaryColor : grey,
//                                                         border: Border.all(
//                                                           color: Colors.white,
//                                                         ),
//                                                         borderRadius: const BorderRadius.all(Radius.circular(5))
//                                                       ),
//                                                       width: 80,
//                                                       height: 16,
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                         children: const [
//                                                           Icon(
//                                                             Icons.favorite,
//                                                             color: Colors.white,
//                                                             size: 10,
//                                                           ),
//                                                            Text(
//                                                             " お気に入り",
//                                                             style: movieCountTextStyle,
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       InkWell(
                                        
//                                         onTap: () async {
//                                               var product = productData.playlist[index].product;
//                                               var success = await _activityCon.updateIsCheck([product.id,'article'], product.isChecked);
//                                               if(success) {
//                                                 setState(() {
//                                                   product.isChecked = !product.isChecked;
//                                                 });
//                                               }
//                                             },
//                                         child: Padding(
//                                           padding:  EdgeInsets.only( left:MediaQuery.of(context).size.width*0.03),
//                                            child: CircleAvatar(
//                                               radius: 15,
//                                               backgroundColor: productData.playlist[index].product.isChecked == true ? primaryColor : grey,
//                                               child: const Icon(
//                                                  Icons.check,
//                                                 color: white,
//                                                 size: 15,
//                                               ),
//                                           ),
//                                           // child: CircleAvatar(
//                                           // radius: 15,
//                                           //  backgroundColor: productData.playlist[index].product.isChecked ? primaryColor : white,
//                                           //   child: const  Icon(
//                                           //     Icons.check, 
//                                           //     color: white,
//                                           //     size: 15,
//                                           //   ),
//                                           // ),
//                                         ),
//                                       ),
                                      
//                                     ],
//                                   ),
//                                 ),
//                               )
