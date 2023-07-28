import 'dart:convert';
import 'package:get/get.dart';
import 'package:msa/repository/like_unlike_fav_repo.dart' as repo;

class LikeUnlikeFavController extends GetxController {
  bool isFavorite = false;
  bool isLiked = false;

  likeUnlike({String? type, int? itemId}) async {
    try {
      var data = {'type': type, 'item_id': itemId};
      var params = jsonEncode(data);
      var response = await repo.likeUnlike(params);
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    }
  }

  favorite(args, isFav) async {
    // ignore: prefer_typing_uninitialized_variables
    var response ;
    try {
      args[1] == 'timeline' 
                ?  response = await repo.timelineFavorite(args, isFav)
                :  response = await repo.favorite(args, isFav);
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
    }
  }

  updateIsCheck(args, condition) async {
    try {
      bool isCheck = condition == true ? false : true;
      var data = {'is_checked': isCheck};
      var params = jsonEncode(data);
      var response = await repo.updateIsCheck(params, args[0]);
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    }
  }
  
  updateIsOnPlaylist(args, condition) async {
    try {
      bool isOnPlaylist = condition == true ? false : true;
      var data = {'is_on_playlist': isOnPlaylist};
      var params = jsonEncode(data);
      var response = await repo.updateIsCheck(params, args[0]);
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    }
  }

}