import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/views/home/favorite_list.dart';
import 'package:msa/views/home/history_list.dart';
import 'package:msa/views/home/movies_list.dart';
import 'package:msa/views/home/radio_list.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scon = Get.put(SearchController());
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.black,
            child: SafeArea(
              child: TabBar(
                indicatorWeight: 5,
                indicatorColor: primaryColor,
                padding: EdgeInsets.zero,
                indicatorPadding: const EdgeInsets.only(top: 10),
                onTap: (index) {
                  setState(() {
                    _scon.textcon.text = '';
                    _scon.searchBoxEnabled.value = false;
                    _scon.movieList.clear();
                    _scon.customIcon.value = const Icon(Icons.search,color: white,);
                    _scon.searchVisible.value = (index == 2 || index == 3) ?false : true ;

                  });
                },
                tabs: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("動画",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("ラジオ",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("お気に入り",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("履歴",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MoviesListPage(_scon.searchBoxEnabled.value),
              const RadioListPage(),
              const FavoriteListPage(),
              const HistoryListPage(),
            ],
          ),
        ),
      ),
    );
  }
}
