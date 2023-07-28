import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/widgets/toast_message.dart';
import 'package:photo_view/photo_view.dart';

class AlignedImageWidget extends StatefulWidget {
  const AlignedImageWidget({Key? key,required this.userId,required this.senderId,required this.imageUrl}) : super(key: key);
  final String userId;
  final String senderId;
  final String imageUrl;

  @override
  State<AlignedImageWidget> createState() => _AlignedImageWidgetState();
}

class _AlignedImageWidgetState extends State<AlignedImageWidget> {
  RxBool imageDownloading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.userId == widget.senderId?Alignment.centerRight:Alignment.centerLeft,
      width: MediaQuery.of(context).size.width *0.4,
      child: GestureDetector(
        onTap: () async {
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => SafeArea(
              child: Container(
                color: black,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl:widget.imageUrl,
                      placeholder: (context, url) => const SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child:Center(
                          child: CircularProgressIndicator(color: primaryColor)
                        )
                      ),
                      imageBuilder: (context, imageProvider) => PhotoView(
                        imageProvider: imageProvider,
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        enableRotation: false,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fitWidth,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 34),
                        child: Material(
                          color:transparent,
                          child: InkWell(
                            onTap: (){
                              Get.back();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: Icon(Icons.close,color: white,size: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                        child: Material(
                          color:transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onTap: (){
                              if(!imageDownloading.value){
                                downloadImage(widget.imageUrl);
                              }
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Obx(()=>Center(
                                child: imageDownloading.value
                                  ?const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(color: primaryColor)
                                  )
                                  :const Icon(Icons.file_download_outlined,color: white,size: 25)
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl:widget.imageUrl,
          placeholder: (context, url) => Container(
            width: MediaQuery.of(context).size.width *0.4,
            height: MediaQuery.of(context).size.height *0.1,
            padding: const EdgeInsets.all(0.0),
            child: const CustomShimmer(),
          ),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: transparent,
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.centerLeft,
            child: Image(image: imageProvider),
          ),
          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
          fit: BoxFit.fitWidth,
          fadeOutDuration: const Duration(seconds: 1),
          fadeInDuration: const Duration(seconds: 1),
        ),
      ),
    );
  }

  downloadImage(url) async{
    try{
      setState(() {
        imageDownloading.value=true;
      });
      ImageDownloader.downloadImage(url,destination: AndroidDestinationType.directoryPictures).then((value) 
        {
          setState(() {
            imageDownloading.value=false;
          });
          showToastMessage("保存しました");
        } 
      );
    }on PlatformException catch (e){
      setState(() {
        imageDownloading.value=false;
      });
      debugPrint(e.toString());
    }
  }
}