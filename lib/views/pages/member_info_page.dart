import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';

import 'package:msa/widgets/circular_avatar_widget.dart';
import 'package:msa/widgets/loading_widget.dart';


//Member Details Page (On clicking Circle Avatar on Comments or From Chat)

class MemberInfoPage extends StatefulWidget {
  const MemberInfoPage({ Key? key }) : super(key: key);
  

  @override
  State<MemberInfoPage> createState() => _MemberInfoPageState();
}

class _MemberInfoPageState extends State<MemberInfoPage> {
  final AuthController _con = Get.put(AuthController());
  var args = Get.arguments;
  @override
  void initState() {
    _con.getMemberInfo(args);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: pagesAppbar,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: black, //change your color here
        ),
        title: const Text(
          'プロフィール',
          style: TextStyle(color: black, fontSize: 16),
        ),
      
      ),
      body:GetBuilder(
        init: AuthController(),
        builder: (context) {
          return Obx(() => _con.isMemLoading.value == true
              ? Center(child: loadingWidget())
              : (_con.memberInfo == null)
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : memberInfoBody());
        })
      );
    
}
memberInfoBody(){
    var now = DateTime.now();
    int date = now.year;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const  SizedBox(height: 30,),
        Container(
          padding: const EdgeInsets.only(top: 10, left: 0,bottom: 10),
          //  padding: const EdgeInsets.only(top: 10,bottom: 10,),
         
          color: white,
          child: Row(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CircularAvatarWidget(imageUrl: _con.memberInfo.imageUrl, width: 80, height: 80),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                       width: MediaQuery.of(context).size.width*0.58,
                      child: Text(_con.memberInfo.nickname,style: formTitleStyle,)),
                    Row(children: [ 
                      _con.memberInfo.showAge 
                               ? Text((date -int.parse(_con.memberInfo.dobYear)).toString().substring(0,1) + "0代  "+ " |  ",style: formTitleStyle,)  
                               : const SizedBox() ,
                      !_con.memberInfo.status || _con.memberInfo.address1 =="" || _con.memberInfo.address1 == null
                                ? const SizedBox() 
                                : Text(_con.prefectureList[int.parse(_con.memberInfo.address1,)],style: formTitleStyle,)
                      ],)
                   
                  ],
                ),
              ),
            ],
          ),
        ),
         Container(
           width: MediaQuery.of(context).size.width,
           
          padding: const EdgeInsets.only(top: 25,bottom: 10,left: 20),
          child: const Text('得意仕入れジャンル',style: formTitleStyle,),
        ),

        Container(
           width: MediaQuery.of(context).size.width,
           color: white,
          padding: const EdgeInsets.only(top: 25,bottom: 10,left: 20),
          child: const Text('店舗せどり',style: formTitleStyle,),
        ),

        _con.memberInfo.shortDescription != null
           ? Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 25,bottom: 10,left: 20),
                  child: const Text('紹介文',style: formTitleStyle,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: white,
                  padding: const EdgeInsets.only(top: 25,bottom: 10,left: 20,right: 15),
                  child:  Text(_con.memberInfo.shortDescription,style: formTitleStyle,),
                ),
              ],
            )
          : const SizedBox(),



           _con.memberInfo.twitterLink != null
           ? Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 25,bottom: 10,left: 20),
                  child: const Text('TWITTER ID',style: formTitleStyle,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: white,
                  padding: const EdgeInsets.only(top: 25,bottom: 10,left: 20,right: 20),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("@"+_con.memberInfo.twitterLink,style: formTitleStyle,),
                      SvgPicture.asset('assets/icons/twitter.svg',width: 10,height: 45,),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox(),
      ],
    ),
  );
}
}