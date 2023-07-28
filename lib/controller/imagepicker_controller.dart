import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:msa/repository/avatar_repo.dart' as repo;
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  // ignore: prefer_typing_uninitialized_variables
  File image = File('');
  RxBool isLoading = false.obs;
  // int id = 0;
  final box = GetStorage();
  int userId=0;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void onInit() {
    super.onInit();
    getPref();
  }

  getPref() async{
    userId = box.read('userID') != "" ? box.read('userID') : 0;
  }
  
  pickImageFromGallery() async {
    try {
      // Pick an image
      final XFile? imageSelected =
          await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxHeight: 480, maxWidth: 480);
      if (imageSelected != null) {
        
        // var imageFormat = getFileExtension(imageSelected.path);
        // image = File(imageSelected.path);
        if(imageSelected.path.contains('.heic')){
          image = File(await convertToJPG(imageSelected.path));
        }else{
        image = File(imageSelected.path);
        }
        // uploadImage(id);
        update();
        return image;
        
      }
    } catch (e) {
      e.toString();
    }
  }

  pickImageFromCamera() async {
    try {
      // Pick an image
      final XFile? imageSelected =
          await _picker.pickImage(source: ImageSource.camera,imageQuality: 50,maxHeight: 480, maxWidth: 480);
      if (imageSelected != null) {

        // image = File(imageSelected.path);
        if(imageSelected.path.contains('.heic')){
          image = File(convertToJPG(imageSelected.path));
        }else{
        image = File(imageSelected.path);}

        update();

        return image;
      }
    } catch (e) {
      e.toString();
    }
  }

  List avatars = [];

  getAvatar() async {
    try {
      isLoading(true);
      var response = await repo.getAvatar();
      if (response != null) {
        avatars = response.data;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  storeAvatar(code) async {
    try {
      isLoading(true);
      var response = await repo.storeAvatar(code);
      if (response != null) {
        // Get.off(() => const InquirySuccessPage());
        // showToastMessage('Update Success');
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  //gallery select upload
  uploadImage(id) async {
    try {
      isLoading(true);
      // String? fileName = image?.path == null ? '' : image?.path.split('/').last;

      var response = await repo.uploadImage(image, id);
      if (response != null) {
        // FirestoreServices.uploadProfileImage(userId: userId.toString(), imageUrl: response.data.image);
        Future.delayed(Duration.zero,
            (() => [1,Get.back()]));
        
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }
}

String getFileExtension(String fileName) {
 return "." + fileName.split('.').last;
}

convertToJPG(String filePath) async{
  var newPath = await HeicToJpg.convert(filePath);
  return newPath;
}