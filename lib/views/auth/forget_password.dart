import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/validations.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/auth/reset_password_verify.dart';
import 'package:msa/widgets/loading_widget.dart';

class ForgetPasswordPAge extends StatefulWidget {
  static const routeName = '/forget_password';
  const ForgetPasswordPAge({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPAgeState createState() => _ForgetPasswordPAgeState();
}

class _ForgetPasswordPAgeState extends State<ForgetPasswordPAge> {
  final AuthController _con = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('パスワードを忘れた方は', 
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.0
          )
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => Validations().email(value), 
                onChanged: (value) => _con.email = value,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'メールアドレス',
                  isDense: true,
                  hintStyle: const TextStyle(color: primaryColor),
                  contentPadding: const EdgeInsets.only(
                      bottom: 20.0, left: 10.0, right: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: primaryColor, width: 2.0)
                  ),
                  errorStyle: const TextStyle(color: inputErrorColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _con.isLoading.value == false) {
                      var success = await _con.resetPassword();
                      if(success == true) {
                        Get.to(() => const ResetPasswordVerify());
                      }
                    }
                  },
                  child: Obx(() => 
                    _con.isLoading.value == true
                      ? loadingWidget(Colors.white)
                      : const Text(
                        '送信する',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                  )
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'ログインは',
                  style: const TextStyle(color: Color(0XFF989d9e), fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' こちら',
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.back();
                      }
                    )
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
