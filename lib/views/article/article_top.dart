import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/articletop_controller.dart';
import 'package:msa/views/article/article_top_detail.dart';
import 'package:msa/widgets/itemtile_widget.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/showpremiumAlert.dart';
import 'package:msa/widgets/webview_page.dart';

class ArticleTop extends StatefulWidget {
  const ArticleTop({Key? key}) : super(key: key);

  @override
  State<ArticleTop> createState() => _ArticleTopState();
}

class _ArticleTopState extends State<ArticleTop> {
  final ArticleTopController _con = Get.put(ArticleTopController());
  var box = GetStorage();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.getArticleTop();
    });
    
    // _scon.type.value = 'blogs';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ArticleTopController(),
        builder: (context) {
          return Obx(() => _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.articles.isEmpty)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  :articleTopBody());
                  // : _scon.searchBoxEnabled.value == false
                  //     ? articleTopBody()
                  //     : const SearchPage());
        });
  }

  articleTopBody() {
    var premiumAcc = box.read('isPremium');
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _con.articles.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                        text: _con.articles[index].categoryName,
                        style: movielistCatStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text: '  (' +
                                  _con.articles[index].blogsCount.toString() +
                                  ')',
                              style: blogCountTextStyle)
                        ]),
                  ),
                ],
              ),
            ),
            //const Divider(),
            SizedBox(
              width: double.infinity,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _con.articles[index].blogs.length,
                scrollDirection: Axis.vertical,
                separatorBuilder: (ctx,idx) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: (() {
                        if (premiumAcc == true) {
                          Get.to(() => const WebviewPage(), arguments: [
                            _con.articles[index].blogs[i].id,
                            'article'
                          ]);
                        } else if (_con.articles[index].blogs[i].isPremium ==
                            false) {
                          Get.to(() => const WebviewPage(), arguments: [
                            _con.articles[index].blogs[i].id,
                            'article'
                          ]);
                        } else if (_con.articles[index].blogs[i].isPremium ==
                            false) {
                          Get.to(() => const ArticleTopDetail());
                          
                        } else {
                          showPremiumAlert(context);
                        }
                      }),
                      child: buildItemTile(
                         
                          width,
                          _con.articles[index].blogs[i].profileImage,
                          _con.articles[index].blogs[i].isPremium,
                          _con.articles[index].blogs[i].blogTitle,
                          context
                          ));
                },
              ),
            ),
           
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('続きを見る', style: viewMorebuttonStyle),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: black,
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  primary: Colors.black45,
                  onSurface: Colors.black45,
                  side: const BorderSide(color: Colors.black54, width: 1),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 6.0, top: 4.0, bottom: 4.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
                onPressed: () {
                  Get.to(() => const ArticleTopDetail(),
                      arguments: [
                        _con.articles[index].id,
                        _con.articles[index].categoryName
                      ],
                      transition: Transition.rightToLeft);
                  // Navigator.of(context).pushNamed('/articleTopDetail',
                  //     arguments: _con.articles[index].id.toString());
                },
              ),
            ),
            const  Divider(),
          ],
        );
      },
    );
  }
}
