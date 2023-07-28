import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:msa/models/articlefavourite_model.dart';

import 'package:msa/widgets/toast_message.dart';

import '../common/dio/dio_client.dart';

getArticleFavouriteList() async {
  try {
    var response = await dio.get(
      'api/blog-favorite',
    );

    if (response.statusCode == 200) {
      var data = ArticleFavouriteModel.fromJson(response.data);
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
