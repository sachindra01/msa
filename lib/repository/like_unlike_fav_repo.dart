import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/widgets/toast_message.dart';

likeUnlike(params) async {
  try {
    final response = await dio.post('api/like-unlike', data: params);

    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}

favorite(args, isFav) async {
  try {
    int fav = isFav == true ? 1 : 0;
    String url = args[1] == 'article'
        ? 'api/blog-favorite/${args[0]}?is_favorite=$fav'
        : '';
    final response = await dio.put(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}
timelineFavorite(args, isFav) async {
  try {
    int fav = isFav == true ? 1 : 0;
    String url = args[1] == 'timeline'
        ? 'api/timeline-favorite/${args[0]}?is_favorite=$fav'
        : '';
    final response = await dio.put(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}

updateIsCheck(params, id) async {
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

updateIsOnPlaylist(params, id) async {
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