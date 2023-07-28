import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/models/search/blog_search.dart';

import 'package:msa/models/search/movie_search_model.dart';
import 'package:msa/models/search/radio_search_model.dart';
import 'package:msa/models/search/timelinesearch_model.dart';
import 'package:msa/widgets/toast_message.dart';

import '../../common/dio/dio_client.dart';

searchMovieList(keyword, type) async {
  List searchUrls = [
    'api/product-search?movie_category=1&keyword=$keyword',
    'api/radio-search?keyword=$keyword',
    'api/blog-search?keyword=$keyword',
    'api/timeline-search?keyword=$keyword',
    'api/radio-search?keyword=$keyword'
  ];

  List models = [
    MovieSearchModel.fromJson,
    RadioSearchModel.fromJson,
    BlogSearchModel.fromJson,
    TimelineSearchModel.fromJson,
    
  ];

  late int index;

  if (type == "movie") {
    index = 0;
  } else if (type == "radio") {
    index = 1;
  } else if (type == "blogs") {
    index = 2;
  } else if (type == "timeline") {
    index = 3;
  }
  try {
    var response = await dio.get(searchUrls[index]);

    if (response.statusCode == 200) {
      var data = models[index](response.data);
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
