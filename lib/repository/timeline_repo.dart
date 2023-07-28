import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/timeline_category_model.dart';
import 'package:msa/models/timeline_detail_model.dart';
import 'package:msa/models/timeline_list_model.dart';

getTimelineList() async {
  try {
    final response = await dio.get(
      'api/timeline-list',
    );

    if (response.statusCode == 200) {
      final data = TimeLineListModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}

getTimelineCategoryList(catId) async {
  try {
    final response = await dio.get(
      'api/timeline?search=timeline_category:$catId',
    );

    if (response.statusCode == 200) {
      final data = TimelineCategoryModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}

getTimelineDetail(int id) async {
  try {
    final response = await dio.get(
      'api/timeline/$id',
    );

    if (response.statusCode == 200) {
      final data = TimelineDetail.fromJson(response.data);
      return data;
    } 
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}