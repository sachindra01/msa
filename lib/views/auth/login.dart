import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/validations.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/auth/forget_password.dart';
import 'package:msa/widgets/loading_widget.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final AuthController _con = Get.put(AuthController());
  final emailCon = TextEditingController();
  final passwordCon = TextEditingController();
  var box = GetStorage();
  late bool isChecked;

  @override
  void initState() {
    emailCon.text = box.read("loginEmail") ?? '';
    passwordCon.text = box.read("password") ?? '';
    isChecked = box.read("isChecked") ?? false;
    _con.password = passwordCon.text;
    _con.email = emailCon.text;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/msc.svg",
                        width: 92.14,
                        height: 94.03,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitHeight,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top:10.0,bottom:50.0),
                        child: Text(
                          '最高のせどり学習がここに！',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: black
                          ),
                        ),
                      ),
                      const Center(
                          child: Text(
                        'ログイン',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: buttonPrimaryColor),
                      )),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailCon,
                        onChanged: (_) => _con.email = emailCon.text,
                        autovalidateMode:  AutovalidateMode.onUserInteraction,
                        validator: (value) => Validations().email(value),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'メールアドレス',
                          hintStyle: const TextStyle(color: primaryColor),
                          contentPadding: const EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: primaryColor, width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordCon,
                        onChanged: (_) => _con.password = passwordCon.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => Validations().password(value),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'パスワード',
                          hintStyle: const TextStyle(color: primaryColor),
                          contentPadding: const EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: primaryColor, width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          const Text("ログイン情報を保持する")
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //login btn
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 50.0,
                        child: Obx(() =>
                          _con.isLoading.value == true
                            ? Center(
                              child: loadingWidget(),
                            )
                            : ElevatedButton(
                              style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _con.logIn(context,isChecked);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                              child: const Text('ログインする'),
                            ),
                        )
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'パスワードを忘れた方は',
                            style:
                                const TextStyle(color: Color(0XFF989d9e), fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' こちら',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => const ForgetPasswordPAge());
                                }
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        ' MSC会員限定アプリとなります ',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
