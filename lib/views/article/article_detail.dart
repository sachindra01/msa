import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/constants.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/articletop_controller.dart';
import 'package:msa/controller/like_unlike_favorite_controller.dart';
// import 'package:msa/flavor_setup/app_config.dart';
import 'package:msa/widgets/comment_widget.dart';
import 'package:msa/widgets/image_preview.dart';
import 'package:msa/widgets/loading_widget.dart';

class ArticleWebPage extends StatefulWidget {
  static const routeName = '/article_detail';

  const ArticleWebPage({Key? key}) : super(key: key);

  @override
  State<ArticleWebPage> createState() => _ArticleWebPageState();
}

class _ArticleWebPageState extends State<ArticleWebPage> {
  final ArticleTopController _con = Get.put(ArticleTopController());
  final LikeUnlikeFavController _activityCon = Get.put(LikeUnlikeFavController());
  final GlobalKey webViewKey = GlobalKey();
  var args = Get.arguments;
  InAppWebViewController? webViewController;
  double progress = 0;
  late String url = getBaseurl()+'#/article/detail';
  final box = GetStorage();

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: white,
        body: SafeArea(
          child: GetBuilder(
            init: ArticleTopController(),
            builder: (_) {
              return Obx(() =>
                _con.isDetailLoading.value == true
                  ? Center(child: loadingWidget())
                  : articleDetailBody()
              );
            } 
          )
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          favoriteButton(),
          const SizedBox(
            height: 10,
          ),
          likeButton(),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: primaryColor,
            child: const Icon(Icons.comment),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                    context: context,
                    enableDrag: true,
                    isDismissible: false,
                    builder: (context) {
                    return SizedBox(
                      height: WidgetsBinding.instance!.window.viewInsets.bottom > 0.0 
                      ? height*1.75 
                      : height*1.3,
                      // height: height*1.75,
                      child: DraggableScrollableSheet(
                        maxChildSize: 1,
                        initialChildSize: 1,
                        
                        //  minChildSize: 0.6,
                        builder: (_,controller){
                            return CommentWidget(context, "blog", _con.blogDetail.id, _con.blogDetail.commentCount);
                        },
                      ),
                    );
                    });
            },
           
            heroTag: null,
          )
        ]));
  }

  articleDetailBody() {
    var token = box.read('apiToken');
    return Stack(
      children: [
        InAppWebView(
          key: webViewKey,
          // contextMenu: contextMenu,
          initialUrlRequest:
          URLRequest(url: Uri.parse(url + '/$args/$token')),
          // initialFile: "assets/index.html",
          initialOptions: options,
          // pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
            webViewController!.addJavaScriptHandler(
            handlerName: "IMAGE_PREVIEW",
            callback: (arguments) async {
              imagePreview(arguments);
            });
            webViewController!.addJavaScriptHandler(
              handlerName: "CLOSE_WEBVIEW",
              callback: (arguments) async {
                Get.back();
              }
            );
          },
          onLoadStart: (controller, url) {
            setState(() {
              this.url = url.toString();
            });
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          onLoadStop: (controller, url) async {
            // pullToRefreshController.endRefreshing();
            setState(() {
              this.url = url.toString();
            });
            debugPrint('URL => ${this.url}');
          },
          onLoadError: (controller, url, code, message) {
            // pullToRefreshController.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              // pullToRefreshController.endRefreshing();
            }
            setState(() {
              this.progress = progress / 100;
            });
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            setState(() {
              this.url = url.toString();
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint(consoleMessage.toString());
          },
        ),
        progress < 1.0
            ? LinearProgressIndicator(value: progress)
            : Container()
      ],
    );
  }

  likeButton() {
    return FloatingActionButton(
      backgroundColor: _con.blogDetailLiked == true ? primaryColor : Colors.white,
      onPressed: () async {
        var success = await _activityCon.likeUnlike( itemId: args, type: 'blog');
        if(success == true) {
          setState(() {
            if (_con.blogDetailLiked == true) {
              _con.blogDetailLiked = false;
            } else {
              _con.blogDetailLiked = true;
            }
          });
        }
      },
      child: Icon(
        Icons.thumb_up,
        color: _con.blogDetailLiked == true ? Colors.white : Colors.grey,
      ),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      backgroundColor: _con.blogDetailFavorite == true ? primaryColor : Colors.white,
      onPressed: () async {
        bool isFav = _con.blogDetailFavorite == true ? false : true;
        var success = await _activityCon.favorite(args, isFav);
        if(success == true) {
          setState(() {
            _con.blogDetailFavorite = isFav;
          });
        }
      },
      child: Icon(
        Icons.favorite,
        color: _con.blogDetailFavorite == true ? Colors.white : Colors.grey,
      ),
    );
  }

  imagePreview(imgSrc) {
    showDialog(
      context: context,
      builder: (context) => ImagePreview(imgUrl: imgSrc[0])
    );
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    )
  );

}
