import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/news_model.dart';
import 'package:msa/widgets/toast_message.dart';

getNewsDetail(id) async {
  try {
    var response = await dio.get(
      'api/blog/$id',
    );

    if (response.statusCode == 200) {
      var data = NewsModel.fromJson(response.data);
      return data;
    } 
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}