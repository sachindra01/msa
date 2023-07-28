import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msa/common/styles.dart';

//Widgets for item tiles on Article Top Detail Pages (Article Category Details), and Article Favourite Page

buildfavItemTile(BuildContext context, double width, String imageUrl,
    String title, bool isVisible, bool isFavourite) {
  return Column(
    children: [
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
                      width: width * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage(
                          // height: 80,
                          placeholderFit: BoxFit.cover,
                          image: NetworkImage(imageUrl),

                          placeholder: const AssetImage(
                            'assets/images/no_image_new.png',
                          ),

                          fit: BoxFit.fitWidth,

                          // height: 100.0,
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
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      title,
                      style: catTitleStyle,
                    )),
              ],
            ),
            CircleAvatar(
              backgroundColor: isFavourite ? buttonPrimaryColor : grey,
              radius: 14.0,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.favorite,
                  size: 16,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      const Divider(),
    ],
  );
}
