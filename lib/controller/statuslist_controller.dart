// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:msa/common/styles.dart';

import 'package:msa/repository/chatrepo/statuslist_repo.dart' as repo;

class StatusListController extends GetxController {
  var statuslist;
  RxList memberlist = [].obs;

  var allCount = 0.obs;
  var newCount = 0.obs;
  var repliedCount = 0.obs;
  var holdCount = 0.obs;
  var labelEn = ''.obs;

  RxBool isLoading = true.obs;
    chatStatusText(number){
    if(number == '1'){
      return '未返信';
    }else if(number == '3'){
      return '要対応';
    }else if(number == '2'){
      return '確認済';
    }
  }

   reportStatusEnglish(number){
    if(number == '1'){
      return 'new';
    }else if(number == '2'){
      return 'replied';
    }else if(number == '3'){
      return 'hold';
    }
  }

  chatStatusColor(number){
    if(number == '1'){
      return red;
    }else if(number == '2'){
      return repliedLabelColor;
    }else if(number == '3'){
      return blue;
    }
  }

  getStatusList() async {
    try {
      var response = await repo.getStatusList();
      if (response != null) {
        statuslist = response.data;
        allCount.value = statuslist.all.count;
        newCount.value = statuslist.dataNew.count;
        holdCount.value = statuslist.hold.count;
        repliedCount.value = statuslist.replied.count;
        

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

  getMemberList(args) async {
    try {
      isLoading(true);
      var response = await repo.getreportUserList(args);
      if (response != null) {
        memberlist.value = response.data;
        
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
