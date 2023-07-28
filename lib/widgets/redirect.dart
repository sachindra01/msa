import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/widgets/music_player_widget.dart';

class RedirectedPage extends StatefulWidget {
  const RedirectedPage({Key? key}) : super(key: key);
  @override
  _RedirectedPageState createState() => _RedirectedPageState();
}

class _RedirectedPageState extends State<RedirectedPage> {
  late InAppWebViewController webView;
  String url = "";
  var box = GetStorage();
  var args = Get.arguments;
  double progress = 0;
  // ignore: unused_field
  final String _homeScreenText = "Waiting for token...";

  @override
  void initState() {
    super.initState();
    initRedirect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initRedirect() async {
    box.write('linkOpened', true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ignore: unnecessary_null_comparison
        if(webView != null) {
          if(url == args) {
            box.write('linkOpened', false);
            Get.back();
          } else {
            webView.goBack();
          }
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0Xff333333),
          leading: IconButton(
            onPressed: () async {
              box.write('linkOpened', false);
              Get.back();
            },
            icon: const Icon(
              Icons.close, 
              color: Colors.white
            )
          ),
          automaticallyImplyLeading: true,
          title: Text(url),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse(args)),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          supportZoom: false,
                          mediaPlaybackRequiresUserGesture: false,
                          transparentBackground: true
                        ),
                        android: AndroidInAppWebViewOptions(
                          useHybridComposition: true,
                          builtInZoomControls: false)
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                      },
                      onLoadStart: (controller, url) async {
                        setState(() {
                          this.url = url.toString();
                        });
                      },
                      onLoadStop: (controller, url) async {
                        setState(() {
                          this.url = url.toString();
                        });
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                    ),
                    progress < 1.0
                      ? LinearProgressIndicator(value: progress, color: primaryColor)
                      : Container(),
                    const Positioned(
                      bottom: 0,
                      child:  Player()
                    ),
                  ],
                )
              ),
            ]
          ),
        ),
      ),
    );
  }
}