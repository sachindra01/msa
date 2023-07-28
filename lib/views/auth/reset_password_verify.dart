import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/validations.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/auth/reset_password.dart';
import 'package:msa/widgets/loading_widget.dart';

class ResetPasswordVerify extends StatefulWidget {
  const ResetPasswordVerify({ Key? key }) : super(key: key);

  @override
  State<ResetPasswordVerify> createState() => _ResetPasswordVerifyState();
}

class _ResetPasswordVerifyState extends State<ResetPasswordVerify> {
  final AuthController _con = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '認証コードの入力', 
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
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '登録メールアドレスに認証コードを送信しました。',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12.0
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '記載された認証コードを入力してください。',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12.0
                ),
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Validations().token(value), 
                  onChanged: (value) => _con.token = value,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: '６桁のコードを入力',
                    isDense: true,
                    hintStyle: const TextStyle(color: primaryColor),
                    contentPadding: const EdgeInsets.only(
                        bottom: 20.0, left: 10.0, right: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: primaryColor, width: 2.0)),
                    errorStyle: const TextStyle(color: inputErrorColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _con.isLoading.value == false) {
                      var resp = await _con.verifyResetPassword();
                      if(resp != null) {
                        Get.off(() => const ResetPassword(), 
                          arguments: resp.data['data']['token']
                        );
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
            ]
          ),
        )
      )
    );
  }
}