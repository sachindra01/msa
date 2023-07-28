// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:msa/common/age_calculator.dart';
import 'package:msa/common/validations.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/controller/prefecturelist_controller.dart';
import 'package:msa/views/auth/password_change.dart';
import 'package:msa/widgets/custom_switch.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:msa/widgets/steps_widget.dart';
import 'package:msa/widgets/toast_message.dart';
import '../../common/styles.dart';

class FirstLogInEdit extends StatefulWidget {
  const FirstLogInEdit({ Key? key }) : super(key: key);

  @override
  State<FirstLogInEdit> createState() => _FirstLogInEditState();
}

enum gender { male, female, other }

class _FirstLogInEditState extends State<FirstLogInEdit> {
  final PrefectureController _prefCon = Get.put(PrefectureController());
  final AuthController _con = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final _txtFirstName = TextEditingController();
  final _txtkanaFirstName = TextEditingController();
  final _txtPhoneCon = TextEditingController();
  final _txtlineCon = TextEditingController();
  late gender? _gen = gender.male;
  bool isCheckedAge = false;
  bool isCheckedPre = false;
  bool isSwitched = false;
  
  var _currentSelectedDate;
  final _age = "".obs;
  var _currentSelectedPrefecture;
  // var _currentSelectedJob;

  @override
  void initState() {
    _con.getUserInfo();
    Future.delayed(
      const Duration(seconds: 1), (() => 
        getInitialData()
      )
    );
    super.initState();
  }

