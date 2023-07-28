import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/auth/login.dart';
import 'package:msa/views/home/music_page_manager.dart';
import 'package:msa/widgets/toast_message.dart';


class LogoutAlertDialog extends StatefulWidget {
  const LogoutAlertDialog({Key? key}) : super(key: key);

  @override
  State<LogoutAlertDialog> createState() => _LogoutAlertDialogState();
}

class _LogoutAlertDialogState extends State<LogoutAlertDialog> {
  
  final AuthController _authCon = Get.put(AuthController());

  final PageManagerController _pageCon = Get.find();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
         width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ログアウトしますか。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width/5, 
                      maxWidth: MediaQuery.of(context).size.width/4,
                    ),
                    width: MediaQuery.of(context).size.width/5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: lightgrey,elevation: 1),
                      onPressed: () async {
                        showToastMessage('ログアウト');
                        _pageCon.audioPlayer.stop();
                        var success = await _authCon.logout();
                        if(success == true) {
                          Get.off(() => const LoginPage());
                          Get.delete<AuthController>();
                        }
                      },
                      child: const Text(
                        'はい',
                        maxLines: 1,
                        style: TextStyle(color: black,fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 20,
                  ),
                  Container(
                    height: 30,
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width/5, 
                      maxWidth: MediaQuery.of(context).size.width/4,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: white,elevation: 0.3),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'いいえ',
                        maxLines: 1,
                        style: TextStyle(color: black,fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
