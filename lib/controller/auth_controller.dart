// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/repository/auth_repo.dart' as repo;
import 'package:msa/views/auth/account.dart';
import 'package:msa/views/auth/first_logIn_edit.dart';
import 'package:msa/views/auth/login.dart';
import 'package:msa/views/auth/password_update_success.dart';
import 'package:msa/views/drawerpages/inquirypage.dart';
import 'package:msa/views/home/music_page_manager.dart';
import 'package:msa/views/profile/edit_profile.dart';
import 'package:msa/widgets/bottom_navigation.dart';
import 'package:msa/widgets/premium_alert.dart';
import 'package:msa/widgets/report_alert.dart';
import 'package:msa/widgets/toast_message.dart';
import 'package:msa/services/firestore_services.dart';
class AuthController extends GetxController {
  final box = GetStorage();
  late String email = '';
  late String password = '';
  late String nickname = '';
  late String shortDescription = '';
  late String designation = '';
  late String twitter = '';
  late bool updateSucces = false;
  late RxBool notifyFlg = false.obs;
  late String token = '';

  late RxBool isLoading = false.obs;
  late RxBool isMemLoading = false.obs;
  RxBool isgraphLoading = false.obs;
  var userInfo;
  var profileInfo;
  var memberInfo;
  List prefectureList = [];
  List barInfo = [];

  late String firstName = "";
  late String lastName = "";
  String memberType = '';
  String isPremium = "";
  bool showBlue = true;
  bool showGreen = true;
  bool showGrey = true;
  int index=0;

  late String kanaFirstName;
  late String dobYear = '';
  late bool ageDisclose = false;
  late String prefecture = '';
  late bool status = false;
  late var gender;
  late bool isSwitched;
  late String occupation = '';
  late String phone = '';
  late String lineID = '';
  late RxBool isFirstLoginMessageLoading = false.obs;
  List firstLoginMessage = [];

  @override
  void onInit() {
    super.onInit();
    getPref();
  }

