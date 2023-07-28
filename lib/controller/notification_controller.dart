import 'package:get/get.dart';
import 'package:msa/repository/notification_repo.dart' as repo;

class NoitificationController extends GetxController {
  List notificationList = [];
  RxBool isLoading = false.obs;

  getNotifications() async {
    try {
      isLoading(true);
      var response = await repo.getNotifications();
      if (response != null) {
        notificationList = response.data;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }
}