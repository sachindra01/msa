import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl
  (
    url,
    mode: LaunchMode.externalApplication,
  )
  ) {
    throw 'Could not launch $url';
  }
}

void openPremiumAlert(context) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return const PremiumAccountAlert();
    },
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
  );
}

class PremiumAccountAlert extends StatelessWidget {
  const PremiumAccountAlert({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String freeUserImageUrl='';
    String freeUserRedirectUrl='';
    final box = GetStorage();
    freeUserImageUrl=box.read('freeUserImage');
    freeUserRedirectUrl=box.read('freeUserRedirectUrl');
    return Scaffold(
      backgroundColor: transparent,
      body: InkWell(
        onTap: (){
          Get.back();
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius : const BorderRadius.all(Radius.circular(10.0)),
                child: GestureDetector(
                  onTap: ()async{
                    await _launchInBrowser(Uri.parse(freeUserRedirectUrl));
                  },
                  child: CachedNetworkimage(
                    imageUrl: freeUserImageUrl
                  ),
                )
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(side: BorderSide(color: black,width: 1.5),)
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close_rounded,size: 20,), onPressed: (){
                    Get.back();
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumAlertWidget extends StatefulWidget {
  const PremiumAlertWidget({Key? key}) : super(key: key);

  @override
  _PremiumAlertWidgetState createState() => _PremiumAlertWidgetState();
}

class _PremiumAlertWidgetState extends State<PremiumAlertWidget> {
  @override
  Widget build(BuildContext context) {
    var height =  MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: catTitleyColor,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: catTitleyColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: borderWrapper,
              radius: height*0.08,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset('assets/images/ic_logo.png'),
              ),
            ),
            SizedBox(
              height: height*0.02,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: catTitleyColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  side: const BorderSide(width: 2.0, color: borderWrapper)),
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/images/premium-tag.svg',
                width: 16,
              ),
              label: const Text("プレミアム"),
            ),
            SizedBox(
              height: height*0.08,
            ),
            const Text(
              ' プレミアム会員限定の製品です。\n もりもとらせどりコミュニティに\n 今すぐ登録して、続きを観よう。',
              style: TextStyle(color: primaryColor, fontSize: 20, height: 2),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: height*0.08,
            ),
            const Text(
              '  詳しくは「MSC もりもとらコミュニティ」で検索！ \n  もしくは、\n  お問い合わせフォームからご連絡ください。 ',
              style: TextStyle(color: white, fontSize: 14, height: 2),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: height*0.08,
            ),
          ],
        ),
      ),
    );
  }
}
