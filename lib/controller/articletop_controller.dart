import 'package:get/get.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/repository/articletop_repo.dart' as repo;
import 'package:msa/widgets/toast_message.dart';

class ArticleTopController extends GetxController {
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  List articles = [];
  List searchCategories = [];
  RxBool isLoading = true.obs;
  RxBool isCatSearchLoading = false.obs;
  RxBool isDetailLoading = false.obs;
  // ignore: prefer_typing_uninitialized_variables
  var blogDetail;
  bool blogDetailFavorite = false;
  bool blogDetailLiked = false;

  getArticleTop() async {
    try {
      var response = await repo.getArticleTopList();
      if (response != null) {
        articles = response.data.blogs;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  getArticleCatSearchList(catID) async {
    try {
      isCatSearchLoading(true);
      var response = await repo.getArticleCatSearchList(catID);
      if (response != null) {
        searchCategories = response.data.blogs;
      }
    } catch (e) {
      e.toString();
    } finally {
      isCatSearchLoading(false);
      update();
    }
  }

  setBlogFavorite(id, isFav) async {
    try {
      var response = await _activityCon.favorite(id, isFav);
      if (response != null) {
        showToastMessage(response);
        return true;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

}