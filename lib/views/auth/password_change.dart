import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/common/validations.dart';
import 'package:msa/controller/auth_controller.dart';


class PasswordChangeAlert extends StatefulWidget {
  const PasswordChangeAlert({ Key? key }) : super(key: key);

  @override
  State<PasswordChangeAlert> createState() => _PasswordChangeAlertState();
}

class _PasswordChangeAlertState extends State<PasswordChangeAlert> {
  final _authCon = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();


  final _txtCurrentPassword = TextEditingController();
  final _txtNewPassword = TextEditingController();
  final _txtConfirmPassword = TextEditingController();

   bool validateNew = true;
   bool validateCurrent = true;
   bool validateConfirm = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '現在のパスワード',
                  style: TextStyle(fontSize: 14, ),
                ),
                const SizedBox(
                  height: 10,
                ),
    
                //current password
                TextFormField(
                  controller: _txtCurrentPassword,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  autovalidateMode:  AutovalidateMode.onUserInteraction,
                  validator: (value) => 
                   Validations().password(value),
                
                  decoration: InputDecoration(
                    errorText: validateCurrent ? null : "現在のパスワードをご入力ください",
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value){
                    setState(() {
                      _txtCurrentPassword.text == '' ? validateCurrent = false : validateCurrent = true;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '新しいパスワード',
                  style: TextStyle(fontSize: 14,),
                ),
                const SizedBox(
                  height: 10,
                ),
    
                //new password
                TextFormField(
                  controller: _txtNewPassword,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  autovalidateMode:  AutovalidateMode.onUserInteraction,
                   validator: (value) => Validations().password(value),
                  decoration: InputDecoration(
                    errorText: validateNew ? null : "新しいパスワードをご入力ください",
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value){
                    setState(() {
                      _txtNewPassword.text == '' ? validateNew = false : validateNew = true;
                    });
    
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '新しいパスワード（確認）',
                  style: TextStyle(fontSize: 14, ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //confirm pass3word
                TextFormField(
                  controller: _txtConfirmPassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  
                  decoration: InputDecoration(
                    errorText:  validateConfirm ?null: "パスワードが異なります",
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value){
                    if(_txtNewPassword.text != "" && _txtConfirmPassword.text != ""){
                      setState(() {
                        _txtNewPassword.text == _txtConfirmPassword.text ? validateConfirm = true : validateConfirm = false;
                      });
                    }
                  },
                ),
               const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if(validateCurrent == true && validateNew == true && validateConfirm == true){
                        if (_formKey.currentState!.validate()) {
                          _authCon.updatePassword(_txtCurrentPassword.text, _txtNewPassword.text, _txtConfirmPassword.text);
                        }
                      }
                    },
                    child: const Text(
                      '変更する',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    );
  }
}