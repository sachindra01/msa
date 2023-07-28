import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
import 'package:msa/controller/product_list_controller.dart';
import 'package:msa/widgets/comment_widget.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/music_player_widget.dart';
import 'package:msa/widgets/showpremiumalert.dart';
import 'package:pip_flutter/pipflutter_player.dart';
import 'package:pip_flutter/pipflutter_player_configuration.dart';
import 'package:pip_flutter/pipflutter_player_controller.dart';
import 'package:pip_flutter/pipflutter_player_controls_configuration.dart';
import 'package:pip_flutter/pipflutter_player_data_source.dart';
import 'package:pip_flutter/pipflutter_player_data_source_type.dart';
// import 'package:video_player/video_player.dart';
// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
 import 'dart:math' as math;

// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
 

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie/detail';
  const MovieDetailPage({Key? key}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> with WidgetsBindingObserver {
  final ProductListController _con = Get.put(ProductListController());
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  late PipFlutterPlayerController pipFlutterPlayerController ;
  final GlobalKey pipFlutterPlayerKey = GlobalKey();


  var box = GetStorage();
  late double height = 210;
  var count = 0;
  var args = Get.arguments;
  var currentVideoID = '0';
  bool isInPip = false;

  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  @override
  void initState() {
     _con.getMovieDetail(args[0]);
    currentVideoID = args[1];
     
    
    initVideo();
    super.initState();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance?.removeObserver(this);
    _con.videoUrl.clear();
   
    pipFlutterPlayerController.dispose();
    
    super.dispose();
  }

  initVideo() async{
    
    pipFlutterPlayerController = PipFlutterPlayerController(
      const PipFlutterPlayerConfiguration(
        //aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        fullScreenByDefault: false,
        controlsConfiguration: PipFlutterPlayerControlsConfiguration(
          enableAudioTracks: false,
          enableSkips: false,
          enableRetry: false,
          enablePip: true,
          enableSubtitles: false, 
        )
      ),
    );
    await _con.getVideoUrl(currentVideoID);
    if(_con.hasVideo){
      PipFlutterPlayerDataSource dataSource = PipFlutterPlayerDataSource(
      PipFlutterPlayerDataSourceType.network,
      _con.videoUrl["720p"],
      resolutions: {
        "1080"  : _con.videoUrl["1080p"],
        "720" : _con.videoUrl["720p"],
        "540" : _con.videoUrl["540p"],
        "360" : _con.videoUrl["360p"], 
      }, 
    );
    pipFlutterPlayerController.setupDataSource(dataSource);
    pipFlutterPlayerController.setPipFlutterPlayerGlobalKey(pipFlutterPlayerKey);
    }


      // WidgetsBinding.instance?.addObserver(this);
    // await _con.getMovieDetail(args[0]);
    
    // _con.getVideoUrl(_con.videoId).then((_){
    //   PipFlutterPlayerDataSource dataSource = PipFlutterPlayerDataSource(
    //   PipFlutterPlayerDataSourceType.network,
    //   _con.videoUrl[0],
    //   resolutions: {
    //     "auto" : _con.videoUrl[1],
    //     "360p" : _con.videoUrl[2],
    //     "720p"  : _con.videoUrl[3],
    //   },
    // );
    //   pipFlutterPlayerController.setupDataSource(dataSource);
    //   pipFlutterPlayerController.setPipFlutterPlayerGlobalKey(pipFlutterPlayerKey);
      
    // });
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Obx(() =>
          Text(
            _con.catName.value,
            style: const TextStyle(fontSize: 16.0),
          )
        ),
      ),
      body: GetBuilder(
        init: ProductListController(),
        builder: (_) {
          return Obx(() => 
            _con.isDetailLoading.value == true
              ? Center(child: loadingWidget())
              : _con.movieDetail == null
                ? const SizedBox()
                : movieDetailBody()
          );
        }
      )
    );
  }

  movieDetailBody() {
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Obx(() =>
                _con.movieChange.value == true
                ? Container(
                  color: black,
                  child: Center(
                    child: loadingWidget(),
                  ),
                )
                : _con.hasVideo
                  ? PipFlutterPlayer(
                  controller: pipFlutterPlayerController,
                  key: pipFlutterPlayerKey,
                )
                : Container(
                  color: black,
                  child: const Center(child: Text("申し訳ありませんが、ビデオはありません",style: TextStyle(color: white,fontSize: 16),),),
                ),
                // : const VimeoPlayer(
                //   videoId: '595837265',
                // ),
              )
            ),
            // InkWell(onTap: (){
            //   pipFlutterPlayerController
            //             .enablePictureInPicture(pipFlutterPlayerKey);
            // },
            // child: const Text("Pip View"),),
            Expanded(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              //Expanded Details
                              ExpandablePanel(
                                theme: const ExpandableThemeData(
                                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                                  tapBodyToCollapse: true,
                                  expandIcon: Icons.arrow_drop_down,
                                  collapseIcon: Icons.arrow_drop_up,
                                  iconColor: Colors.black,
                                  iconSize: 28.0,
                                  iconRotationAngle: math.pi / 2,
                                  iconPadding: EdgeInsets.only(right: 5),
                                  hasIcon: true,
                                ),
                                header: Text(
                                  _con.movieDetail.productTitle,
                                  style: catTitleStyle,
                                ),
                                collapsed: const Text(
                                  '',
                                  softWrap: true,
                                  maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                                expanded: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child:
                                    Html(data: _con.movieDetail.description1),
                                  )
                                ),
                              ),
                              // Activity Icons
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        splashColor: activityDivider,
                                        onTap: () async {
                                          var success = await _activityCon.likeUnlike(type: 'product', itemId: args[0]);
                                          if(success == true) {
                                            _con.movieDetail.liked = !_con.movieDetail.liked;
                                            _con.movieDetail.likeCount = _con.movieDetail.liked == true 
                                              ? _con.movieDetail.likeCount + 1
                                              : _con.movieDetail.likeCount - 1;
                                          }
                                          setState(() { });
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: _con.movieDetail.liked == true ? primaryColor : transparent,
                                              child: Icon(
                                                _con.movieDetail.liked ? Icons.thumb_up_alt : Icons.thumb_up_off_alt_outlined,
                                                color: _con.movieDetail.liked == true ? white : grey,
                                                size: 18,
                                              ),
                                            ),
                                            const Text(""),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      color: activityDivider,
                                      thickness: 1,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        splashColor: activityDivider,
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
                                                              "product",
                                                              _con.movieDetail.id,
                                                              _con.movieDetail.commentCount,
                                                            );
                                                        },
                                                      ),
                                                    );
                                                    }).then((value) {
                                              setState(() {
                                                count = value;
                                              });
                                            });
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             CircleAvatar(
                                              radius: 16,
                                              backgroundColor: transparent,
                                              child: SvgPicture.asset('assets/icons/commentIcon.svg'),
                                            ),
                                            Text(count == 0 
                                            ? _con.movieDetail.commentCount.toString() 
                                            : count.toString())
                                            // <-- Text
                                          ],
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      color: activityDivider,
                                      thickness: 1,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        splashColor: activityDivider,
                                        onTap: () async {
                                          
                                          bool isOnPLaylist = !_con.movieDetail.isOnPlaylist;
                                          var success = await _con.updateMovieDetail(_con.movieDetail.id, 'playlist', isOnPLaylist);
                                          if(success == true) {
                                          //  initState();
                                             //initVideo();
                                            _con.movieDetail.isOnPlaylist = isOnPLaylist;
                                            for(int i = 0; i < _con.playlist.length; i++) {
                                              if(_con.playlist[i].id == args[0]) {
                                                _con.playlist[i].isOnPlaylist = isOnPLaylist;
                                              }
                                            }
                                          } 
                                          setState(() { 
                                            
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                               backgroundColor: _con.movieDetail.isOnPlaylist == true ? primaryColor : transparent,
                                               radius: 15,
                                              child: Icon(
                                               _con.movieDetail.isOnPlaylist? Icons.favorite : Icons.favorite_outline_sharp,
                                                color: _con.movieDetail.isOnPlaylist == true ? white : grey,
                                                size: 18,
                                              ),
                                            ),
                                            const Text("お気に入り"), // <-- Text
                                          ],
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      color: activityDivider,
                                      thickness: 1,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                            bool isChecked = !_con.movieDetail.isChecked;
                                            var success = await _con.updateMovieDetail(_con.movieDetail.id, 'isChecked', isChecked);
                                            if(success == true) {
                                              _con.movieDetail.isChecked = isChecked;
                                              for(int i = 0; i < _con.playlist.length; i++) {
                                                if(_con.playlist[i].id == args[0]) {
                                                  _con.playlist[i].isChecked = isChecked;
                                                }
                                              }
                                          } 
                                          setState(() { });
                                        },
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundColor: _con.movieDetail.isChecked == true ? primaryColor : transparent,
                                                child: Icon(
                                                   Icons.check ,
                                                  color:  _con.movieDetail.isChecked ? white : grey,
                                                 size: 18,
                                                ),
                                              ),
                                              Text(_con.movieDetail.isChecked ? "受講済" : "未受講"), // <-- Text
                                            ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            child: Text(
                              _con.movieDetail.categoryName,
                              style: catTitleStyle,
                            ),
                          ),
                          //Recommended video list
                          recommendedVideoList(width)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
          const Positioned(
            bottom: 0,
            child:  Player()
          ),
      ],
    );
  }

  recommendedVideoList(width) {
    var premiumAcc = box.read('isPremium');
    return SizedBox(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _con.playlist.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              _con.movieChange.value = true;
              currentVideoID = _con.playlist[index].movieCode;
              if (premiumAcc == true || _con.playlist[index].isPremium == false) {
                // Get.off(() => const MovieDetailPage(),
                //     arguments: _con.playlist[index].id,
                //     preventDuplicates: false);
                
                await initVideo();
                _con.getMovieDetail(_con.playlist[index].id, false).then((value) {
                  setState(() { 
                    args[0] =  _con.playlist[index].id;
                    count = _con.comment.length;
                  });
                });
              } else {
                  showPremiumAlert(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 5,top: 5),
              color: _con.playlist[index].id == args[0] ? Colors.grey[200] : Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkimage(
                              height: height*0.30,
                              imageUrl: _con.playlist[index].profileImage,
                              width: width*0.30, 
                            ),
                          ),
                        ),
                      ),
                      //Premium tag
                      _con.playlist[index].isPremium
                        ? const SizedBox()
                        : Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                // color: Colors.black,
                                width: 18,
                                height: 18,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: black,
                                    border: Border.all(
                                      color: Colors.yellow,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: SvgPicture.asset(
                                  'assets/images/premium-tag.svg',
                                  width: 10,
                                ),
                              ),
                            ),
                          ),
                        )
                        
                    ]
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(minHeight: 40),
                        width: width * 0.46,
                        child: Text(
                          _con.playlist[index].productTitle,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14, 
                            color: catTitleyColor, 
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(5))
                              ),
                              width: 40,
                              height: 16,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                  Text(
                                    _con.playlist[index].movieDuration,
                                    style: movieCountTextStyle,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: InkWell(
                                onTap: () async {
                                  var product = _con.playlist[index];
                                  var success = await _activityCon.updateIsOnPlaylist([product.id,'article'], product.isOnPlaylist);
                                  if(success) {
                                    setState(() {
                                      product.isOnPlaylist = !product.isOnPlaylist;
                                      if(_con.playlist[index].id == args[0]) {
                                        _con.movieDetail.isOnPlaylist = product.isOnPlaylist;
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: _con.playlist[index].isOnPlaylist
                                          ? primaryColor
                                          : grey,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                                  width: 80,
                                  height: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                       Text(
                                        "お気に入り",
                                        style: movieCountTextStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                   Padding(
                     padding: const EdgeInsets.only(right: 0),
                     child: InkWell(
                        onTap: () async {
                          bool isChecked = !_con.playlist[index].isChecked;
                          var success = await _con.updateMovieDetail(_con.playlist[index].id, 'isChecked', isChecked);
                          if(success == true) {
                            _con.playlist[index].isChecked = isChecked;
                            if(_con.playlist[index].id == args[0]) {
                              _con.movieDetail.isChecked = isChecked;
                            }
                          } 
                          setState(() { });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: _con.playlist[index].isChecked == true ? primaryColor : grey,
                            child: const Icon(
                             Icons.check ,
                              color: white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
