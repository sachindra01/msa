import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

showLineRegisterPopUp(BuildContext ctx){
  showDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return const LineRegisterPopUp();
    },
    barrierDismissible: true,
    barrierLabel: '',
    context: ctx,
  );
}

class LineRegisterPopUp extends StatefulWidget {
  const LineRegisterPopUp({Key? key}) : super(key: key);

  @override
  _LineRegisterPopUpState createState() => _LineRegisterPopUpState();
}

class _LineRegisterPopUpState extends State<LineRegisterPopUp> {
  final AuthController _con = Get.put(AuthController());
  CarouselController buttonCarouselController = CarouselController();
  int currentIndex = 0;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _con.getFirstLoginMessage();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparent,
      body: InkWell(
        onTap: (){
          Get.back();
        },
        child: Obx((){
            return _con.isFirstLoginMessageLoading.value 
            ? Center(child: loadingWidget())
            : InkWell(
              onTap: (){
                Get.back();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      CarouselSlider.builder(
                        itemCount: _con.firstLoginMessage.length,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height-40,
                          enlargeCenterPage :false,
                          padEnds: false,
                          enableInfiniteScroll :false,
                          disableCenter : false,
                          onPageChanged:(index,r){
                            setState(() {
                              currentIndex=index;
                            });
                          }
                        ),
                        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex)
                        {  
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                child: GestureDetector(
                                  onTap: ()async{
                                    await _launchInBrowser(Uri.parse(_con.firstLoginMessage[itemIndex].link));
                                  },
                                  child: Image.network(
                                    _con.firstLoginMessage[itemIndex].image, 
                                    fit: BoxFit.fitWidth,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                      Positioned(
                        bottom: 20,
                        child: AnimatedSmoothIndicator(
                          count: _con.firstLoginMessage.length,
                          activeIndex: currentIndex,
                          effect: const JumpingDotEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            dotColor: black,
                            activeDotColor: buttonDisableColor
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 22,
                              width: 22,
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(side: BorderSide(color: white,width: 1.5))
                              ),
                              child: const Icon(Icons.close_rounded,size: 20,color: white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}