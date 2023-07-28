// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/age_calculator.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/controller/prefecturelist_controller.dart';
import 'package:msa/views/auth/password_change.dart';
import 'package:msa/widgets/loading_widget.dart';

class EditAccountPage extends StatefulWidget {
  static const routeName = '/edit_account';
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

enum gender { male, female, other }

class _EditAccountPageState extends State<EditAccountPage> {
  final PrefectureController _con = Get.put(PrefectureController());
  final AuthController _authCon = Get.put(AuthController());
  final _txtFirstName = TextEditingController();
  final _txtkanaFirstName = TextEditingController();
  final _txtPhoneCon = TextEditingController();
  final _txtlineCon = TextEditingController();

  late gender _gen ;
  late  bool isCheckedAge;
  bool isCheckedPre = false;
  bool isCheckedGender = false;
  bool isCheckedGender3 = false;
  bool isSwitched = false;
  var args = Get.arguments;

  var _currentSelectedPrefecture;
  var currentSelectedJob;
  var _currentSelectedDate;
  var _age = "".obs;
  var _validateFirstName;
  var _validatekanaName;

  @override
  void initState() {
    _con.getPrefectureList();
    _con.getOccupationList();
    _txtFirstName.text = args.firstName;
    _txtkanaFirstName.text = args.kanaFirstName;
    _txtPhoneCon.text = args.phoneNo1 ?? '';
    _authCon.phone = args.phoneNo1 ?? '';
    _txtlineCon.text = args.lineId ?? '';
    _authCon.lineID = args.lineId ?? '';
    _authCon.firstName = args.firstName ?? '';
    _authCon.kanaFirstName = args.kanaFirstName ?? '';
    _authCon.prefecture = args.address1 ?? '';
    isCheckedAge = args.showAge ?? false;
    isCheckedPre = args.status ?? false;
    isSwitched = args.notificationStatus ?? false;
    //  currentSelectedJob =args.occupation;
    //  _currentSelectedPrefecture =args.prefecture;
    if(args.occupation != "null"){  
      currentSelectedJob =args.occupation;
    }
    if(args.prefecture != ""){ 
      _currentSelectedPrefecture =args.prefecture;
    }
    _authCon.isSwitched = args.notificationStatus ?? false;
    _authCon.ageDisclose = args.showAge ?? false;
    _authCon.status = args.status ?? false;
    _authCon.dobYear = args.dobYear;
    _authCon.gender = args.gender;
    _gen = gender.values.byName(args.gender);
    _authCon.occupation = args.occupation ?? "";
    _validateFirstName = false;
    _validatekanaName=false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    validated(){
      if(_validateFirstName == false && _validatekanaName == false){
        return true;
      } 
      else{
        return false;
      }
    }
    var now = DateTime.now();
    int date = now.year;
    List year = [];

    for (int i = 1950; i <= date-13; i++) {
      year.add(i.toString());
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: pagesAppbar,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: black, //change your color here
          ),
          title: const Text(
            'アカウント基本情報',
            style: TextStyle(color: black, fontSize: 16),
          ),
        ),
        body: GetBuilder<PrefectureController>(
          init: PrefectureController(),
          builder: (_) {
            return Obx(() => 
              _con.isLoading.value == true
              ? Center(child: loadingWidget())
              : _con.prefectureList.isEmpty
              ? const Center(
                child: Text("該当データがありません"),
              )
              : Container(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                        keyboardType: TextInputType.emailAddress,
                        // initialValue: args.firstName,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            _authCon.firstName = _txtFirstName.text;
                            _txtFirstName.text == '' ?_validateFirstName = true: _validateFirstName = false;
                          });
                        },
                        decoration:  InputDecoration(
                          errorText: _validateFirstName ? "必須項目を入力してください。" : '',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: white,
                          hintText: '瀬取 慎吾',
                          hintStyle: const TextStyle(color: primaryColor),
                          contentPadding:
                            const  EdgeInsets.only(left: 10, right: 10),
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
                          onChanged: (value) {
                          setState(() {
                            _authCon.kanaFirstName = _txtkanaFirstName.text;
                              _txtkanaFirstName.text == '' ?_validatekanaName = true: _validatekanaName = false;
                          });
                        },
                        // initialValue: args.kanaFirstName,
                        textInputAction: TextInputAction.next,
                        decoration:  InputDecoration(
                            errorText: _validatekanaName ? "必須項目を入力してください。" : '',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: white,
                          hintText: 'セドリ シンゴ',
                          hintStyle: const TextStyle(color: primaryColor),
                          contentPadding:
                            const  EdgeInsets.only(left: 10, right: 10),
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
                                      padding: const EdgeInsets.all(
                                          10.0),
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
                                    FormField<String>(
                                      builder:
                                          (FormFieldState<String>
                                              state) {
                                        return InputDecorator(
                                          decoration:const InputDecoration(
                                            
                                            
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: white,
                                            hintStyle: TextStyle(
                                                color:
                                                    primaryColor),
                                            contentPadding:
                                                EdgeInsets.only(
                                                    left: 10,
                                                    right: 10),

                                            // errorText: !_validate ? '必須項目を入力してください。' : null,
                                          ),
                                          isEmpty:
                                              _currentSelectedDate ==
                                                  args.dobYear,
                                          child:
                                              DropdownButtonHideUnderline(
                                                
                                            child: DropdownButton<String>(
                                                  menuMaxHeight: MediaQuery.of(context).size.height*0.35,
                                                  itemHeight: kMinInteractiveDimension + 10,
                                                  
                                              // onChanged: ((value) => {}),
                                                  value: _currentSelectedDate ??
                                                  args.dobYear
                                                      .toString() ??'0',
                                                  isDense: true,
                                              // onChanged:(){},
                                                  onChanged:
                                                      (newValue) {
                                                      setState(() {
                                                          _currentSelectedDate =newValue!;
                                                          _age.value = (date -int.parse(_currentSelectedDate)).toString().substring(0,1) + "0代";

                                                          _authCon.dobYear = _currentSelectedDate;
                                                          state.didChange( newValue);
                                                        });
                                              },
                                              items:
                                                  year.map((value) {
                                                return DropdownMenuItem<
                                                    String>(
                                                      
                                                  value: value,
                                                  child:
                                                      Center(child: Text(value +"年")) ,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(10.0),
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
                                    padding:
                                        const EdgeInsets.all(15),
                                    child: Obx(
                                      (() => Text(_age.value == ""
                                          ? ageCalculator((date - int.parse(args.dobYear ??'0')).toString())+"代"
                                          : _age.value)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                mainAxisAlignment:MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(10.0),
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
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    color: white,
                                    child: Transform.scale(
                                      scale: 1.2,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            
                                            shape:
                                                const CircleBorder(),
                                            splashRadius: 10,
                                            checkColor:
                                                Colors.white,
                                            fillColor:
                                                MaterialStateProperty
                                                    .resolveWith(
                                                        getColor),
                                            value:  isCheckedAge,
                                            onChanged:
                                                (bool? value) {
                                              setState(() {
                                                isCheckedAge =value!;
                                                _authCon.ageDisclose = value;
                                              });
                                            },
                                          ),
                                          Expanded(
                                              child: Container())
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
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                          10.0),
                                      child: Row(
                                        children: [
                                          const Text( '都道府県',
                                            style: formTitleStyle,
                                          ),
                                          const SizedBox( width: 10.0,
                                          ),
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
                                    FormField<String>(
                                      builder:
                                          (FormFieldState<String>state) {
                                        return InputDecorator(
                                          decoration: const InputDecoration(
                                            
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: white,
                                            hintStyle: TextStyle(
                                                color: primaryColor),
                                            contentPadding:EdgeInsets.only(
                                                    left: 10,
                                                    right: 10),

                                            // errorText: !_validate ? '必須項目を入力してください。' : null,
                                          ),
                                          isEmpty: _currentSelectedPrefecture == null,
                                          child:
                                              DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                                hint: const Text(
                                                      "選択する",
                                                      style: TextStyle(
                                                          color: primaryColor),
                                                    ),
                                              isExpanded: true,

                                              value: _currentSelectedPrefecture,
                                                  
                                              isDense: true,
                  
                                              items:_con.prefectureList.map( (String value) {
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
                                                  _authCon.prefecture = (_con.prefectureList.indexOf(newValue!)+1).toString();
                                                  state.didChange(newValue);
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(10.0),
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
                                          Checkbox(shape:const CircleBorder(),
                                            splashRadius: 10,
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColor),
                                            value: isCheckedPre,
                                            onChanged:(bool? value) {
                                              setState(() {
                                                isCheckedPre =value!;
                                                _authCon.status = value;
                                              });
                                            },
                                          ),
                                          Expanded(
                                              child: Container())
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
                                borderRadius:
                                    BorderRadius.circular(10),
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
                                      _authCon.gender = gender.male.name;
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
                                      _authCon.gender = gender.female.name;
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
                                      _authCon.gender = gender.other.name;
                                    });
                                  },
                                ),
                                const Text("無回答")
                              ],
                            ),
                          ],
                        )
                      ),
                      //OCCUPATION
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
                      //           borderRadius:
                      //               BorderRadius.circular(10),
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
                      //       decoration: const InputDecoration(
                      //         border: InputBorder.none,
                      //         filled: true,
                      //         fillColor: white,
                      //         hintStyle:
                      //             TextStyle(color: primaryColor),
                      //         contentPadding: EdgeInsets.only(
                      //             left: 10, right: 10),

                      //         // errorText: !_validate ? '必須項目を入力してください。' : null,
                      //       ),
                      //       isEmpty: currentSelectedJob ==
                      //           null,
                      //       child: DropdownButtonHideUnderline(
                      //         child: DropdownButton<String>(
                      //           hint: const Text(
                      //             "選択する",
                      //             style: TextStyle(
                      //                 color: primaryColor),
                      //           ),

                                
                      //            value: currentSelectedJob,
                      //           isDense: true,
                              
                      //           onChanged: (newValue) {
                      //             setState(() {
                      //               currentSelectedJob = newValue!;
                      //               _authCon.occupation = currentSelectedJob;
                      //               state.didChange(newValue);
                      //             });
                      //           },
                      //           items:
                      //               _con.occupationList.map((String value) {
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
                      //PHONE NUMBER
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
                      //           borderRadius:
                      //               BorderRadius.circular(10),
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
                      //     _authCon.phone = _txtPhoneCon.text;
                      //   },
                      //   textInputAction: TextInputAction.next,
                      //   decoration: const InputDecoration(
                      //     border: InputBorder.none,
                      //     filled: true,
                      //     fillColor: white,
                      //     hintText: '電話番号',
                      //     hintStyle: TextStyle(color: primaryColor),
                      //     contentPadding:
                      //         EdgeInsets.only(left: 10, right: 10),
                      //   ),
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly
                      //   ],
                      // ),
                      //LINE ID
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
                      //           borderRadius:
                      //               BorderRadius.circular(10),
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
                      //    onChanged: (value){
                      //     _authCon.lineID = _txtlineCon.text;
                      //   },
                      //   decoration: const InputDecoration(
                      //     border: InputBorder.none,
                      //     filled: true,
                      //     fillColor: white,
                      //     hintText: 'LINE ID',
                      //     hintStyle: TextStyle(color: primaryColor),
                      //     contentPadding:
                      //         EdgeInsets.only(left: 10, right: 10),
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
                              margin: EdgeInsets.zero,
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                              // padding: const EdgeInsets.symmetric(
                              //     horizontal: 10,vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(8),
                                color: Colors.red,
                              ),
                              child: const Center(child: formRequirdText),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        initialValue: args.email,
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: white,
                          hintText: '瀬取 慎吾',
                          hintStyle: TextStyle(color: primaryColor),
                          contentPadding:
                              EdgeInsets.only(left: 10, right: 10),
                        ),
                      ),
                      //PASSWORD
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: const [
                            Text(
                              'パスワード',
                              style: formTitleStyle,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        initialValue: args.user.passwordToken ?? 'sdd0001',
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: white,
                          hintText: 'セドリ シンゴ',
                          hintStyle: TextStyle(color: primaryColor),
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                        ),
                      ),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          InkWell(
                            onTap: () {
                              showPasswordChangeDialog();
                            },
                            child: const Text(
                              'パスワードを変更する',
                              style: TextStyle(color: primaryColor),
                              textAlign: TextAlign.right,
                            )
                          ),
                        ],
                      ),
                      //PUSH NOTIFICATION SETTING
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Expanded(child: Text('プッシュ通知設定')),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  _authCon.isSwitched;
                                  debugPrint(isSwitched.toString());
                                });
                              },
                              activeTrackColor: buttonDisableColor,
                              activeColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 50.0,
                        child: Obx(()=> _authCon.isLoading.value == true 
                        ? Center(child: loadingWidget())
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: buttonPrimaryColor
                          ),
                          onPressed: () {
                            var x = validated();
                            if(x == true){ 
                              _authCon.updateUserInfo(
                                context, 
                                _txtFirstName.text, 
                                _txtkanaFirstName.text, 
                                // _txtPhoneCon.text, 
                                // _txtlineCon.text, 
                                _authCon.dobYear, 
                                isCheckedAge, 
                                _authCon.prefecture, 
                                _authCon.gender, 
                                // _authCon.occupation, 
                                isCheckedPre,
                                isSwitched, 
                              );
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                          child: const Text('保存する'),
                        ),)
                      ),
                      const SizedBox(
                        height: kBottomNavigationBarHeight,
                      )
                    ],
                  ),
                ),
              )
            );
          }
        )
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
                borderRadius: BorderRadius.circular(16.0)
              ),
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
      }
    );
  }
}
