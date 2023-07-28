// ignore_for_file: file_names

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/models/occupationlist_model.dart';
import 'package:msa/models/prefecturelist_model.dart';
import 'package:msa/widgets/toast_message.dart';

import '../common/dio/dio_client.dart';

getPrefectureList() async {
  try {
    var response = await dio.get(
      'api/prefecture-list',
    );

    if (response.statusCode == 200) {
      var data = PrefectureListModel.fromJson(response.data);
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


getOccupationList() async {
  try {
    var response = await dio.get(
      'api/occupation-list',
    );

    if (response.statusCode == 200) {
      var data = OccupationListModel.fromJson(response.data);
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
