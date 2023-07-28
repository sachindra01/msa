import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/device_id.dart';
import 'package:msa/views/auth/first_login_edit.dart';
import 'package:msa/views/auth/login.dart';
import 'package:msa/views/drawerpages/inquirypage.dart';
import 'package:msa/widgets/bottom_navigation.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/';
  const SplashPage({ Key? key }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getDeviceId();
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () => initialRoute()
      // Navigator.of(context).pushNamed(LoginPage.routeName)
    ); 
  }

  initialRoute(){
    var box = GetStorage();
    var token = box.read('apiToken');
    var firstLogin = box.read('firstLogin');
    var isPremium = box.read('isPremium');
    var memberType = box.read('memberType');
    debugPrint('apiToken => $token');
    if(token == null) {
      Get.to(() => const LoginPage());
    } else {
      firstLogin == true
      ? Get.off(() => const FirstLogInEdit())
      : isPremium || memberType == 'host'
      ? Get.off(() => const BottomNavigation())
      : Get.off(()=> const InquiryPage());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 100.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/icons/msa.gif'),
            ),
          ),
          child: const Center(child: Text('')),
        ),
      )
    );
  }
}