import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/articlecat_controller.dart';
import 'package:msa/views/article/article_top_detail.dart';
import 'package:msa/widgets/loading_widget.dart';

class ArticleCategory extends StatefulWidget {
  const ArticleCategory({Key? key}) : super(key: key);

  @override
  State<ArticleCategory> createState() => _ArticleCategoryState();
}

class _ArticleCategoryState extends State<ArticleCategory> {
  final ArticleCategoryController _con = Get.put(ArticleCategoryController());

  @override
  void initState() {
    _con.getArticleCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ArticleCategoryController(),
        builder: (context) {
          return Obx(() => _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.categories.isEmpty)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : articleCatBody());
        });
  }

  articleCatBody() {
    return ListView.builder(
      itemCount: _con.categories.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(_con.categories[index].categoryName,
                  style: catTitleStyle),
              contentPadding: EdgeInsets.zero,
              dense: true,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: black,
              ),
              onTap: () {
                setState(() {
                  Get.to(() => const ArticleTopDetail(),
                      arguments: [
                        _con.categories[index].id,
                        _con.categories[index].categoryName
                      ],
                      transition: Transition.rightToLeft);
                });
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
