import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/views/article/article_category.dart';
import 'package:msa/views/article/article_favorite.dart';
import 'package:msa/views/article/article_top.dart';
import 'package:msa/widgets/search_page.dart';

class ArticlePage extends StatefulWidget {
  static const routeName = '/article';
  const ArticlePage({Key? key}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final SearchController _scon = Get.put(SearchController());
  
  @override void initState() {
    _scon.movieList.clear();
    _scon.keyword.value = '';
    WidgetsBinding.instance!.addPostFrameCallback((_) { 
       _scon.type.value = 'blogs';
      
    });
   
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
    _scon.searchBoxEnabled.value == true && _scon.keyword.value != ''
    ?const SearchPage()
    
    : DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.black,
            child: const SafeArea(
              child: TabBar(
                indicatorWeight: 5,
                indicatorColor: primaryColor,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.only(top: 10),
                tabs: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("トップ", style: TextStyle(fontSize: 12)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("カテゴリー", style: TextStyle(fontSize: 12)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("お気に入り", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ArticleTop(),
              ArticleCategory(),
              ArticleFavorite(),
            ],
          ),
        ),
      ),
    ));
    
     
  }
}
