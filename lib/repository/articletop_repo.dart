import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:msa/models/article_detail_model.dart';
import 'package:msa/models/article_top.dart';
import 'package:msa/models/articlecatsearch_model.dart';
import 'package:msa/widgets/toast_message.dart';
import '../common/dio/dio_client.dart';

getArticleTopList() async {
  try {
    var response = await dio.get(
      'api/blog-list',
    );

    if (response.statusCode == 200) {
      var data = ArticleTopModel.fromJson(response.data);
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

getArticleCatSearchList(catID) async {
  try {
    var response = await dio.get(
      'api/blog?search=blog_category:$catID',
    );

    if (response.statusCode == 200) {
      var data = ArticleCatSearchModel.fromJson(response.data);
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

getArticleDetail(id) async {
  try {
    var response = await dio.get(
      'api/blog/$id',
    );

    if (response.statusCode == 200) {
      var data = ArticleDetailModel.fromJson(response.data);
      return data;
    } 
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}