import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/comment_delete_model.dart';
import 'package:msa/models/comment_list_model.dart';

import 'package:msa/models/post_comment_model.dart';

import 'package:msa/widgets/toast_message.dart';

getComments(type, itemId) async {
  try {
    String contentType = type == 'article'
      ? 'blog'
      : type; 
    var response = await dio.get(
      'api/comment/$contentType/$itemId',
    );

    if (response.statusCode == 200) {
      var data = CommentModellist.fromJson(response.data);
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

postComments(params) async {
  try {
    var response = await dio.post('api/comment', data: params);

    if (response.statusCode == 200) {
      var data = PostCommentModel.fromJson(response.data);
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

deleteComments(commentID) async {
  try {
    var response = await dio.delete('api/comment/$commentID');

    if (response.statusCode == 200) {
      var data = CommentDeleteModel.fromJson(response.data);
      return data;
    }else{
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

updateComment(commentID, params) async {
  try {
    var response = await dio.put('api/comment/$commentID', data: params);

    if (response.statusCode == 200) {
      return 1;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}
