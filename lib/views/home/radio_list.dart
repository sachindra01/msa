import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/radio_list_controller.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/views/home/radio_detail.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/search_page.dart';
import 'package:msa/widgets/showpremiumalert.dart';
class RadioListPage extends StatefulWidget {
  const RadioListPage({Key? key}) : super(key: key);

  @override
  State<RadioListPage> createState() => _RadioListPageState();
}

class _RadioListPageState extends State<RadioListPage> {
  final RadioController _con = Get.put(RadioController());
  final SearchController _scon = Get.put(SearchController());
  var box = GetStorage();
  var items = [];
  bool premiumAcc = true;

  @override
  void initState() {
    _scon.type.value = 'radio';
    _con.getRadioList();
    _scon.movieList.clear();
    super.initState();
    premiumAcc = box.read('isPremium');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RadioController(),
      builder: (context) {
        return Obx(() => _con.isLoading.value == true
          ? Center(child: loadingWidget())
          : (_con.radios.isEmpty && _con.recommended.isEmpty)
          ? const Center(
            child: Text("該当データがありません"),
          )
          : _scon.searchBoxEnabled.value == false || _scon.keyword.value == ''
          ? Align(
            alignment: Alignment.topCenter,
            child:radioListBody()
          )
          : const SearchPage()
        );
      }
    );
  }

  radioListBody() {
    for (int i = 0; i < _con.recommended.length; i++) {
      items.add(_con.recommended[i].radioTitle);
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _con.recommended.isNotEmpty ?
          const Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Text(
              "おすすめ放送",
              style: catTitleStyle,
            ),
          ): const SizedBox(),
          _con.recommended.isNotEmpty ?
          SizedBox(
              height: MediaQuery.of(context).size.height*0.065 * (_con.recommended.length % 3 ==  0 ? 3 : _con.recommended.length > 3? 3 : _con.recommended.length%3),
            //  width: MediaQuery.of(context).size.width*1,
            child: carousel(
              MediaQuery.of(context).size.width * 1,
            ),
          ) : const SizedBox(),
          const Padding(
            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
            child: Text(
              "ラジオリスト",
              style: movielistCatStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            //  height: MediaQuery.of(context).size.height  ,
            child: ListView.builder(
              itemCount: _con.radios.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: ((context, index) {
                var radios = _con.radios[index];
                return GestureDetector(
                  onTap: () {
                    if (premiumAcc == true) {
                      Get.to(()=> RadioDetailPage(data: radios));
                      // Navigator.pushNamed(context, '/radio/detail',
                      //     arguments: radios);
                    } else if (radios.isPremium == false) {
                      Get.to(()=> RadioDetailPage(data: radios));
                    } else {
                      showPremiumAlert(context);
                    }
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 241, 239, 239),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                    child: Stack(
                      fit: StackFit.loose,
                      // alignment: Alignment.topCenter,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1,
                          height:MediaQuery.of(context).size.height * 0.25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkimage(
                              imageUrl: radios.profileImage,
                              // width: 600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0.1, 150, 0.1, 0),
                          child: SizedBox(
                            // height: MediaQuery.of(context).size.height * 0.11,
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 30),
                                          child: Text(
                                            DateTime.parse(radios.publishDateFrom.toString()).year.toString()
                                            +"."+ DateTime.parse(radios.publishDateFrom.toString()).month.toString()
                                            +"."+ DateTime.parse(radios.publishDateFrom.toString()).day.toString(), 
                                            // radios.category.createdAt
                                            //     .toString(),
                                            style: catChatTitleStyle,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Text(
                                            radios.radioTitle,
                                            style: catTitleStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Play button
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.amber[400],
                                      radius: 25,
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: white,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                ]
                              ),
                            ),
                          ),
                        ),
                        radios.categoryName != '' ? Padding(
                          padding: const EdgeInsets.fromLTRB(12, 140, 80, 0),
                          child: Container(
                            // height: 20,
                            decoration: BoxDecoration(
                              color: catTitleyColor,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                              child: Text(
                                radios.categoryName,
                                style: reportTitleStyle,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            )
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                );
              })
            ),
          ),
        ],
      ),
    );
  }

  carousel(width) {
    var height = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _con.recommended.length > 3 ? 3 : (_con.recommended.length),
        // crossAxisCount: 2,
        childAspectRatio:   _con.recommended.length<= 3 ? height*0.00018 : height*0.00025  
      ),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _con.recommended.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: ((context, index) {
        return SizedBox(
          // height: 30,
          // width: MediaQuery.of(context).size.width * 65,
          // color: red,
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  if (premiumAcc == true) {
                    Get.to(()=> RadioDetailPage(data: _con.recommended[index],), );
                    // Navigator.pushNamed(context, '/radio/detail',
                    //     arguments: radios);
                  } else if (_con.recommended[index].isPremium == false) {
                      Get.to(()=> RadioDetailPage(data: _con.recommended[index],),);
                  } else {
                    showPremiumAlert(context);
                  }
                },
                child: SizedBox(
                  // height: 65,
                  child: SizedBox(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    child: CachedNetworkimage(
                                      height: height*0.07,
                                      width: height*0.11,
                                      
                                      imageUrl: _con
                                          .recommended[index%_con.recommended.length].profileImage,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                        child: SizedBox(
                                          width: width*0.30,
                                          child: Text(
                                            _con.recommended[index%_con.recommended.length].radioTitle,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: height*0.015, color: catTitleyColor, fontWeight: FontWeight.w700),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.25,
                            ),
                            child: const Divider(
                              height: 1,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.15,
                  top: MediaQuery.of(context).size.height * 0.042
                ),
                child: InkWell(
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: white,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.amber[400],
                      child: const Icon(
                        Icons.play_arrow,
                        color: white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        );
      }),
    );
  }
}
