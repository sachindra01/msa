import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/avatar_model.dart';
import 'package:msa/models/image_upload_model.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:msa/widgets/toast_message.dart';

getAvatar() async {
  try {
    var response = await dio.get(
      'api/avatar-list',
    );

    if (response.statusCode == 200) {
      var data = AvatarModel.fromJson(response.data);
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

storeAvatar(code) async {
  try {
    var response = await dio.get(
      'api/avatar-store/$code',
    );

    if (response.statusCode == 200) {
      // var data = AvatarModel.fromJson(response.data);
      // return data;
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

uploadImage(file, id) async {
  try {
    // var fileName = '';

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file!.path,
      ),
      "id": id
    });

    var response = await dio.post('api/member-upload', data: formData);

    if (response.statusCode == 200) {
      var data = ImageUploadSuccess.fromJson(response.data);
      if(!GetStorage().read('firstLogin')){
        FirestoreServices.uploadProfileImage(userId: id.toString(), imageUrl: data.data!.image.toString());}
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
