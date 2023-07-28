import 'package:get/get.dart';
import 'package:msa/repository/radio_repo.dart' as repo;

class RadioController extends GetxController {
  List recommended = [];
  List radios = [];
  // ignore: prefer_typing_uninitialized_variables
  var radioDetail;
  RxBool isLoading = true.obs;

  getRadioList() async {
    try {
      var response = await repo.getRadioList();
      if (response != null) {

        if(recommended.isEmpty){
        for(int i =0;i<response.data.recommendedRadio.length;i++){
          recommended.addAll(response.data.recommendedRadio[i]);
          }
        }
        radios = response.data.radios;
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

  getRadioDetail(id) async {
    try {
      // isLoading(true);
      var response = await repo.getRadioDetail(id);
      if (response != null) {
        radioDetail = response.data;
        return true;
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
