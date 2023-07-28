import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/views/auth/login.dart';
import 'package:msa/views/home/music_page_manager.dart';
import 'package:msa/widgets/premium_alert.dart';

class Logging extends Interceptor {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final box = GetStorage();
    var token = box.read('apiToken');
    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
      'ERROR[PATH: ${err.requestOptions.path} ' 
      // + 
      //     err.response!.data['message'].toString() != "null" 
      //       ? err.response!.data['message'] is String
      //         ? err.response!.data['message']
      //         : err.response!.data['message'].forEach((k, v) => err.response!.data['message'][k][0])
      //       : err.response!.data['error'] 
    );
    if(err.response?.statusCode == 401){ 
      if(err.response!.data['message'] == "Invalid Token") {
        Get.delete<AuthController>();
        Get.delete<PageManagerController>();
        Get.delete<SearchController>();
        Get.off(() => const LoginPage());
        var box = GetStorage();
        box.remove('apiToken');
      } else if(err.response!.data['error'] == "Unauthenticated access") {
        Get.back();
        Get.to(() => const PremiumAlertWidget());
      }
    }
    return super.onError(err, handler);
  }
}