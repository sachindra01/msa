import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/widgets/toast_message.dart';

addGroupMember(params) async {
  try {
    var response = await dio.post(
      'api/chat-member',
      data: params
    );
    if (response.statusCode == 200) {
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

leaveGroup(Map<String, dynamic> params) async {
  try {
    var response = await dio.get(
      'api/chat-member-remove',
      queryParameters: params
    );
    if (response.statusCode == 200) {
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

memberInfo(id) async {
  try {
    var response = await dio.get(
      'api/member-info/$id',
    );
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    if(e.response!=null){
      if(e.response!.statusMessage!="Too Many Requests"){
        showToastMessage(e.response!.data['message']);
      }
    }
  } catch (e) {
    log(e.toString());
  }
}