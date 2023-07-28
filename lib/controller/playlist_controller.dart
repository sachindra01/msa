import 'package:get/get.dart';
import 'package:msa/repository/playlist_repo.dart' as repo;

class PlayListController extends GetxController {
  List playlists = [];
  RxBool isLoading = true.obs;

  getPlayList() async {
    try {
      var response = await repo.getPlayList();
      if (response != null) {
        playlists = response.data;
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
}
