import 'package:get/get.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/repository/articletop_repo.dart' as artrepo;
import 'package:msa/repository/timeline_repo.dart' as timerepo;
import 'package:msa/repository/news_repository.dart' as newsrepo;

class WebViewController extends GetxController {
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  RxBool isLoading = false.obs;
  // ignore: prefer_typing_uninitialized_variables
  var detail;
  bool detailFavorite = false;
  bool detailLiked = false;

  getDetail(args) async {
    try {
      isLoading(true);
      var response = 
        args[1] == 'article'
          ? await artrepo.getArticleDetail(args[0])
          : args[1] == 'timeline'
            ? await timerepo.getTimelineDetail(args[0])
              : args[1] == 'news'
                ?  await newsrepo.getNewsDetail(args[0])
                : '';
      if (response != null) {
        detail = response.data;
        if(args[1] != 'news') {
          detailFavorite = detail.isFavorite;
          detailLiked = detail.liked;
        }
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  setFavorite(args, isFav) async {
    try {
      var response = args[1] == 'article'
        ? await _activityCon.favorite(args, isFav) //artrepo.favorite(args[0], isFav)
        : null;
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    } 
  }

  likeUnlike(args) async {
    try {
      String type = args[1] == 'article'
                      ? 'blog'
                      : args[1] == 'timeline'
                        ? 'timeline'
                        : '';
      var response = args[1] == 'article'
        ? await _activityCon.likeUnlike(itemId: args[0], type: type) //artrepo.favorite(args[0], isFav)
        : null;
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    } 
  }

}