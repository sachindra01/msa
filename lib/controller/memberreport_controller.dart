import 'dart:convert';

import 'package:get/get.dart';

import 'package:msa/repository/memberreport_repo.dart' as repo;
import 'package:msa/views/pages/report_createdpage.dart';
import 'package:msa/views/profile/activityreport_list.dart';


class MemberReportController extends GetxController {
  late RxBool isLoading = false.obs;
  late List data = [];
   List reportStatuses = [];
  // ignore: prefer_typing_uninitialized_variables
  late var resp;
  late var earning = '';
  late var grossProfit = '';
  late var expenses = '';
  late var monthGoal = '';
  late var askHost = '';
  late var nextMonthGoal = '';
  late var nextMonthGoalReply = '';
  late var reportStatus = '';

  // ignore: prefer_typing_uninitialized_variables
  var userInfo;

  getMemberReport() async {
    try {
      isLoading(true);

      var response = await repo.getMemberReport();
      if (response != null) {
        data = response.data;
       
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  getHostMemberReport(id) async {
    try {
      isLoading(true);

      var response = await repo.getHostMemberReport(id);
      if (response != null) {
        data = response.data;
        
        
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  postHostReply(id) async {
    try {
      isLoading(true);
      var data = {
        'earning': earning,
        'gross_profit': grossProfit,
        'expenses': expenses,
        'month_goal': monthGoal,
        'ask_host': askHost,
        'next_month_goal': nextMonthGoal,
        'next_month_goal_reply': nextMonthGoalReply,
        'report_status': reportStatus,
      };
      var params = jsonEncode(data);
      var response = await repo.postHostReply(id, params);
      if (response != null) {
        resp = response.data;
        // showToastMessage(response.data.label.toString());
        
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  saveMemberReport() async {
    try {
      isLoading(true);
      var data = {
        'earning': earning,
        'gross_profit': grossProfit,
        'expenses': expenses,
        'month_goal': monthGoal,
        'ask_host': askHost,
        'next_month_goal': nextMonthGoal
      };
      var params = jsonEncode(data);
      var response = await repo.saveMemberReport(params);
      if (response != null) {
        Get.off(() => const ReportCreatedPage(), arguments: 4);
        // showToastMessage('Report Created Successfully');
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }


  clientReportSeen(id) async {
    try {
      isLoading(true);
      var data = {
        "report_id" : id
      };
      var params = jsonEncode(data);
      var response = await repo.clientReportSeen(params);
      if (response != null) {
        getMemberReport().then((_)=> Get.off(()=> const ActivityReportPage()));
        //Get.off(() => const ActivityReportPage())!.then((value) => getHostMemberReport(id));
        // showToastMessage('Report Created Successfully');
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }
}
