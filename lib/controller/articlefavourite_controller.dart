import 'package:get/get.dart';
import 'package:msa/repository/articlefavourite_repo.dart' as repo;
import 'package:msa/controller/like_unlike_favorite_controller.dart';

class ArticleFavouriteController extends GetxController {
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  List favourites = [];
  RxBool isLoading = true.obs;

  getArticleFavouriteList() async {
    try {
      var response = await repo.getArticleFavouriteList();
      if (response != null) {
        favourites = response.data;
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

  setBlogFavorite(id, isFav, index) {
    var success = _activityCon.favorite(id, isFav);
    if(success == true) {
      favourites.removeAt(index);
      return true;
    }
  }
}
