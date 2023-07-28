import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/notification_model.dart';
import 'package:msa/widgets/toast_message.dart';

getNotifications() async {
  try {
    var response = await dio.get(
      'api/unseen-blogs',
    );

    if (response.statusCode == 200) {
      var data = NotificationModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}