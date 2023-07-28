import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:msa/models/product_detail_model.dart';
import 'package:msa/models/product_list_model.dart';
import 'package:msa/widgets/toast_message.dart';

import '../common/dio/dio_client.dart';

getProductList() async {
  try {
    var response = await dio.get(
      'api/product-list',
    );

    if(response.statusCode == 200) {
      var data = ProductListModel.fromJson(response.data);
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

getMovieDetail(id) async {
  try {
    var response = await dio.get(
      'api/product-detail/$id',
    );

    if(response.statusCode == 200) {
      var data = ProductDetailModel.fromJson(response.data);
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

updateMovieDetail(params, id) async {
  try {
    var response = await dio.put(
      'api/product/$id',
      data: params
    );

    if(response.statusCode == 200) {
      return true;
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
const vimeoToken = '736f42d2ebfa39253f9d0b3a510896ac';

getVideoUrl(id) async{
  
  try{
    var response = await Dio().get(
      'https://api.vimeo.com/videos/$id',
       options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $vimeoToken',
        },
      ),
    
    );

    if(response.statusCode == 200) {
      return response.data['files'];
    }
  } on DioError catch (e) {
    log(e.message);
    return null;
  } catch (e) {
    log(e.toString());
     return null;
  }
}