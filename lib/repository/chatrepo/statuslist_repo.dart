import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/chatmodels/host_status_list.dart';
import 'package:msa/models/chatmodels/member_list_model.dart';
import 'package:msa/widgets/toast_message.dart';

getStatusList() async {
  try {
    var response = await dio.get(
      'api/member-report/host/status-list',
    );

    if (response.statusCode == 200) {
      var data = StatusList.fromJson(response.data);
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

getreportUserList(args) async {
  try {
    var response =
        await dio.get('api/member-report/host/member-list?report_status=$args');

    if (response.statusCode == 200) {
      var data = MemberList.fromJson(response.data);
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
