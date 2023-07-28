import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/repository/searchrepo/moviesearch_repo.dart' as repo;

class SearchController extends GetxController {
  Rx<Widget> appBarTitle = const Text(
    "ホーム",
    style: TextStyle(fontSize: 16.0),
  ).obs;


  Rx<Icon> customIcon = const Icon(
    Icons.search,
    color: white,
  ).obs;
  var textcon = TextEditingController();
  RxBool searchBoxEnabled = false.obs;
  RxBool searchVisible = true.obs;
  RxList movieList = [].obs;
  RxString type = ''.obs;
  RxString keyword = ''.obs;

  RxBool isLoading = true.obs;

  searchMovieList() async {
    try {
      var response = await (repo.searchMovieList(keyword.value, type.value));
      if (response != null) {
        // movieList.a(response.data);
        movieList.value = response.data;

      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }
}
