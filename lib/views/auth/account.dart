import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/views/auth/edit_account.dart';

import 'package:msa/widgets/loading_widget.dart';

class AccountPage extends StatefulWidget {
  static const routeName = '/account';
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthController _con = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _con.getUserInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: pagesAppbar,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: black, //change your color here
        ),
        title: const Text(
          'アカウント',
          style: TextStyle(color: black, fontSize: 16),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(BorderSide.none),
              shadowColor: MaterialStateProperty.all(transparent),
              overlayColor: MaterialStateProperty.all(transparent),
            ),
            onPressed: () {
              Get.off(() => const EditAccountPage(), arguments: _con.userInfo);
            },
            child: const Text(
              '編集',
              style: TextStyle(color: primaryColor, fontSize: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: MediaQuery.of(context).size.height,
          child: GetBuilder(
            init: AuthController(),
            builder: (context) {
              return Obx(() => _con.isLoading.value == true
                ? Center(child: loadingWidget())
                : (_con.userInfo == null)
                  ? const Center(
                    child: Text("該当データがありません"),
                  )
                  : accountBody()
              );
            }),
        )
      ),
    );
  }

  accountBody() {
    var details = _con.userInfo;
    var now = DateTime.now();
    int date = now.year;
    var x = DateTime.parse(details.user.createdAt);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "氏名",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.firstName ?? '',
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "氏名（カタカナ）",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.kanaFirstName,
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "生まれた年",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.dobYear.toString() + "年",
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "年代",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                (date - int.parse(details.dobYear)).toString().substring(0,1) + "0代",
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "公開",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.isPremium ? "非公開 " : "公開",
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "都道府県",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.prefecture ?? '',
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "性別",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.gender == "male" 
                  ? "男性" 
                  : details.gender == "female" 
                    ? "女性" 
                    : "無回答",
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "職種",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.occupation ?? "",
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "電話番号",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.phoneNo1.toString() != "null"
                    ? details.phoneNo1.toString()
                    : "",
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "メールアドレス",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.email,
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "会員ID",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                details.memberCode.toString(),
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "登録日",
                style: TextStyle(color: black, fontSize: 16.0),
              ),
              Text(
                x.year.toString() +
                    "年" +
                    x.month.toString() +
                    "月" +
                    x.day.toString() +
                    "月",
                style: const TextStyle(
                    color: accountTextColor, fontSize: 16.0),
              )
            ],
          ),
        ),
        const Divider(
          color: activityDivider,
        ),
      ],
    );
  }
}