  getInitialData() async {
    var profile = await _con.getUserInfo();
    await _prefCon.getPrefectureList();
    await _prefCon.getOccupationList();
    if(profile != null) {
      _txtFirstName.text = profile.firstName ?? '';
      _txtkanaFirstName.text = profile.kanaFirstName ?? '';
      _txtPhoneCon.text = profile.phoneNo1 ?? '';
      _con.phone = profile.phoneNo1 ?? '';
      _con.gender = gender.male.name;
      _txtlineCon.text = profile.lineId ?? '';
      isCheckedAge = profile.showAge ?? false;
      _gen = gender.values.byName(profile.gender);
      isCheckedPre = profile.status;
      // _currentSelectedJob = profile.occupation == "" ? '経営者・役員' :profile.occupation;
      _currentSelectedPrefecture = profile.prefecture == "" ? '北海道' : profile.prefecture;
      
      isSwitched = profile.notificationStatus ?? false;
      _currentSelectedDate = profile.dobYear == "" ? (DateTime.now().year - 13).toString() : profile.dobYear;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: pagesAppbar,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: black, //change your color here
        ),
        title: const Text(
          'アカウント基本情報',
          style: TextStyle(color: black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: GetBuilder(
            init: PrefectureController(),
            builder: (_) {
              return Obx(() =>
                _con.isLoading.value == true || _con.profileInfo==null
                ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: loadingWidget()
                  )
                )
                : formBody()
              );
            }
          ),
        )
      ),
    );
  }
  
  formBody() {
    var profile = _con.profileInfo.data;
    var now = DateTime.now();
    int date = now.year;
    List year = [];
    for (int i = 1950; i <= date - 13; i++) {
      year.add(i.toString());
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const StepWidget(),
          //FullName
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  '氏名 (全角)',
                  style: formTitleStyle,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: formRequirdText,
                ),
              ],
            ),
          ),
          TextFormField(
            controller: _txtFirstName,
            keyboardType: TextInputType.text,
            autovalidateMode:  AutovalidateMode.onUserInteraction,
            validator: (value) => Validations().isWhiteSpace(value),
            textInputAction: TextInputAction.next,
            onChanged: (value) {
                _con.firstName = _txtFirstName.text;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: white,
              hintText: '瀬取 慎吾',
              hintStyle: TextStyle(color: primaryColor),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
          //KATAKANA NAME
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  '氏名 (カタカナ)',
                  style: formTitleStyle,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: formRequirdText,
                ),
              ],
            ),
          ),
          TextFormField(
            controller: _txtkanaFirstName,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => Validations().isWhiteSpace(value),
            onChanged: (value) {
               _con.kanaFirstName = _txtkanaFirstName.text;
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: white,
              hintText: 'セドリ シンゴ',
              hintStyle: TextStyle(color: primaryColor),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
          //BIRTH YEAR
          SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Text('生まれた年',
                              style: formTitleStyle,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                              decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: formRequirdText,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: white,
                                hintStyle: const TextStyle(
                                  color: primaryColor
                                ),
                                contentPadding : const EdgeInsets.only(
                                  left: 10,
                                  right: 10
                                ),
                                errorText: _con.profileInfo.data.dobYear == '' || _con.profileInfo.data.dobYear == null ? '必須項目を入力してください。' : null,
                              ),
                              isEmpty: _currentSelectedDate == profile.dobYear,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedDate, 
                                    // ?? profile.dobYear.toString() 
                                    //   ??'0',
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _currentSelectedDate = newValue!;
                                      _age.value = (date - int.parse(_currentSelectedDate)).toString().substring(0,1) + "0代";
                                      profile.dobYear = _currentSelectedDate;
                                      _con.dobYear = _currentSelectedDate;
                                      state.didChange( newValue);
                                    });
                                  },
                                  items: year.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value+'年'),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: const [
                            Text(
                              '年代',
                              style: formTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: white,
                        padding: const EdgeInsets.all(15),
                        child: Obx(
                          (() => 
                            Text(
                              _age.value == ""
                                ? ageCalculator((date - int.parse(profile.dobYear ??'0')).toString())+"代"
                                : _age.value
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: const [
                            Text(
                              '公開',
                              style: formTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: white,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Row(
                            children: [
                              Checkbox(
                                shape: const CircleBorder(),
                                splashRadius: 10,
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: isCheckedAge,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedAge = value!;
                                    _con.ageDisclose = value;
                                  });
                                },
                              ),
                              Expanded(
                                child: Container()
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //PREFECTURES
          SizedBox(
            height: _currentSelectedPrefecture == null || _currentSelectedPrefecture == ''?120:100,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Text( 
                              '都道府県',
                              style: formTitleStyle,
                            ),
                            const SizedBox(width: 10.0),
                            Container( 
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: formRequirdText,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FormField<String>(
                          builder: (FormFieldState<String>state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: white,
                                hintStyle: const TextStyle(
                                  color: primaryColor
                                ),
                                contentPadding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: 10
                                ),
                                errorText: _currentSelectedPrefecture == null || _currentSelectedPrefecture == '' ? '必須項目を入力してください。' : null,
                              ),
                              isEmpty: _currentSelectedPrefecture == null,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: const Text(
                                    "選択する",
                                    style: TextStyle(
                                      color: primaryColor
                                    ),
                                  ),
                                  isExpanded: true,
                                  value: _currentSelectedPrefecture,
                                  isDense: true,
                                  items:_prefCon.prefectureList.map( (String value) {
                                    return DropdownMenuItem<String>(
                                      
                                      value: value,
                                      child: Text(
                                        value,
                                        maxLines: 1,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged:(newValue) {
                                    setState(() {
                                      _currentSelectedPrefecture = newValue;
                                      _con.prefecture = (_prefCon.prefectureList.indexOf(newValue!)+1).toString();
                                      state.didChange(newValue);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: const [
                            Text('公開',
                              style: formTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: white,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Row(
                            children: [
                              Checkbox(
                                shape:const CircleBorder(),
                                splashRadius: 10,
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: isCheckedPre,
                                onChanged:(bool? value) {
                                  setState(() {
                                    isCheckedPre = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Container()
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //SEX
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  '性別',
                  style: formTitleStyle,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: formRequirdText,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio(
                      splashRadius: 10,
                      activeColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: gender.male,
                      groupValue: _gen,
                      onChanged: (gender? value) {
                        setState(() {
                          _gen = value!;
                          _con.gender = gender.male.name;
                        });
                      },
                    ),
                    const Text("男性")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      splashRadius: 10,
                      activeColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: gender.female,
                      groupValue: _gen,
                      onChanged: (gender? value) {
                        setState(() {
                          _gen = value!;
                          _con.gender = gender.female.name;
                        });
                      },
                    ),
                    const Text("女性")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      splashRadius: 10,
                      activeColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: gender.other,
                      groupValue: _gen,
                      onChanged: (gender? value) {
                        setState(() {
                          _gen = value!;
                          _con.gender = gender.other.name;
                        });
                      },
                    ),
                    const Text("無回答")
                  ],
                ),
              ],
            )
          ),
          // //OCCUPATION
          // Container(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Row(
          //     children: [
          //       const Text(
          //         '職種',
          //         style: formTitleStyle,
          //       ),
          //       const SizedBox(
          //         width: 10.0,
          //       ),
          //       Container(
          //         padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: Colors.red,
          //         ),
          //         child: formRequirdText,
          //       ),
          //     ],
          //   ),
          // ),
          // FormField<String>(
          //   builder: (FormFieldState<String> state) {
          //     return InputDecorator(
          //       decoration: InputDecoration(
          //         border: InputBorder.none,
          //         filled: true,
          //         fillColor: white,
          //         hintStyle: const TextStyle(color: primaryColor),
          //         errorText: _currentSelectedJob == null || _currentSelectedJob == '' ? '必須項目を入力してください。' : null,
          //         contentPadding: const EdgeInsets.only(
          //           left: 10, 
          //           right: 10
          //         ),
          //       ),
          //       isEmpty: _currentSelectedJob == null,
          //       child: DropdownButtonHideUnderline(
          //         child: DropdownButton<String>(
          //           hint: const Text(
          //             "選択する",
          //             style: TextStyle(
          //               color: primaryColor
          //             ),
          //           ),
          //           value: _currentSelectedJob,
          //           isDense: true,
          //           onChanged: (newValue) {
          //           setState(() {
          //             _currentSelectedJob = newValue!;
          //             _con.occupation = _currentSelectedJob;
          //             state.didChange(newValue);
          //           });
          //           },
          //           items: _prefCon.occupationList.map((String value) {
          //             return DropdownMenuItem<String>(
          //               value: value,
          //               child: Text(value),
          //             );
          //           }).toList(),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // //PHONE NUMBER
          // Container(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Row(
          //     children: [
          //       const Text(
          //         '電話番号',
          //         style: formTitleStyle,
          //       ),
          //       const SizedBox(
          //         width: 10.0,
          //       ),
          //       Container(
          //         padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: formAnyConatiner,
          //         ),
          //         child: formRequirdText,
          //       ),
          //     ],
          //   ),
          // ),
          // TextFormField(
          //   controller: _txtPhoneCon,
          //   keyboardType: TextInputType.number,
          //   onChanged: (value){
          //     _con.phone = _txtPhoneCon.text;
          //   },
          //   textInputAction: TextInputAction.next,
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //     filled: true,
          //     fillColor: white,
          //     hintText: '電話番号',
          //     hintStyle: TextStyle(color: primaryColor),
          //     contentPadding: EdgeInsets.only(left: 10, right: 10),
          //   ),
          //   inputFormatters: [
          //     FilteringTextInputFormatter.digitsOnly
          //   ],
          // ),
          // //LINE ID
          // Container(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Row(
          //     children: [
          //       const Text(
          //         'LINE ID',
          //         style: formTitleStyle,
          //       ),
          //       const SizedBox(
          //         width: 10.0,
          //       ),
          //       Container(
          //         padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: formAnyConatiner,
          //         ),
          //         child: formAnyText,
          //       ),
          //     ],
          //   ),
          // ),
          // TextFormField(
          //   controller:  _txtlineCon,
          //   keyboardType: TextInputType.emailAddress,
          //   // initialValue: args.lineId,
          //   textInputAction: TextInputAction.next,
          //     onChanged: (value){
          //     _con.lineID = _txtlineCon.text;
          //   },
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //     filled: true,
          //     fillColor: white,
          //     hintText: 'LINE ID',
          //     hintStyle: TextStyle(color: primaryColor),
          //     contentPadding: EdgeInsets.only(left: 10, right: 10),
          //   ),
          // ),
          //EmailAddress
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  'メールアドレス',
                  style: formTitleStyle,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: formRequirdText,
                ),
              ],
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            initialValue: profile.email,
            textInputAction: TextInputAction.next,
            enabled: false,
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintText: '瀬取 慎吾',
              hintStyle: TextStyle(color: primaryColor),
              contentPadding:EdgeInsets.only(left: 10, right: 10),
            ),
          ),
          //PASSWORD
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'パスワード',
                  style: formTitleStyle,
                ),
              ],
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            initialValue: profile.user.passwordToken ?? 'sdd0001',
            textInputAction: TextInputAction.done,
            obscureText: true,
            readOnly: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintText: 'セドリ シンゴ',
              hintStyle: TextStyle(color: primaryColor),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  showPasswordChangeDialog();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'パスワードを変更する',
                    style: TextStyle(color: primaryColor),
                    textAlign: TextAlign.right,
                  ),
                )
              ),
            ],
          ),
          //PUSH NOTIFICATION SETTING
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left:10.0,bottom: 8.0),
                child: Text(
                  'プッシュ通知設定',
                  style: formTitleStyle,
                ),
              ),
            ],
          ),
          Container(
            color: white,
            padding: const EdgeInsets.only(left:10.0,right: 10.0),
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,bottom:10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isSwitched
                      ?'オフ'
                      :'オン',
                    )
                  ),
                  CustomSwitch(
                    value: isSwitched, 
                      onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    // activeTrackColor: buttonDisableColor,
                    // activeColor: primaryColor,
                  ),
                  // Switch(
                  //   value: isSwitched,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       isSwitched = value;
                  //     });
                  //   },
                  //   activeTrackColor: buttonDisableColor,
                  //   activeColor: primaryColor,
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: buttonPrimaryColor
                ),
                onPressed: () async{
                  if (_formKey.currentState!.validate() && _con.isLoading.value == false /* && _currentSelectedJob != null */ && _currentSelectedPrefecture != null) {
                    await _con.firstLoginEdit(
                      context, 
                      _txtFirstName.text, 
                      _txtkanaFirstName.text, 
                      _currentSelectedDate, 
                      isCheckedAge, 
                      _con.prefecture, 
                      isCheckedPre, 
                      _con.gender, /* _currentSelectedJob, _txtPhoneCon.text, _txtlineCon.text, */ 
                      isSwitched==true?false:true
                    );
                    FocusManager.instance.primaryFocus?.unfocus();
                  }else{
                    showToastMessage("必須項目を入力してください");
                  }
                },
                child: const Text('つぎへ'),
              ),
            ),
          ),
          const SizedBox(
            height: kBottomNavigationBarHeight-30,
          )
        ],
      ),
    );
  }

  showPasswordChangeDialog() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16.0)),
                content: const PasswordChangeAlert(),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}