import 'package:get/get.dart';

import 'package:msa/repository/articlecat_repo.dart' as repo;

class ArticleCategoryController extends GetxController {
  List categories = [];

  RxBool isLoading = true.obs;

  getArticleCategoryList() async {
    try {
      var response = await repo.getArticleCategoryList();
      if (response != null) {
        categories = response.data;

        // isLoading.value = false;
        // Get.off(() => const BottomNavigation());
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  // getArticleCatSearchList(catID) async {
  //   try {
  //     var response = await repo.getArticleSearchList(catID);
  //     if (response != null) {
  //       searchCategories = response.data[0];
  //       print(searchCategories);

  //       // isLoading.value = false;
  //       // Get.off(() => const BottomNavigation());
  //     }
  //   } catch (e) {
  //     e.toString();
  //   } finally {
  //     isLoading(false);
  //     update();
  //   }
  // }
}
