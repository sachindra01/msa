import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/message_controller.dart';
import 'package:msa/controller/searchcontroller/search_controller.dart';
import 'package:msa/models/chatmodels/contact_us_info.dart';
import 'package:msa/services/firestore_services.dart';
import 'package:msa/views/article/article.dart';
import 'package:msa/views/home/music_page_manager.dart';
import 'package:msa/views/home/radio_list.dart';
import 'package:msa/views/message/message.dart';
import 'package:msa/views/auth/account.dart';
import 'package:msa/views/profile/notification_page.dart';
import 'package:msa/views/profile/profile.dart';
import 'package:msa/widgets/custom_dialog.dart';
import 'package:msa/widgets/logout_alert.dart';
import 'package:msa/widgets/music_player_widget.dart';
import 'package:msa/widgets/webview_page.dart';

class BottomNavigation extends StatefulWidget {
  static const routeName = '/homepage';
  const BottomNavigation({Key? key}) : super(key: key);
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = Get.arguments ?? 0;
  bool isChecked = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final SearchController _scon = Get.put(SearchController());
  final MessageController _messageCon = Get.put(MessageController());
  // ignore: unused_field
  final PageManagerController _pageManagerController = Get.put(PageManagerController());
  // final List<String> title = [' ホーム ', ' 記事 ', ' タイムライン ', ' チャット ', ' マイページ '];
  final List<String> title = ['コンテンツ',"ラジオ",'チャット','マイページ'];
  

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scon.customIcon.value = !_scon.searchBoxEnabled.value? const Icon(Icons.search) : const Icon(Icons.cancel);
      _scon.keyword.value == '';
    });
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _scon.textcon.text = '';
      _scon.keyword.value == '';
      _scon.searchBoxEnabled.value = false;
      _scon.movieList.clear();
      appBarTitle = Text(
        title[index],
        style: const TextStyle(fontSize: 16.0),
      );
      _scon.customIcon.value = const Icon(Icons.search);
      if(_selectedIndex == 2) 
      {
        _scon.searchVisible.value = false;
      }
      else
      {
        _scon.searchVisible.value = true;
      }
    });
  }

  Widget appBarTitle = const Text(
    "コンテンツ",
    style: TextStyle(fontSize: 16.0),
  );


  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      //const HomePage(),
      const ArticlePage(), 
      const RadioListPage(),
      // const TimeLinePage(), 
      const MessagePage(), 
      const ProfilePage()
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset:true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Obx(() => 
          AppBar(
            leading: InkWell(
              onTap: (){
                scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8,bottom: 8),
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))
                ),
              //  color: white,
                child: const Icon(Icons.menu,color: primaryColor,)
              ),
            ),
            title: _scon.searchBoxEnabled.value ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(color: white),
              controller: _scon.textcon,
              cursorColor: whiteGrey,
              onChanged: (value) {
                setState(() {
                  _scon.keyword.value = value;
                  _scon.customIcon.value = const Icon(
                                      Icons.cancel,
                                      color: white,
                                    );
                  _scon.searchBoxEnabled.value = true;
                  if (_scon.textcon.text != '') {
                    _scon.searchMovieList();
                  } else {
                    _scon.movieList.clear();
                  }
                });
              },
              // onTap: (() => Get.to(() => SearchPage())),
              decoration: InputDecoration(
                  focusColor: white,
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: white,
                    ),
                    onPressed: () {},
                  ),
                  contentPadding: const EdgeInsets.only(left: 16, right: 16),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 31, 124, 113),
                  hintText: '検索',
                  hintStyle: const TextStyle(color: primaryColor),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5.0),
                  ))),
                ): appBarTitle,
              centerTitle: true,
              backgroundColor: primaryColor,
              actions: [
                Obx(()=>Visibility(
                  visible: _scon.searchVisible.value,
                  child: InkWell(
                    onTap: (){
                       _selectedIndex == 3
                          ?Get.to(()=> const NotificationPage())
                          : setState(() {
                            if (_scon.customIcon.value.icon == Icons.search) {
                              _scon.customIcon.value = const Icon(Icons.cancel);
                              _scon.searchBoxEnabled.value = true;
                              
                            } else {
                              _scon.searchBoxEnabled.value = false;
                              _scon.textcon.text = '';
                              _scon.customIcon.value = const Icon(Icons.search);
                              appBarTitle = Text(title[_selectedIndex]);
                            }
                          });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 8,bottom: 8,right: 10),
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      decoration:  BoxDecoration(
                        color: transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                            BoxShadow(
                              color: _scon.customIcon.value.icon == Icons.search && _selectedIndex != 4 
                                  ? const Color.fromARGB(255, 18, 134, 122) 
                                  : transparent,
                             
                              blurRadius: 0.2,
                            ),
                          ],
                      ),
                      child: _selectedIndex == 3
                        ? const Icon(
                          Icons.notifications,
                          color: white,
                        )
                        : _scon.customIcon.value
                      
                    ),
                  ),
                )),
              ],
            ),
          )
        ),
        drawer: Drawer(
          backgroundColor: white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/msc.png',
                width: 100,
                height: 100,
              ),
              const Center(
                child: Text(
                  'もりもとらせどりコミュニティ',
                  style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                leading: drawerLeadingIcon('ic_account'),
                iconColor: primaryColor,
                title: const Text('アカウント情報'),
                onTap: () {
                  Get.back();
                  Get.to(()=> const AccountPage(),
                  transition: Transition.rightToLeftWithFade);
                  //Navigator.of(context).pushNamed(AccountPage.routeName);
                },
              ),
              // ListTile(
              //   leading: drawerLeadingIcon('ic_about'),
              //   iconColor: primaryColor,
              //   title: const Text('お問い合わせ'),
              //   onTap: () {
              //     Get.back();
              //     //Navigator.pushNamed(context, '/inquiry');
              //     Get.to(()=> const InquiryPage(),
              //     transition: Transition.rightToLeftWithFade);
              //   },
              // ),
              ListTile(
                leading: drawerLeadingIcon('ic_about'),
                iconColor: primaryColor,
                title: const Text('利用規約'),
                onTap: () => Get.to(() => const WebviewPage(), arguments: [0, 'TAC']),
              ),
              ListTile(
                leading: drawerLeadingIcon('ic_about'),
                iconColor: primaryColor,
                title: const Text('プライバシーポリシー'),
                onTap: () => Get.to(() => const WebviewPage(), arguments: [0, 'PP']),
              ),
              ListTile(
                leading: drawerLeadingIcon('ic_logout'),
                iconColor: primaryColor,
                title: const Text('ログアウト'),
                onTap: () {
                openCustomDialog(const LogoutAlertDialog(),context);
                },
              )
            ],
          ),
        ),
        backgroundColor: primaryColor,
        extendBody: false,
        extendBodyBehindAppBar: false,
        body: Container(
          color: Colors.white, 
          child: Stack(
            children: [
              Center(
                child: _children[_selectedIndex]
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:  Player()
              ), 
            ]
          )
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          backgroundColor: white,
          iconSize: 32.0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: primaryColor.withOpacity(0.70),
          selectedLabelStyle: const TextStyle(height: 1.5, fontWeight: FontWeight.bold
              // letterSpacing: Get.locale == Locale('ja') ? -3 : 0,
              ),
          unselectedLabelStyle: const TextStyle(
            height: 1.5,
            // letterSpacing: Get.locale == Locale('ja') ? -3 : 0,
          ),
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          items: <BottomNavigationBarItem>[
            //article
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2,top: 2),
                height: 24,
                child: SvgPicture.asset(
                  "assets/icons/nav/article.svg",
                  color: primaryColor.withOpacity(0.60),
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.only(bottom: 2,top: 2),
                height: 24,
                child: SvgPicture.asset(
                  "assets/icons/nav/article-green.svg",
                  color: primaryColor,
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              label: 'コンテンツ',
            ),
            //radio
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2,top: 2),
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  "assets/icons/nav/radio.svg",
                  color: primaryColor.withOpacity(0.60),
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              activeIcon: Container(
                height: 24,
                padding: const EdgeInsets.only(bottom: 2,top: 2),
                child: SvgPicture.asset(
                  "assets/icons/nav/radio-green.svg",
                  color: primaryColor,
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              label: 'ラジオ',
            ),
            // BottomNavigationBarItem(
            //   icon: Container(
            //     height: 24,
            //     padding: const EdgeInsets.only(bottom: 2,top: 2),
            //     child: SvgPicture.asset(
            //       "assets/images/main_logo.svg",
            //       color: Colors.black.withOpacity(0.54),
            //       width: 20.0,
            //       height: 20.0,
            //       alignment: Alignment.topCenter
            //     ),
            //   ),
            //   activeIcon: Container(
            //     height: 24,
            //     padding: const EdgeInsets.only(bottom: 2,top: 2),
            //     child: SvgPicture.asset(
            //       "assets/images/main_logo.svg",
            //       color: Colors.black.withOpacity(0.54),
            //       width: 20.0,
            //       height: 20.0,
            //     ),
            //   ),
            //   label: 'タイムライン',
            // ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 2,top: 2),
                    height: 24,
                    child: SvgPicture.asset(
                      "assets/icons/nav/chat.svg",
                      color: primaryColor.withOpacity(0.60),
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                  _messageCon.memberType=="member" 
                  ?StreamBuilder<ContactUsInfo>(
                    stream: FirestoreServices.getContactUsInfoList(_messageCon.userId.toString()),
                    builder:(BuildContext context, AsyncSnapshot contactUsInfoSnapshot) {
                      if (contactUsInfoSnapshot.hasError || !contactUsInfoSnapshot.hasData) {
                        return const SizedBox();
                      } 
                      else{
                        return contactUsInfoSnapshot.data.userUnreadMessage=="0"
                        ?const SizedBox()
                        :Positioned(
                          top: 0,
                          right: 0,
                          child: Badge()
                        );
                      }
                    }
                  )
                  :const SizedBox(),
                ],
              ),
              activeIcon: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 2,top: 2),
                    height: 24,
                    child: SvgPicture.asset(
                      "assets/icons/nav/chat.svg",
                      color: primaryColor,
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                  _messageCon.memberType=="member" 
                  ?StreamBuilder<ContactUsInfo>(
                    stream: FirestoreServices.getContactUsInfoList(_messageCon.userId.toString()),
                    builder:(BuildContext context, AsyncSnapshot contactUsInfoSnapshot) {
                      if (contactUsInfoSnapshot.hasError || !contactUsInfoSnapshot.hasData) {
                        return const SizedBox();
                      } 
                      else{
                        return contactUsInfoSnapshot.data.userUnreadMessage=="0"
                        ?const SizedBox()
                        :Positioned(
                          top: 0,
                          right: 0,
                          child: Badge()
                        );
                      }
                    }
                  )
                  :const SizedBox(),
                ],
              ),
              label: 'チャット',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/nav/profile_on.svg",
                color: primaryColor.withOpacity(0.60),
                width: 24.0,
                height: 24.0,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/nav/profile_on.svg",
                color: primaryColor,
                width: 24.0,
                height: 24.0,
              ),
              label: 'マイページ',
            ),
          ],
        ),
      ),
    );
  }

  drawerLeadingIcon(icon) {
    return SvgPicture.asset(
      'assets/icons/sidebar/$icon.svg',
      width: 30.0,
      height: 30.0,
    );
  }
}
