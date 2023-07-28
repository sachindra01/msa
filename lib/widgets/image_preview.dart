import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({ Key? key, required this.imgUrl }) : super(key: key);
  final String imgUrl;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // insetPadding: EdgeInsets.all(10.0),
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(
              // imageProvider: NetworkImage(imgSrc[0]),
              imageProvider: NetworkImage(widget.imgUrl),
              loadingBuilder: (context, progress) =>
                  const Center(child: CircularProgressIndicator(color: primaryColor)),
              backgroundDecoration:
                  const BoxDecoration(color: Colors.white),
              customSize: MediaQuery.of(context).size,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.8,
              initialScale: PhotoViewComputedScale.contained,
              basePosition: Alignment.center
            )
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.red,
                size: 25,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.download,
          //       color: Colors.red,
          //       size: 25,
          //     ),
          //     onPressed: () {
          //       checkDownloadPermission();
          //     },
          //   ),
          // )
        ],
      )
    );
  }

  checkDownloadPermission() async {
    var status = Platform.isAndroid 
        ? await Permission.storage.status
        : await Permission.photos.status;
    if(status.isGranted) {
      _saveNetworkImage();
    } else if(status.isPermanentlyDenied) {
      showGivePermissionDialog();
    } else {
      var status = Platform.isAndroid 
        ? await Permission.storage.request()
        : await Permission.photos.request();
      if(status.isGranted) {
        _saveNetworkImage();
      } else {
        showGivePermissionDialog();
      }
    }
  }

  showGivePermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 150.0,
            child: Column(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'フォートギャラリーへのアクセスを許可する必要があります。\n※デバイスの設定画面から「写真のアクセス」を許可してください。',
                      style: TextStyle(
                        color: Colors.black
                      )
                    )
                  )
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () => Get.back(), 
                      child: const Text(
                        'はい',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.4))
                      )
                    )
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void _saveNetworkImage() async {
    Fluttertoast.showToast(
      msg: "ダウンロード中...", 
      textColor: Colors.white, 
      fontSize: 16.0,
      gravity: ToastGravity.CENTER
    );
    GallerySaver.saveImage(widget.imgUrl, albumName: 'M-SA').then((success) {
      if(success != null) {
        Fluttertoast.showToast(
          msg: success == true ? "保存しました." : '何かがうまくいかなかった', 
          textColor: Colors.white, 
          fontSize: 16.0,
          gravity: ToastGravity.CENTER
        );
      }
    });
  }
}