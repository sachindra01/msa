import 'package:get/get.dart';
import 'package:msa/repository/prefecturelist_repo.dart' as repo;

class PrefectureController extends GetxController {
  List<String> prefectureList = [];
  List<String> occupationList = [];

  RxBool isLoading = true.obs;

  getPrefectureList() async {
    try {
      var response = await repo.getPrefectureList();
      if (response != null) {
        response.data.forEach((k, v) => prefectureList.add(v));
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  getOccupationList() async{
    try {
      var response = await repo.getOccupationList();
      if(response != null){
        response.data.forEach((k,v) => occupationList.add(v));
      }
    }catch (e){
      e.toString();
    }finally{
      isLoading(false);
      update();
    }
  }

  
}
