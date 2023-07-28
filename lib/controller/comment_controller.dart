// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/models/post_comment_model.dart';
import 'package:msa/repository/comment_repo.dart' as repo;
import 'package:msa/widgets/toast_message.dart';

class CommentController extends GetxController {
  late RxBool isLoading = false.obs;
  RxList comments = [].obs;
  final commentPost = PostCommentModel().obs;
  var comment;
  var commentCount;
  var isreply = false.obs;

  var type = '';
  var itemID;
  var parentID;
  final txtCon = TextEditingController();
  final replyCon = TextEditingController();

  var commentId;
  var topic = '';
  var itemId;

  getComment() async {
    try {
      isLoading(true);
      var response = await repo.getComments(topic, itemId);
      if (response != null) {
        comments.value = response.data;
        commentCount = response.commentCount;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  postComment() async {
    try {
      isLoading(false);
      var data = {
        'comment': comment,
        'type': type == 'article' ? 'blog' : type,
        'item_id': itemID
      };
      var params = jsonEncode(data);
      txtCon.text = '';
      var response = await repo.postComments(params);

      if (response != null) {
        // commentPost.value = response.data;
        commentCount = response.commentCount;
        getComment();
        
        //  Get.back(result: commentCount);
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  replyComment() async {
    try {
      isLoading(false);
      var data = {
        'comment': comment,
        'parent_id': parentID,
        'type': type == 'article' ? 'blog' : type,
        'item_id': itemID
      };
      var params = jsonEncode(data);
      txtCon.text = '';
      var response = await repo.postComments(params);
      if (response != null) {
        // commentPost.value = response.data;
        commentCount = response.commentCount;
        getComment();
        txtCon.text = '';
        // Get.back();
        showToastMessage('送信しました');
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  deleteComment(commentID) async {
    try {
      isLoading(false);

      var response = await repo.deleteComments(commentID);
      if (response != null) {
        commentCount = response.commentCount;
        getComment();
         Get.back();
        // Get.off(() => const InquirySuccessPage());
        // showToastMessage('Delete  Success');
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  updateComment(commentID, x) async {
    try {
      isLoading(false);
      var data = {'comment': x};
      var params = jsonEncode(data);
      var response = await repo.updateComment(commentID, params);
      if (response != null) {
        // Get.off(() => const InquirySuccessPage());
        // showToastMessage('update  Success');
        getComment();
        txtCon.text = '';
        commentId = "";
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }
}
