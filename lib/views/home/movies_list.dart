import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/controller/product_list_controller.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/views/home/movie_detail.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/search_page.dart';
import 'package:msa/widgets/showpremiumalert.dart';

// import '../../videooverlay/overlay_service.dart';

class MoviesListPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final searchboxEnabled;
  const MoviesListPage(this.searchboxEnabled, {Key? key}) : super(key: key);

  @override
  _MoviesListPageState createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {
  final ProductListController _con = Get.put(ProductListController());
  final SearchController _scon = Get.put(SearchController());
  final AuthController _authCon = Get.put(AuthController());
  var box = GetStorage();

  @override
  void initState() {
    _scon.type.value = 'movie';
     _authCon.checkTokenValidity(context);
    _con.getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ProductListController(),
        builder: (context) {
          return Obx(() => _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.category.isEmpty)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : _scon.searchBoxEnabled.value == false || _scon.keyword.value == ''
                      ? movieListBody()
                      : const SearchPage());
        });
  }
//  _addVideoWithTitleOverlay(data) {
//     OverlayService().addVideoTitleOverlay(context,  VideoPlayerTitlePage(args: data,));
//   }
  movieListBody() {
    var premiumAcc = box.read('isPremium');
    return ListView.builder(
      itemBuilder: (context, index) {
        var productData = _con.category[index].products;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  SizedBox(
                    child: Text(
                      _con.category[index].categoryName,
                      style: catTitleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 22.0,
                    child: ElevatedButton(
                      onPressed: () {
                      //  _addVideoWithTitleOverlay(productData[0].id);
                        if (premiumAcc == true || productData[0].isPremium == false) {
                          Get.to(() => const MovieDetailPage(),
                            arguments: [productData[0].id, productData[0].movieCode]
                          );
                        } else {
                           showPremiumAlert(context);
                        }
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16, 
                        color: primaryColor
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(4),
                        primary: Colors.white, // <-- Button color
                        onPrimary: primaryColor, // <-- Splash color
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.22,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return productData[i].movieCategory == 1 ? InkWell(
                    onTap: (() {
                      if (premiumAcc == true || productData[i].isPremium == false) {
                        Get.to(() => const MovieDetailPage(),
                            arguments: [productData[i].id, productData[i].movieCode]);
                      } else {
                        showPremiumAlert(context);
                      }
                    }),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              fit: StackFit.passthrough,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    height: MediaQuery.of(context).size.height*0.128,
                                    width: MediaQuery.of(context).size.width * 0.52,
                                    fit: BoxFit.fill,
                                    imageUrl: productData[i].profileImage,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/no_image_new.png',
                                      fit: BoxFit.fill,
                                    ),
                                    errorWidget: (context, url,_)=>Image.asset(
                                      'assets/images/no_image_new.png',
                                      fit: BoxFit.fill,
                                    ),
                                    
                                  ),
                                ),
                                 Visibility(
                                    visible: !productData[i].isPremium,
                                    child: Positioned.fill(
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
                                    ),
                                  ),
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        width: 40,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                            Text(
                                              productData[i]
                                                  .movieDuration
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  productData[i].productTitle,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.justify,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ) : const SizedBox();
                },
                itemCount: productData == null ? 0 : productData.length,
              ),
            )
          ],
        );
      },
      itemCount: _con.category.isEmpty ? 0 : _con.category.length,
    );
  }
}
