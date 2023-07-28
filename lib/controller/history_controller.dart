import 'package:get/get.dart';
import 'package:msa/repository/history_repo.dart' as repo;

class HistoryController extends GetxController {
  List historyLists = [];
  RxBool isLoading = true.obs;

  getHistoryList() async {
    try {
      var response = await repo.getHistory();
      if (response != null) {
        historyLists = response.data;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }
}
