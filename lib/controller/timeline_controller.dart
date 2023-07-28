// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:msa/repository/timeline_repo.dart' as repo;

class TimeLineController extends GetxController {
  List recommendedTimeline = [];
  // List recommendedTimelineCat = [];
  List timeline = [];
  List timelineCat = [];
  RxBool isLoading = false.obs;
  RxBool isCatLoading = false.obs;
  RxBool isDetailLoading = false.obs;
  bool timelinedetailFav = false;
  bool timelinedetailLiked = false;
  var timelinedetail;
  var likedResponse;

  getTimelineList() async {
    try {
      isLoading(true);
      var response = await repo.getTimelineList();
      if (response != null) {
        timeline = response.data.timelines;
        recommendedTimeline = response.data.recommendedTimelines;
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isLoading(false);
    }
  }

  getTimelineCategoryList(catId) async {
    try {
      isCatLoading(true);
      var response = await repo.getTimelineCategoryList(catId);
      if (response != null) {
        timelineCat = response.data.timelines;
        // recommendedTimelineCat = response.data.recommendedTimelines;
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isCatLoading(false);
    }
  }

  getTimelineDetail(int id) async {
    try {
      isDetailLoading(true);
      var response = await repo.getTimelineDetail(id);
      if (response != null) {
        timelinedetail = response.data;
        timelinedetailFav = response.data.isFavorite;
        timelinedetailLiked = response.data.liked;
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isDetailLoading(false);
    }
  }
  
}
