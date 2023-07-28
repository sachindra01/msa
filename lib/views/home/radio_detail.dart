import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/views/home/music_page_manager.dart';
import 'package:msa/widgets/comment_widget.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/music_player_widget.dart';
import 'package:msa/controller/radio_list_controller.dart';
import 'dart:math' as math;

class RadioDetailPage extends StatefulWidget {
  static const routeName = '/radio/detail';
  final dynamic data;
  final dynamic frompage;
  const RadioDetailPage({Key? key, required this.data,this.frompage}) : super(key: key);

  @override
  State<RadioDetailPage> createState() => _RadioDetailPageState();
}

class _RadioDetailPageState extends State<RadioDetailPage> {
  final RadioController _con = Get.put(RadioController());
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  var count = 0;
  late final PageManagerController _pageManager;
  final expandedCon = ExpandableController();
  
  @override
  void initState() {
    super.initState();
    if(widget.frompage=='pn'){
      _pageManager = Get.put(PageManagerController());
      _con.getRadioDetail(widget.data.data['module_type_id']);
      _pageManager.url.value = widget.data.data['audioUrl'];
      _pageManager.radioTitle = widget.data.data['radioTitle'];
      _pageManager.albumArt =widget.data.data['profileImage'];
    }else if(widget.frompage=='pnfore'){
      _pageManager = Get.put(PageManagerController());
      _con.getRadioDetail(widget.data['module_type_id']);
      _pageManager.url.value = widget.data['audioUrl'];
      _pageManager.radioTitle = widget.data['radioTitle'];
      _pageManager.albumArt =widget.data['profileImage'];
    }
    else{
      _pageManager = Get.find();
      _con.getRadioDetail(widget.data.id);
      _pageManager.url.value = widget.data.audioUrl;
      _pageManager.radioTitle = widget.data.radioTitle;
      _pageManager.albumArt =widget.data.profileImage;
    }
    Future.delayed(
      Duration.zero,(() => 
      [
        _pageManager.isPlaying.value == false ?_pageManager.init() : null,_pageManager.isVisible.value = true,
        _pageManager.play(),
        _pageManager.isPlaying.value = true,
        _pageManager.isVisible.value = true,
      ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - 300 - (MediaQuery.of(context).padding.top + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          setState(() {
            // _pageManager.isVisible.value = _pageManager.isPlaying.value;
            _pageManager.isPlaying.value ? _pageManager.isVisible.value = true : _pageManager.isVisible.value = false;
          }); 
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            foregroundColor: black,
            backgroundColor: pagesAppbar,
            title:  Text(
              widget.frompage=='pn'?widget.data['radioTitle']:widget.data.radioTitle,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          ),
          body: GetBuilder(
            init: RadioController(),
            builder: (_) {
              return Obx(() => _con.isLoading.value == true || (_con.radioDetail == null)
              ? Center(child: loadingWidget())
              : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CachedNetworkimage(
                                  imageUrl: widget.frompage=='pn'?widget.data['profileImage']:widget.data.profileImage, 
                                ),
                              ),
                              Positioned(
                                bottom: -20,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Material(
                                    elevation: 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.amber,
                                      radius: 23,
                                      child: ValueListenableBuilder<ButtonState>(
                                        valueListenable: _pageManager.buttonNotifier,
                                        builder: (_, value, __) {
                                          switch (value) {
                                          case ButtonState.loading:
                                              return IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                setState(() {
                                                  _pageManager.play();
                                                  _pageManager.isPlaying.value = false;
                                                  _pageManager.isVisible.value = true;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.play_arrow,
                                                size: 35,
                                                color: white,
                                              )
                                            );
                                          case ButtonState.paused:
                                            return IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                setState(() {
                                                  _pageManager.play();
                                                  _pageManager.isPlaying.value = true;
                                                  _pageManager.isVisible.value = true;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.play_arrow,
                                                size: 35,
                                                color: white,
                                              )
                                            );
                                          case ButtonState.playing:
                                            return IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                setState(() {
                                                  _pageManager.pause();
                                                  _pageManager.isPlaying.value = false;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.pause,
                                                color: white,
                                              )
                                            );
                                        }}
                                      ),
                                    ),
                                  ),
                                ), 
                              ),                           
                            ],
                          ),   
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: const BoxDecoration(
                              color: transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, 
                                vertical: 10.0
                              ),
                              child: Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                mainAxisAlignment:MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        widget.frompage=='pn'?widget.data['categoryName']:widget.data.categoryName,
                                        style: catTitleStyle,
                                      ),
                                      const SizedBox(height: 10,),
                                      //  Html(data: _con.radioDetail.description1 ?? ''),
                                      ExpandablePanel(
                                        theme:  const ExpandableThemeData(
                                          headerAlignment:ExpandablePanelHeaderAlignment.center,
                                          tapBodyToCollapse: true,
                                          expandIcon: Icons.arrow_drop_down,
                                          collapseIcon: Icons.arrow_drop_up,
                                          iconColor: Colors.black,
                                          iconSize: 28.0,
                                          iconRotationAngle: math.pi / 2,
                                          iconPadding: EdgeInsets.only(right: 5),
                                          hasIcon: true,
                                        ),
                                        controller: expandedCon,
                                        header:  Text(
                                          widget.frompage=='pn'?widget.data['radioTitle']:widget.data.radioTitle,
                                          style: const TextStyle(color: catTitleyColor, fontSize: 18,fontWeight: FontWeight.bold),
                                        ),
                                        collapsed: const Text(
                                          '',
                                          softWrap: true,
                                          maxLines: 1,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                        expanded: _con.radioDetail.description1 == null ? const Text("") : Html(data: _con.radioDetail.description1,),
                                      ),
                                      const SizedBox(height: 10,),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              splashColor:activityDivider,
                                              onTap: ()  async{
                                                var success=    await _activityCon.likeUnlike(itemId: _con.radioDetail.id, type: 'radio');
                                                if(success == true) {
                                                  _con.radioDetail.liked = !_con.radioDetail.liked;
                                                  _con.radioDetail.likeCount = _con.radioDetail.liked == true 
                                                  ? _con.radioDetail.likeCount + 1
                                                  : _con.radioDetail.likeCount - 1;
                                                }
                                                setState(() { });                
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4.0),
                                                child: Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.thumb_up,color: _con.radioDetail.liked == true ? primaryColor : Colors.grey),
                                                    Text(_con.radioDetail.likeCount.toString()), // <-- Text
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const VerticalDivider(
                                              color: activityDivider,
                                              thickness: 1,
                                            ),
                                            InkWell(
                                              splashColor:activityDivider,
                                              onTap: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  enableDrag: true,
                                                  isDismissible: false,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      height: WidgetsBinding.instance!.window.viewInsets.bottom > 0.0 
                                                      ? MediaQuery.of(context).size.height*0.96
                                                      : MediaQuery.of(context).size.height*0.6,
                                                      // height: height*1.75,
                                                      child: DraggableScrollableSheet(
                                                        maxChildSize: 1,
                                                        initialChildSize: 1,
                                                        //  minChildSize: 0.6,
                                                        builder: (_,controller){
                                                          return CommentWidget(
                                                            context,
                                                            "radio",
                                                            widget.frompage=='pn'?widget.data['module_type_id']:widget.data.id,
                                                            _con.radioDetail.commentCount,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }
                                                ).then((value) {
                                                  setState(() {
                                                    count =value;
                                                  });
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.comment,
                                                      color:primaryColor
                                                    ),
                                                    Text(
                                                      count == 0 
                                                      ? _con.radioDetail.commentCount.toString() 
                                                      : count.toString()
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 10,
                                    thickness: 2,
                                  ),
                                  SizedBox(height: height*0.5,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      child:  Player()
                    ),
                  ]
                ),
              ));  
            }
          ),
        ),
      ),
    );
  }
}
