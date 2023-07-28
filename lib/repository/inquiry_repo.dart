import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/inquiry_model.dart';
import 'package:msa/widgets/toast_message.dart';

inquiry(params) async {
  try {
    var response = await dio.post('api/inquiry', data: params);

    if (response.statusCode == 200) {
      var data = InquiryModel.fromJson(response.data);
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
