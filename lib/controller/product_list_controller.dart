// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:get/get.dart';
import 'package:msa/repository/product_repo.dart' as repo;

class ProductListController extends GetxController {
  List category = [];
  RxBool isLoading = true.obs;
  RxBool isDetailLoading = false.obs;
  var videoUrl = {};
  RxBool movieChange = false.obs;
  RxString catName = ''.obs;
  var movieDetail;
  var playlist;
  var comment;
  var videoId;
  var hasVideo =true;

  getProductList() async {
    try {
      var response = await repo.getProductList();
      if (response != null) {
        category = response.data.category;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  getMovieDetail(id, [isNewPage]) async {
    try {
      isNewPage == false ? movieChange(true) : isDetailLoading(true);
      var response = await repo.getMovieDetail(id);
      if (response != null) {
        movieDetail = response.data.detail;
        catName.value = movieDetail.categoryName;
        playlist = response.data.list;
        comment = response.data.comments;
        videoId = movieDetail.movieCode;
       
      }
    } catch (e) {
      e.toString();
    } finally {
      isNewPage == false ? movieChange(false) : isDetailLoading(false);
      update();
    }
  }

  updateMovieDetail(id, navFrom, condition) async {
    try {
      var data = navFrom == 'playlist'
          ? {'is_on_playlist': condition}
          : {'is_checked': condition};
      var params = jsonEncode(data);
      var response = await repo.updateMovieDetail(params, id);
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    }
  }

  getVideoUrl(id) async{
    try{
      var response = await repo.getVideoUrl(id);
      if(response != null){
        for(int i = 0;i <response.length ;i++){
          videoUrl.addAll({ response[i]['rendition'] : response[i]['link'].toString() });
           
        }
      }else{
        videoUrl.clear();
        hasVideo = false;
      }
      
    }catch (e){
      videoUrl.clear();
      hasVideo = false;
    } 
    finally{
      if(videoUrl.isNotEmpty){
        hasVideo = true;
      }else{
        hasVideo = false;
      }
    }

    
    
  }

  
}
