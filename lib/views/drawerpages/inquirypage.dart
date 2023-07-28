import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/drawerpages/inquiry_input.dart';
import 'package:msa/widgets/loading_widget.dart';

class InquiryPage extends StatefulWidget {
  static const routeName = '/inquiry';
  const InquiryPage({Key? key}) : super(key: key);

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();
  bool _validateText = true;
  final _options = ["アプリの使い方", "サービスについて", "不具合について", "退会について", "その他"];

  bool _validate = true;
  final box = GetStorage();
  final AuthController _authCon = Get.put(AuthController());
  
  // ignore: prefer_typing_uninitialized_variables
  var _currentSelectedValue;
  @override
  void initState() {
    box.read('isPremium') || box.read('memberType') == 'host' ? null : SchedulerBinding.instance!.addPostFrameCallback((_) => openCustomDialog(const PremiumAccountAlert(), context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPremium = box.read('isPremium') ?? false;
    var memberType = box.read('memberType') ?? false;
    return WillPopScope(
      onWillPop: ()async{
        return isPremium || memberType == 'host' ;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding:  EdgeInsets.only(left: isPremium || memberType=='host'  ? 0 : 30),
              child: const Text(
                "問い合わせ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            foregroundColor: black,
            backgroundColor: white,
            actions:  [
              (isPremium || memberType=='host') 
              ? const SizedBox() 
              : Obx(()=>Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: MaterialButton(
                    color: buttonPrimaryColor,
                    onPressed: (){
                      _authCon.logout();
                    },
                    child: _authCon.isLoading.value 
                          ? SizedBox(
                            height: 22,
                            width: 22,
                            child: loadingWidget(white),)
                          : const Text("ログアウト",style: TextStyle(color: white),)
                  ),
                ),
              ),)
            ],
            automaticallyImplyLeading: isPremium || memberType == 'host',
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: const [
                        Text(
                          'お問い合わせ種類',
                          style: formTitleStyle,
                        ),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: white,
                          hintStyle: const TextStyle(color: primaryColor),
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          errorText: !_validate ? '必須項目を入力してください。' : null,
                        ),
                        isEmpty: _currentSelectedValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text(
                              "選択する",
                              style: TextStyle(color: primaryColor),
                            ),
    
                            // onChanged: ((value) => {}),
                            value: _currentSelectedValue,
                            isDense: true,
                            // onChanged:(){},
                            onChanged: (newValue) {
                              setState(() {
                                _currentSelectedValue = newValue!;
                                state.didChange(newValue);
                              });
                            },
                            items: _options.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: const [
                        Text(
                          'お問い合わせ内容',
                          style: formTitleStyle,
                        ),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _text,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    // enabled: true,
                    // textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "300文字まで",
                      errorText: !_validateText ? '必須項目を入力してください。' : null,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: white,
                      hintStyle: const TextStyle(color: primaryColor),
                      errorStyle: const TextStyle(color: red, fontSize: 12),
                      contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: white,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentSelectedValue == null
                                ? _validate = false
                                : _validate = true;
                            _text.text.isEmpty
                                ? _validateText = false
                                : _validateText = true;
                          });
    
                          if (_validateText == true && _validate == true) {
                            Get.to(() => const InquiryInput(), arguments: [
                              _currentSelectedValue.toString(),
                              _text.text.toString()
                            ]);
                          }
                        },
                        style:
                            ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                        child: const Text("入力内容を確認する"),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        " アカウント作成時にご登録したメールアドレスへ事務局から返信が届きます。 また、返信が迷惑メールフォルダに届いている可能性がありますのでご注意ください。 "),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


void openCustomDialog(route,context) {
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
    final box = GetStorage();
    freeUserImageUrl=box.read('freeUserImage');
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
                child: CachedNetworkimage(
                  imageUrl: freeUserImageUrl
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
