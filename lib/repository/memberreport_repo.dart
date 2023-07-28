import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/chatmodels/host_reply_model.dart';
import 'package:msa/models/member_report_model.dart';

import 'package:msa/models/save_memberreport_model.dart';
import 'package:msa/widgets/toast_message.dart';

saveMemberReport(params) async {
  try {
    var response = await dio.post('api/member-report/save', data: params);

    if (response.statusCode == 200) {
      var data = SaveMemberReport.fromJson(response.data);
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

getMemberReport() async {
  try {
    var response = await dio.get('api/member-report/list');

    if (response.statusCode == 200) {
      var data = MemberReport.fromJson(response.data);
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

getHostMemberReport(id) async {
  try {
    var response = await dio.get(
      'api/member-report/host/report-list?search=user_id%3A$id',
    );
    if (response.statusCode == 200) {
      var data = MemberReport.fromJson(response.data);
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

postHostReply(id, params) async {
  try {
    var response =
        await dio.patch('api/member-report/host-reply/$id', data: params);
    if (response.statusCode == 200) {
      var data = HostReplyModel.fromJson(response.data);
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


clientReportSeen(params) async {
  try {
    var response = await dio.post('api/member-report/client-report-seen', data: params);

    if (response.statusCode == 200) {
      return response.statusMessage;
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
