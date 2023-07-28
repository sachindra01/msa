// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/controller/imagepicker_controller.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/step_widget2.dart';
import 'package:msa/widgets/toast_message.dart';

class ProfileEditPage extends StatefulWidget {
  static const routeName = '/profile/editprofile';
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final AuthController _con = Get.put(AuthController());
  final ImagePickerController _imgcon = Get.put(ImagePickerController());
  final _nicknameCon = TextEditingController();
  final _designationCon = TextEditingController();
  final _shortDescCon = TextEditingController();
  final _twitterCon = TextEditingController();
  var args = Get.arguments;
  var _validate = true;
  var _validateDesc = true;
  final box =GetStorage();
  bool edited = false;
  var textDataEdited = false.obs;

  @override
  void initState() {
    _imgcon.getAvatar();
    Future.delayed(Duration.zero, () {
      _nicknameCon.text = args.nickname;
      _designationCon.text = args.designation ?? '';
      _shortDescCon.text = args.shortDescription;
      _twitterCon.text = args.twitterLink ?? '';
      _con.nickname = _nicknameCon.text;
      _con.designation = _designationCon.text;
      _con.shortDescription = _shortDescCon.text;
      _con.twitter = _twitterCon.text;
    });
    super.initState();
  }
  
  var _selectedImage;
  var enableBack = false;
 

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - 300 - (MediaQuery.of(context).padding.top + kToolbarHeight);
    return WillPopScope(
      onWillPop: () async{
       args.firstLogin == false ? Get.back( result: edited) : null;
        return !args.firstLogin;
      },
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  if (_nicknameCon.text.trim()!="" && _shortDescCon.text.trim()!="") {
                    _con.updateMemberInfo();
                  } else {
                    showToastMessage("必須項目を入力してください。");
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Obx((() => 
                textDataEdited.value &&_con.isLoading.value ? SizedBox(
                    height: 25,
                    width: 25,
                    child: loadingWidget(),
                  ) :Text("保存",style: TextStyle(fontWeight: textDataEdited.value ? FontWeight.bold : FontWeight.normal),)
                )),
              )
            ],
            title: const Text("プロフィール"),
            backgroundColor: white,
            foregroundColor: black,
            automaticallyImplyLeading: !args.firstLogin,
          ),
          body: Obx(() => 
            _imgcon.isLoading.value == true
            ? Center(child: loadingWidget(),) 
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10,bottom: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: box.read('firstLogin') ? const StepWidget2() : const SizedBox(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (() {
                        enableBack = true;
                        showDialog(
                          context: context,
                          builder: (_) {
                            return GetBuilder(
                              init: ImagePickerController(),
                              builder: (_) {
                                return WillPopScope(
                                  onWillPop: ()async{
                                    enableBack ? Get.back() : null;
                                    return false;
                                  },
                                  child: Dialog(
                                    insetPadding: EdgeInsets.only(top: height * 0.015),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      width: MediaQuery.of(context).size.width * 0.85,
                                      height: height * 1.3,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.zero,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.65,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    enableBack ? Get.back() : null; 
                                                  },
                                                  icon: const Icon(Icons.close)
                                                )
                                              ],
                                            ),
                                          ),
                                          
                                          Expanded(
                                            child: GridView.builder(
                                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, childAspectRatio: 3 / 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                                              itemCount: _imgcon.avatars.length + 1,
                                              itemBuilder: (BuildContext ctx, index) {
                                                return index == 0 
                                                ?  InkWell(
                                                  onTap: () => showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return SimpleDialog(
                                                        insetPadding: const EdgeInsets.all(0),
                                                        title:  Row(
                                                          children:  [
                                                            const Spacer(),
                                                            const Text(
                                                              "から画像を選択 ",
                                                              textAlign: TextAlign.center,
                                                              style: movielistCatStyle
                                                            ),
                                                            const Spacer(),
                                                            IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              icon: const Icon(
                                                                Icons.close,size: 25
                                                              )
                                                            ),
                                                          ],
                                                        ),
                                                        alignment: Alignment.bottomCenter,
                                                        contentPadding: const EdgeInsets.all(10),
                                                        elevation: 5,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 50,
                                                            width: MediaQuery.of(context).size.width*1,
                                                            child: Card(
                                                              elevation: 2,
                                                              child: SimpleDialogOption(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    edited = true;
                                                                    enableBack = false;
                                                                  });
                                                                  _imgcon.pickImageFromGallery().then((_)=>[
                                                                    if(_imgcon.image.path != '') {
                                                                      setState((){
                                                                        _selectedImage = _imgcon.image;
                                                                      }),
                                                                       _imgcon.uploadImage( args.firstLogin ? args.id :_con.userInfo.user.id),
                                                                    } else {
                                                                      Get.back()
                                                                    }
                                                                  ]);
                                                                  Get.back();
                                                                },
                                                                child: const Center(
                                                                  child: Text('ギャラリー',style: catTitleStyle,),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                            child: Card(
                                                              elevation: 2,
                                                              child: SimpleDialogOption(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    edited=true;
                                                                    enableBack = false;
                                                                  });
                                                                  _imgcon.pickImageFromCamera().then((_)=>[
                                                                    if(_imgcon.image.path != '') {
                                                                      setState((){
                                                                        _selectedImage = _imgcon.image;
                                                                      }),
                                                                      _imgcon.uploadImage( args.firstLogin ? args.id :_con.userInfo.user.id),
                                                                    } else {
                                                                      Get.back()
                                                                    }
                                                                  ]);
                                                                  Get.back();
                                                                  
                                                                },
                                                                child: const Center(
                                                                  child: Text(' カメラ',style: catTitleStyle),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  ),
                                                  child: _imgcon.isLoading.value == true 
                                                  ? CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor: primaryColor,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: const CustomShimmer(
                                                        height: 95,
                                                        width: 95,
                                                      ),
                                                    ),
                                                  )
                                                  : CircleAvatar(
                                                    backgroundColor: lightgrey,
                                                    radius: 42,
                                                    child: _imgcon.image.path == ''
                                                      ? Stack(
                                                        children: const [
                                                          Icon(
                                                            Icons.person_rounded,
                                                            size: 80,
                                                            color: white,
                                                          ),
                                                          Positioned.fill(
                                                            top: 62,
                                                            left: 62,
                                                            child: Icon(
                                                              Icons.camera_alt_rounded,
                                                              color: black,
                                                            ),
                                                          )
                                                        ]
                                                      )
                                                      : ClipRRect(
                                                        clipBehavior: Clip.hardEdge,
                                                        borderRadius: BorderRadius.circular(100),
                                                        child: Image.file(
                                                          _imgcon.image,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                        )
                                                      ),
                                                  ),
                                                )
                                                :SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: IgnorePointer(
                                                    ignoring: !enableBack,
                                                    child: InkWell(
                                                      onTap: () => [
                                                        setState(() {
                                                          edited = true;
                                                          _selectedImage = _imgcon.avatars[index - 1].src;
                                                        }),
                                                        _imgcon.storeAvatar(_imgcon.avatars[index - 1].code),
                                                        Get.back(),
                                                        if(!args.firstLogin){
                                                          FirestoreServices.uploadProfileImage(userId: _imgcon.userId.toString(), imageUrl: _selectedImage)}
                                                      ],
                                                     child: CircleAvatar(
                                                       radius: height*0.1,
                                                       backgroundColor: transparent,
                                                       child: ClipRRect(
                                                         borderRadius: BorderRadius.circular(500),
                                                         child: CachedNetworkImage(
                                                           fit: BoxFit.cover,
                                                           imageUrl: _imgcon.avatars[index -1 ].src,
                                                           errorWidget: (context, url,_)=>Image.asset(
                                                             'assets/images/no_image_new.png',
                                                             width: 100,
                                                             height: 100,
                                                             fit: BoxFit.cover,
                                                           ),
                                                         ),
                                                       )
                                                     )
                                                    ),
                                                  ),
                                                );
                                              }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            );
                          }
                        );
                      }),
                      child: Container(
                        height: height * 0.25,
                        color: white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start, 
                          children: [
                            CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 43,
                              child: ClipRRect( 
                                borderRadius: BorderRadius.circular(40.0),
                                child: 
                                _selectedImage == null 
                                ? CachedNetworkimage(
                                  height: 80,
                                  width: 80,
                                  imageUrl: args.profileImage,
                                ) 
                                : _selectedImage is String 
                                ? CachedNetworkimage(imageUrl: _selectedImage, width: 80, height: 80)
                                : Image.file(_imgcon.image,height: 80,width: 80,fit: BoxFit.cover,) 
                              )        
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'プロフィール写真を変更する',
                              style: TextStyle(fontSize: 14.0, color: textColor1, fontWeight: FontWeight.bold),
                            ),
                          ]
                        ),
                      ),
                    ),
                    //Designation Required
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text(
                            'ユーザー名 ',
                            style: formTitleStyle,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: formRequirdText,
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _nicknameCon,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          textDataEdited.value = true;
                          _con.nickname = _nicknameCon.text;
                          if (_nicknameCon.text == "") {
                            _validate = false;
                          } else {
                            _validate = true;
                          }
                        });
                      },
                      // initialValue: args.nickname,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: white,
                        hintText: '未設定',
                        hintStyle: const TextStyle(color: primaryColor),
                        contentPadding: const EdgeInsets.only(left: 10, right: 10),
                        errorText: !_validate ? 'ユーザー名は必須項目となります。' : null,
                      ),
                    ),
                    //EmailAddress
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        '得意仕入れジャンル',
                        style: formTitleStyle,
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      // initialValue: args.designation,
                      controller: _designationCon,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          textDataEdited.value = true;
                          _con.designation = _designationCon.text;
                        });
                      },
                      enabled: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: white,
                        hintText: '例) 楽天ポイントせどり',
                        hintStyle: TextStyle(color: primaryColor),
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                    //Introduction Requirerd
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text(
                            '紹介文 ',
                            style: formTitleStyle,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: formRequirdText,
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: _shortDescCon,
                      // textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          textDataEdited.value = true;
                          _con.shortDescription = _shortDescCon.text;
                          if (_shortDescCon.text == "") {
                            _validateDesc = false;
                          } else {
                            _validateDesc = true;
                          }
                        });
                      },
                      enabled: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: white,
                        hintText: '300文字まで',
                        hintStyle: const TextStyle(color: primaryColor),
                        errorText: !_validateDesc ? '紹介文は必須項目となります。 ' : null,
                        contentPadding: const EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                    //twitter acc
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        'Twitter ID',
                        style: formTitleStyle,
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _twitterCon,
                      // initialValue: args.twitterLink,
                      onChanged: (value) {
                        setState(() {
                          textDataEdited.value = true;
                          _con.twitter = _twitterCon.text;
                        });
                      },
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: white,
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                  ],
                ),
              )
            )
          ),
        ),
      ));
  }
}
