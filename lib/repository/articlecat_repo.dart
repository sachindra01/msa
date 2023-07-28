import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:msa/models/article_category_model.dart';
import 'package:msa/widgets/toast_message.dart';
import '../common/dio/dio_client.dart';

getArticleCategoryList() async {
  try {
    var response = await dio.get(
      'api/blog-category',
    );

    if (response.statusCode == 200) {
      var data = ArticleCategoryModel.fromJson(response.data);
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

// getArticleSearchList(catID) async {
//   try {
//     var response = await dio.get(
//       'api/blog?search=blog_category:$catID',
//     );

//     if (response.statusCode == 200) {
//       var data = ArticleCatSearchModel.fromJson(response.data);
//       return data;
//     } else {
//       return null;
//     }
//   } on DioError catch (e) {
//     log(e.message);
//     showToastMessage(e.response!.data['message']);
//   } catch (e) {
//     log(e.toString());
//   }
// }
