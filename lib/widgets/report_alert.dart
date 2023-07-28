import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/profile/create_reportpage.dart';

class ReportAlertDialog extends StatefulWidget {
  const ReportAlertDialog({Key? key}) : super(key: key);

  @override
  State<ReportAlertDialog> createState() => _ReportAlertDialogState();
}

class _ReportAlertDialogState extends State<ReportAlertDialog> {
  final AuthController _authCon = Get.put(AuthController());
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '今月の部活レポートを\n 作成して提出しましょう！',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.to(() => const CreateReportPage());
                  },
                  child: const Text(
                    '部活レポート作成する',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: buttonPrimaryColor),
                  onPressed: () {
                    if(isChecked){
                      _authCon.notificationShiftMonth();
                    }
                    else{
                      _authCon.notificationShiftDay();
                    }
                    Get.back();
                  },
                  child: const Text(
                    'あとから',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      shape: const CircleBorder(),
                      splashRadius: 20,
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          if (isChecked) {
                            isChecked = false;
                          } else {
                            isChecked = true;
                          }
                        });
                      },
                      child: const Text("次回から表示しない"))
                ],
              ),
            
            ],
          ),
        ),
      ],
    );
  }
}
