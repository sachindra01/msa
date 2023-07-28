import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/webview_controller.dart';
import 'package:msa/widgets/comment_widget.dart';
import 'package:msa/widgets/image_preview.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/music_player_widget.dart';
import 'package:msa/widgets/redirect.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:msa/common/constants.dart' as cons;
import 'package:url_launcher/url_launcher_string.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({Key? key,this.data}) : super(key: key);
  final dynamic data;

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final WebViewController _con = Get.put(WebViewController());
  // final WebViewController _con = Get.find();
  final GlobalKey webViewKey = GlobalKey();
  var data = Get.arguments;
  dynamic args;
  InAppWebViewController? webViewController;
  double progress = 0;
  late String url = cons.getBaseurl();
  final box = GetStorage();
  bool screenOnHold = false;

  

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      transparentBackground: true
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    )
  );

  @override
  void initState() {
    args = data?? widget.data;
    // print(url);
    if(args[1] != 'TAC' && args[1] != "PP") {
      _con.getDetail(args);
    }
    box.write('linkOpened', false);
    getRoute();
    super.initState();
  }

  getRoute() {
    var token = box.read('apiToken');
    String urlNow = args[1] == 'TAC' 
      ? url+'auth/terms-and-condition'
      : args[1] == "PP" 
        ? url+'auth/privacy-policy'
          : url+args[1]+'/detail/${args[0]}/'+token;
    setState(() {
      url = urlNow;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: GetBuilder(
          init: WebViewController(),
          builder: (_) {
            return Obx(() =>
              _con.isLoading.value == true
                ? Center(child: loadingWidget())
                : _con.detail == null && args[1] != "TAC" && args[1] != "PP" && args[1] != "news"
                  ? const SizedBox()
                  : detailBody()
            );
          } 
        )
      ),
      floatingActionButton: Obx(() =>
        _con.isLoading.value == true
          ? const SizedBox() 
          : args[1] != 'TAC' && args[1] != "PP" && args[1] != "news" && screenOnHold == false
            ? Column(
              mainAxisAlignment: MainAxisAlignment.end, 
              children: [
                args[1] == 'article'
                  ? favoriteButton()
                  : const SizedBox(),
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
                      ? height*0.98 
                      : height*0.7,
                      // height: height*1.75,
                      child: DraggableScrollableSheet(
                        maxChildSize: 1,
                        initialChildSize: 1,
                        
                        //  minChildSize: 0.6,
                        builder: (_,controller){
                        return CommentWidget(
                          context, 
                          args[1], 
                          args[0] is int ? args[0] : int.parse(args[0]), 
                          _con.detail.commentCount
                        );
                        },
                      ),
                    );
                    });
                  },
                  heroTag: null,
                )
              ]
                
            )
            : const SizedBox()
      )
    );
  }

  detailBody() {
    String baseurl = cons.getBaseurl();
    String vimeourl = cons.getVimeoUrl();
    String youtubeurl = cons.getYoutubeUrl();
    String appstoreurl = cons.getAppstoreUrl();
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            setState(() => screenOnHold = true );
          },
          onLongPressUp: () {
            setState(() => screenOnHold = false );
          },
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
              url: Uri.parse(url)
            ),
            initialOptions: options,
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
              webViewController!.addJavaScriptHandler(
                handlerName: "BLOG_PREVIOUS_NEXT",
                callback: (arguments) async {
                  blogRoute(arguments[0]);
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
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var url = navigationAction.request.url.toString();
              var uri = navigationAction.request.url;

              if (["tel"].contains(uri!.scheme)) {
            
                if (await canLaunchUrlString(url)) {
               
                  await launchUrlString(url);
                  return NavigationActionPolicy.CANCEL;
                }
              } else if (url.contains('itms-appss://')) {
                if (Platform.isIOS) {
               
                  if (await canLaunchUrlString(url)) {
                 
                    await launchUrlString(url);
                  }
                } else {
                  navigatetoExternalUrl(url);
                }
                return NavigationActionPolicy.CANCEL;
              } else if (url.contains('play.google.com')) {
                if (Platform.isAndroid) {
                
                  if (await canLaunchUrlString(url)) {
             
                    await launchUrlString(url);
                    return NavigationActionPolicy.CANCEL;
                  }
                } else {
               
                  if (await canLaunchUrlString(url)) {
               
                    await launchUrlString(
                      url,
                      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),

                      // forceSafariVC: true,
                      // forceWebView: true,
                      // enableJavaScript: true,
                    );
                  } else {
                    throw 'Could not launch $url';
                  }
                }
                return NavigationActionPolicy.CANCEL;
              } else if ((["about"].contains(uri.scheme))) {
              } else if (url.contains(appstoreurl)) {
                if (Platform.isAndroid) {
                  navigatetoExternalUrl(url);
                }
              } else if (!url.contains(baseurl) &&
                  !url.contains(vimeourl) &&
                  !url.contains(youtubeurl) &&
                  !url.contains(appstoreurl)) {
                if (["https"].contains(uri.scheme) || ["http"].contains(uri.scheme)) {
               
                  if (await canLaunchUrlString(url)) {
     
                    await launchUrlString(
                      url,
                      webViewConfiguration: const WebViewConfiguration(
                        enableDomStorage: true,
                        enableJavaScript: true
                      ),
                      // forceSafariVC: true,
                      // forceWebView: true,
                      // enableJavaScript: true,
                    );
                  } else {
                    throw 'Could not launch $url';
                  }
                  return NavigationActionPolicy.CANCEL;
                }
              } else {}
              return NavigationActionPolicy.ALLOW;
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
              // if (progress == 100) {
                // pullToRefreshController.endRefreshing();
              // }
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
        ),
        progress < 1.0
          ? // LinearProgressIndicator(value: progress, color: primaryColor)
            Center(
              child: loadingWidget()
            )
          : const SizedBox(),
        const Positioned(
          bottom: 0,
          child:  Player()
        ),
      ],
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      backgroundColor: _con.detailFavorite == true ? const Color(0xFF26a69a) : Colors.white,
      onPressed: () async {
        bool isFav = _con.detailFavorite == true ? false : true;
        var success = await _con.setFavorite(args, isFav,);
        if(success == true) {
          setState(() {
            _con.detailFavorite = isFav;
          });
        }
      },
      child: Icon(
        Icons.favorite,
        color: _con.detailFavorite == true ? Colors.white : Colors.grey,
      ),
    );
  }

  likeButton() {
    return FloatingActionButton(
      backgroundColor: _con.detailLiked == true ? primaryColor : Colors.white,
      onPressed: () async {
        _con.likeUnlike(args);
        setState(() {
          if (_con.detailLiked == true) {
            _con.detailLiked = false;
          } else {
            _con.detailLiked = true;
          }
        });
      },
      child: Icon(
        Icons.thumb_up,
        color: _con.detailLiked == true ? Colors.white : Colors.grey,
      ),
    );
  }

  imagePreview(imgSrc) {
    showDialog(
      context: context,
      builder: (context) => ImagePreview(imgUrl: imgSrc[0])
    );
  }

  blogRoute(arguments) {
    if(arguments == 'PREV') {
      Get.off(() => const WebviewPage(),
        arguments: [_con.detail.prevBlog, args[1]],
        preventDuplicates: false
      );
    } else {
      Get.off(() => const WebviewPage(),
        arguments: [_con.detail.nextBlog, args[1]],
        preventDuplicates: false
      );
    }
  }

  navigatetoExternalUrl(url) async {
    bool linkOpened = box.read('linkOpened');
    if (linkOpened == false) {
      box.write('linkOpened', true);
      Get.to(() => const RedirectedPage(),
        arguments: url
      );
    }
    return NavigationActionPolicy.CANCEL;
  }

}
