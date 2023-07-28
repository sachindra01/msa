import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/models/radio_detail_model.dart';
import 'package:msa/models/radio_list_model.dart';
import 'package:msa/widgets/toast_message.dart';

import '../common/dio/dio_client.dart';

getRadioList() async {
  try {
    var response = await dio.get(
      'api/radio-list',
    );

    if (response.statusCode == 200) {
      var data = RadioList.fromJson(response.data);
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

getRadioDetail(id) async {
  try {
    var response = await dio.get(
      'api/radio/$id',
    );

    if (response.statusCode == 200) {
      var data = RadioDetailModel.fromJson(response.data);
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