  logIn(context,bool isChecked) async {
    try {
      isLoading(true);
      String deviceId = box.read('deviceId')??"";
      String fcm = box.read('fcm')??"";
      var data = {'email': email, 'password': password,'device_id':deviceId,'fcm_token':fcm};
      var params = jsonEncode(data);
      var response = await repo.logIn(params);
      if (response != null) {
        if(isChecked){
          box.write("loginEmail",email );
          box.write("password", password);
          box.write("isChecked", true);
        }
        else{
          box.remove("loginEmail");
          box.remove("password");
          box.write("isChecked", false);
        }
        if(response.data.firstLogin == true){
          saveLoginData(response);
          Get.off(() => const FirstLogInEdit());
        }
        else if(response.data.isPremium || response.data.memberType == 'host'){
          saveLoginData(response);
          Get.off(() => const BottomNavigation()); 
        }
        else if(response.data.isPremium == false){
          box.write('freeUserImage', response.data.freeUserData.image);
          box.write('freeUserRedirectUrl', response.data.freeUserData.url);
          openPremiumAlert(context);
        }
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  saveLoginData(response){
    box.write('apiToken', response.data.apiToken);
    box.write('isPremium', response.data.isPremium);
    box.write('userID', response.data.id);
    box.write('memberType', response.data.memberType);
    box.write('userName', response.data.name);
    box.write('nickName', response.data.nickname);
    box.write('profileImageUrl', response.data.profileImage);
    box.write('firstLogin', response.data.firstLogin);
    box.write('freeUserImage', response.data.freeUserData.image);
    box.write('freeUserRedirectUrl', response.data.freeUserData.url);
  }

  logout() async { 
    try {
      isLoading(true);
      var response = await repo.logOut();
      if (response != null) {
        box.remove('apiToken');
        box.remove('isPremium');
        box.remove('memberType');
        box.remove('userID');
        box.remove('userName');
        box.remove('nickName');
        box.remove('profileImageUrl');
        Get.delete<PageManagerController>();
        Get.delete<SearchController>();
        Get.off(() => const LoginPage());
      } else {
        // showToastMessage('Something went wrong!!!');
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  updatePassword(currentPassword, newPassword, confirmPassword) async{
    try {
      isLoading(true);
      var data = {'old_password': currentPassword, 'password': newPassword,'password_confirmation':confirmPassword};
      var params = jsonEncode(data);
      var response = await repo.updatePassword(params);
      if (response != null) {
        if(box.read("isChecked") == true){
          box.write("password", newPassword);
        }
        Get.off(const PasswordChangeSuccess());
        
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
    }
  }

  getUserInfo() async {
    try {
      isLoading(true);
      var response = await repo.getUserInfo();
      if (response.code == 200) {
        profileInfo = response;
        userInfo = response.data;
        box.write('userImg', response.data.profileImage);
        box.write('isPremium', response.data.isPremium);
        return userInfo;
      } else {
        // showToastMessage('Something went wrong!!!');
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  getBarInfo() async {
    try {
      isgraphLoading(true);
      var response = await repo.getBarInfo();
      if (response != null) {
        barInfo = response.data;
      } else {
        // showToastMessage('Something went wrong!!!');
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isgraphLoading(false);
    }
  }

  updateUserInfo(BuildContext context, [firstName, kanaFirstName,/*  phone, lineID, */ dobYear, 
    ageDisclose, prefecture, gender, /* occupation, */ status, isSwitched]) async {
    try {
      isLoading(true);
      var data = {
        'first_name': firstName,
        'kana_first_name':kanaFirstName,
        'dob_year':dobYear,
        'show_age': ageDisclose,
        'address_1':prefecture,
        'gender':gender,
        // 'occupation':occupation,
        'status':status,
        // 'phone_no1':phone,
        // 'line_id':lineID,
        'notification_status': isSwitched
      };
      var params = jsonEncode(data);
      var response = await repo.updateUserInfo(params);
      if (response != null) {
        Get.off(() => const AccountPage());
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isLoading(false);
    }
  }

  firstLoginEdit(BuildContext context, firstName, kanaFirstName, dobYear, ageDisclose, prefecture, status,
    gender, /* occupation, phone, lineID, */ pushNoti) async {
      try {
        isLoading(true);
        var data = {
          'first_name' : firstName,
          'kana_first_name' : kanaFirstName,
          'dob_year' : dobYear,
          'show_age' : ageDisclose,
          'address_1' : prefecture,
          'status' : status,
          'gender' : gender,
          /* 'occupation' : occupation,
          'phone_no1' : phone,
          'line_id' : lineID, */
          'notification_status' : pushNoti
        };
        var params = jsonEncode(data);
        var response = await repo.updateUserInfo(params);
        if (response != null) {
          Get.off(() => const ProfileEditPage(),arguments: response.data);
          showToastMessage("更新しました。");
        }
      } catch (e) {
        e.toString();
      } finally {
        update();
        isLoading(false);
      }
  }


  getMemberInfo(id) async {
    try {
      isMemLoading(true);
      var response = await repo.getMemberInfo(id);
      if (response != null) {
        memberInfo = response.data;
         response.prefectureList.forEach((k, v) => prefectureList.add(v));
      } else {
        // showToastMessage('Something went wrong!!!');
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isMemLoading(false);
    }
  }

  updateMemberInfo() async {
    try {
      isLoading(true);
      var data = {
        'nickname': nickname,
        'designation': designation,
        'short_description': shortDescription,
        'twitter_link': twitter,
      };
      var params = jsonEncode(data);
      var response = await repo.updateMemberInfo(params);
      if (response != null) {
        final MessageController messageCon = Get.put(MessageController());
        var firstLogin= box.read('firstLogin');
        var isPremium= box.read('isPremium');
        var memberType= box.read('memberType');
        
        if(messageCon.userId==0){
          messageCon.userId = response.data.user.id;
        }
        updateSucces = response.success;
        firstLogin 
          ? isPremium || memberType == 'host'
            ? Get.off(() => const BottomNavigation(),arguments: 3)
            : Get.off(()=> const InquiryPage())
          : Get.back(result: true);
        
        box.write('nickName', nickname);
        if(!firstLogin){
          FirestoreServices.updateUsersCollection(userId:messageCon.userId.toString(),nickname: nickname);
          FirestoreServices.updateContactUsCollectionUsers(userId:messageCon.userId.toString(),nickname: nickname);
        }
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isLoading(false);
    }
  }

  checkTokenValidity(BuildContext context) async {
    try {
      var response = await repo.checkToken();
      if (response != null) {
        notifyFlg.value = response.data.notifyFlg;
        if (response.data.notifyFlg == true && box.read("memberType") == 'member') {
          openPremiumAlertDialog(const ReportAlertDialog(), context);
        }
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
    }
  }

  notificationShiftDay() async {
    try {
      var response = await repo.notificationShiftDay();
      if (response != null) {
        if (kDebugMode) {
          print(response);
        }
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
    }
  }

  notificationShiftMonth() async {
    try {
      var response = await repo.notificationShiftMonth();
      if (response != null) {
        if (kDebugMode) {
          print(response);
        }
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
    }
  }

  openPremiumAlertDialog(route, context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                content: route,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  getPref() {
    final box = GetStorage();
    memberType = box.read('memberType').toString();
    isPremium = box.read('isPremium').toString();
  }

  resetPassword() async {
    var data = {'email': email};
    var params = jsonEncode(data);
    try {
      isLoading(true);
      var response = await repo.resetPassword(params);
      if (response != null) {
        showToastMessage(response.data['message']);
        return true;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }
  
  verifyResetPassword() async {
    var data = {'token': token};
    var params = jsonEncode(data);
    try {
      isLoading(true);
      var response = await repo.verifyResetPassword(params);
      if (response != null) {
        showToastMessage(response.data['message']);
        return response;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  changePassword(password, confirmPassword, token) async {
    var data = {
      'password': password,
      'password_confirmation': confirmPassword,
      'token': token
    };
    var params = jsonEncode(data);
    try {
      isLoading(true);
      var response = await repo.changePassword(params);
      if (response != null) {
        showToastMessage(response.data['message']);
        return true;
      }
    } catch (e) {
      e.toString();
    } finally {
      isLoading(false);
      update();
    }
  }

  getFirstLoginMessage() async {
    try {
      firstLoginMessage.clear();
      isFirstLoginMessageLoading(true);
      var response = await repo.firstLoginMessage();
      if (response != null) {
        firstLoginMessage.addAll(response.data);
      }
    } catch (e) {
      e.toString();
    } finally {
      update();
      isFirstLoginMessageLoading(false);
    }
  }

 }