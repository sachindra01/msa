import 'dart:convert';
import 'package:get/get.dart';
import 'package:msa/repository/inquiry_repo.dart' as repo;
import 'package:msa/views/drawerpages/inquiry_success.dart';


class InquiryController extends GetxController {
  late String topic = '';
  late String comment = '';
  late RxBool isLoading = false.obs;
  // ignore: prefer_typing_uninitialized_variables
  var userInfo;

  inquiry() async {
    try {
      isLoading(true);
      var data = {'topic': topic, 'comment': comment};
      var params = jsonEncode(data);
      var response = await repo.inquiry(params);
      if (response != null) {
        Get.off(() => const InquirySuccessPage());
        
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }
}
