import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/repository/chatrepo/message_repo.dart' as repo;
import 'package:msa/widgets/toast_message.dart';
import 'package:path/path.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MessageController extends GetxController {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  //Message Page
  List groupList = [];

  //chat_page
  final FlutterListViewController flutterListController = FlutterListViewController();
  final TextEditingController chatTextCon = TextEditingController();
  final TextEditingController chatSearchTextController = TextEditingController();
  int currentSearchJumpIndex = 0;
  RxBool searchBarDisabled = true.obs;
  RxInt totalSearchResult = 0.obs;
  List searchResultIndex = [];
  List<dynamic> mentionNames = [];
  int currentMessageLength = 0;
  bool tappedGroup = false; //when group is clicked to go in chat page

  //messageIndex
  var currentSelectedIndex = 0;

  //inquiry chat
  final inquiryChatTextCon = TextEditingController();
  final inquirySearchUserTextCon = TextEditingController();
  final options = ["1", "2", "3", "4"];

  String memberType = '';
  int userId = 0;
  String searchText = '';
  String isPremium = '';
  String userName = '';
  String nickName = '';
  String profileImageUrl = '';
  String inquirySearchText = '';
  String editId = '';
  RxBool replyMsg = false.obs;
  bool needsScroll = false;
  RxBool imagePicked = false.obs;
  RxBool multiImagePicked = false.obs;
  // ignore: prefer_typing_uninitialized_variables
  var replyData;
  bool imageUploading = false;
  RxBool searchInChat = false.obs;
  final picker = ImagePicker();
  // ignore: unused_field
  XFile? imageFile;
  List<XFile> multiImagefiles = [];
  RxDouble progress = 0.0.obs;

  var selectedImageHeight = 0;

  bool showScrollToBottomBtn = false;

  RxString completedUploadImages = '0.0 %'.obs;

  RxBool isVisibleMsgMenu = false.obs;
  int imageUploaded = 0;

  getPref() async{
    final box = GetStorage();
    memberType = box.read('memberType');
    userId = box.read('userID') != "" ? box.read('userID') : 0;
    isPremium = box.read('isPremium').toString();
    userName = box.read('userName').toString();
    nickName = box.read('nickName').toString();
    profileImageUrl = box.read('profileImageUrl').toString();
  }

  chatStatusText(number){
    if(number == '1'){
      return '未返信';
    }else if(number == '2'){
      return '確認済';
    }else if(number == '3'){
      return '要確認';
    }else if(number == '4'){
      return 'トラブル';
    }
  }

  chatStatusColor(number){
    if(number == '1'){
      return red;
    }else if(number == '2'){
      return primaryColor;
    }else if(number == '3'){
      return blue;
    }else if(number == '4'){
      return borderWrapper;
    }
  }

  addMember(chatTopicId) async {
    try {
      var data = {
        'chat_topic_id': int.parse(chatTopicId),
        "user_id": userId,
        "member_nick_name":userName
      };
      var params = jsonEncode(data);
      var response = await repo.addGroupMember(params);
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    }
  }

  leaveGroup(chatTopicId) async {
    try {
      var data = {
        'chat_topic_id': int.parse(chatTopicId),
        "user_id": userId,
      };
      var response = await repo.leaveGroup(data);
      if (response != null) {
        return true;
      }
    } catch (e) {
      e.toString();
    }
  }

  getImageHeight()async{
    File image = File(imageFile!.path);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    selectedImageHeight = decodedImage.height;  
    return selectedImageHeight;
  }

  void openDeleteDialog(content,context) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              content: content,
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      }
    );
  }

  Future<void> onOpen(LinkableElement link) async {
    if (await canLaunchUrlString(link.url)) {
      await launchUrlString(link.url,mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  getMemberInfo(id)async{
    try {
      var response = await repo.memberInfo(id);
      if (response != null) {
        var data = {
          'title': response['nickname'],
          'imageUrl': response['image_url'],
          'subtitle':response['designation']
        };
        if(response['nickname']!=null){
          mentionNames.add(data);
        }
        update();
        if (kDebugMode) {
          print(mentionNames);
        }
      }
    } catch (e) {
      e.toString();
    }
  }

  //Image Pick Controls

  Future pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30
    );
    imageFile = pickedFile;
    if(imageFile!=null){
      imagePicked.value = true;
      scrollToBottomInit();
    }
    update();
  }

  Future pickMultiImage() async {
    try{
      final pickedFiles = await picker.pickMultiImage(imageQuality: 30);
      if(pickedFiles != null){
        multiImagefiles = pickedFiles;
        multiImagePicked.value = true;
        scrollToBottomInit(); 
        showScrollToBottomBtn=false;
        update();
      }
    }
    catch(e){
      if (kDebugMode) {
        showToastMessage("ファイル選択失敗しました");
      }
    }
  }

  Future pickImageCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30
    );
    multiImagefiles.add(pickedFile!);
    if(multiImagefiles.isNotEmpty){
      multiImagePicked.value = true;
    }
    update();
  }

  //Search Jump Controls

  void jumpToIndex(jumpToIndex,searchIndex)async{
    currentSearchJumpIndex = searchIndex;
    update();
    flutterListController.sliverController.jumpToIndex(jumpToIndex);
  }

  void jumpUp(){
    int nextSearchJumpIndex;
    if(currentSearchJumpIndex>=searchResultIndex.length-1){
      nextSearchJumpIndex = 0;
    }else{
      nextSearchJumpIndex = currentSearchJumpIndex+1;
    }
    flutterListController.sliverController.jumpToIndex(searchResultIndex[nextSearchJumpIndex]);
    currentSearchJumpIndex = nextSearchJumpIndex;
    update();
  }

  void jumpDown(){
    int prevSearchJumpIndex;
    if(currentSearchJumpIndex<=0){
      prevSearchJumpIndex = searchResultIndex.length-1;
    }else{
      prevSearchJumpIndex = currentSearchJumpIndex-1;
    }
    flutterListController.sliverController.jumpToIndex(searchResultIndex[prevSearchJumpIndex]);
    currentSearchJumpIndex = prevSearchJumpIndex;
    update();
  }

  //Chat Menu Controls

  hideChatMenu(){
    if(isVisibleMsgMenu.value == true){
      isVisibleMsgMenu.value = false;
      update();
    }
  }

  //Scroll Controls

  void scrollToBottomInit(){
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if(flutterListController.hasClients){
        showScrollToBottomBtn=false;
        flutterListController.jumpTo( 
          0.0, 
        );
        update();
      }
    });
  }

  void showFloationButton() {
    showScrollToBottomBtn = true;
    update();
  }

  void hideFloationButton() {
    showScrollToBottomBtn = false;
    update();
  }

  void handleScroll() async {
    flutterListController.addListener(() {
      if (flutterListController.position.userScrollDirection == ScrollDirection.reverse && flutterListController.position.pixels>1500.0) {
        if (showScrollToBottomBtn == false) {
          showFloationButton();
        }
      }

      if (flutterListController.position.userScrollDirection == ScrollDirection.forward && flutterListController.position.pixels<=100.0) {
        if (showScrollToBottomBtn == true) {
          hideFloationButton();
        }
      }
    });
  }

  Future sendImageMessage(id,unixTimestamp,collectionName) async{
    completedUploadImages.value='0.0 %';
    update();
    int i = 0;
    await Future.forEach(multiImagefiles, (item) async 
    {
      await uploadImageToFirebase(
        item,
        i++,
        id.toString(),
        userId.toString(),
        nickName!=""&&nickName!="null"?nickName:userName,
        profileImageUrl,
        collectionName,
        unixTimestamp,
        id, 
        userId.toString(),
        memberType,
        multiImagefiles.length 
      );
    });
    // for (var i = 0; i < multiImagefiles.length; i++) {
    //   if(i==0){
    //     await uploadImageToFirebase(
    //       multiImagefiles[i],
    //       i+1,
    //       id.toString(),
    //       userId.toString(),
    //       nickName!=""&&nickName!="null"?nickName:userName,
    //       profileImageUrl,
    //       collectionName,
    //       unixTimestamp,
    //       id, 
    //       userId.toString(),
    //       memberType,
    //       multiImagefiles.length 
    //     );
    //   }
    //   else{
    //     Future.delayed(const Duration(seconds: 1), ()async{
    //       await uploadImageToFirebase(
    //         multiImagefiles[i],
    //         i+1,
    //         id.toString(),
    //         userId.toString(),
    //         nickName!=""&&nickName!="null"?nickName:userName,
    //         profileImageUrl,
    //         collectionName,
    //         unixTimestamp,
    //         id, 
    //         userId.toString(),
    //         memberType,
    //         multiImagefiles.length 
    //       );
    //     });
    //   }
    // }
    scrollToBottomInit();
    hideFloationButton();
  }

  uploadImageToFirebase(
    image,
    i,
    docId,
    senderId,
    senderName,
    senderProfileImageUrl,
    forPage,
    preunix,
    removeDocId,
    userId,
    memberType,
    totalImages
    ) async {
    imageUploading = true;
    update();
    String url;
    String fileName = basename(image!.path);
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image!.path));
    uploadTask.snapshotEvents.listen((event) {
    }).onError((error) {
      // do something to handle error
      imageUploading = false;
      multiImagefiles=[];
      multiImagePicked.value =false;
      showToastMessage('処理失敗しました');
    });
    await uploadTask.whenComplete(() async{
      imageUploaded = imageUploaded + 1;
      completedUploadImages.value = (imageUploaded/totalImages*100).toString()+' %';
      progress((imageUploaded/totalImages)*1.0);
      update(); 
      url = await firebaseStorageRef.getDownloadURL();
      if(url!=''){
        if(forPage == 'contactUs'){
          await FirestoreServices.sendImageMessageInquiry(
            docId: docId, 
            senderId: int.parse(senderId), //
            senderName: senderName, //
            senderProfileImageUrl: senderProfileImageUrl,// 
            text: '',
            fileUrl: url,
            fileName: fileName, 
            memberType: memberType
          );
        }else{
          await FirestoreServices.sendImageMessage(
            docId: docId, 
            senderId: int.parse(senderId), //
            senderName: senderName, //
            senderProfileImageUrl: senderProfileImageUrl,// 
            text: '',
            fileUrl: url,
            fileName: fileName, 
            preunix: preunix, 
            removeDocId: removeDocId, 
            userId: userId
          );
        }
        if(imageUploaded == multiImagefiles.length){
          imageUploading = false;
          multiImagefiles=[];
          multiImagePicked.value =false;
          completedUploadImages.value='0.0 %';
          imageUploaded = 0;
          progress( 0.0);
          update();
        }
        update();
        return true;
      }
    });
  }
}
