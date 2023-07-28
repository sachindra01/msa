import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/validations.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/auth/login.dart';
import 'package:msa/widgets/loading_widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({ Key? key }) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _con = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final _txtNewPassword = TextEditingController();
  final _txtConfirmPassword = TextEditingController();
  var args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'パスワード再設定', 
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
      body: Form(
        key: _formKey,
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'パスワード',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //new password
                  TextFormField(
                    controller: _txtNewPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => Validations().password(value),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'パスワード',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: primaryColor, width: 2.0)),
                      errorStyle: const TextStyle(color: inputErrorColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'パスワードの確認',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //confirm pass3word
                  TextFormField(
                    controller: _txtConfirmPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => _txtNewPassword.text != _txtConfirmPassword.text
                                          ? '入力されたパスワードが正しくありません。'
                                          : Validations().password(value),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'パスワードの確認',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: primaryColor, width: 2.0)),
                      errorStyle: const TextStyle(color: inputErrorColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                 const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && _con.isLoading.value == false) {
                            var success = await _con.changePassword(_txtNewPassword.text, _txtConfirmPassword.text, args);
                            if(success == true) {
                              Get.off(() => const LoginPage());
                            }
                          } 
                        },
                        child: Obx(() =>
                          _con.isLoading.value == true
                            ? loadingWidget(Colors.white)
                            : const Text(
                              '変更する',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                        )
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}