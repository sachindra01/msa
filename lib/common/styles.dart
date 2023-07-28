import 'package:flutter/material.dart';

const primaryColor = Color(0xFF26a69a);

const buttonPrimaryColor = Color(0xFF26a69a);
const buttonDisableColor = Color(0xFFe0e0e0);
const catTitleyColor = Color(0xFF333333);
const blogCountTextColor = Color.fromARGB(255, 48, 143, 87);
const activityDivider = Color(0xFFd4d9db);
const pagesAppbar = Color(0xFFF5F5F5);
const textColor1 = Color(0xFF4f4f4f);
const accountTextColor = Color(0xFF9C9C9C);
const borderWrapper = Color(0xFFffd600);
const formAnyConatiner = Color(0xFF3e4958);
const white = Colors.white;
const black = Colors.black;
const grey = Colors.grey;
const darkGrey = Color(0xFF373737);
const red = Colors.red;
const blue = Colors.blue;
const whiteGrey = Color(0xFFF2F2F2);
const lightgrey = Color(0xFFD3D3D3);
const transparent = Colors.transparent;
const buttonLightColor = Color(0xFF5cd4d4);
const transparentColor = Colors.transparent;
const inputErrorColor = Color(0xFF858595);
const repliedLabelColor = Color(0xff5cd4d4);
const linkColor = Color.fromARGB(255, 13, 71, 161);

const catTitleStyle =
    TextStyle(fontSize: 16, color: catTitleyColor, fontWeight: FontWeight.w700);
const movielistCatStyle =
    TextStyle(fontSize: 16, color: catTitleyColor, fontWeight: FontWeight.bold);
const titleStyle = TextStyle(
    fontSize: 14, color: catTitleyColor, fontWeight: FontWeight.normal);
const grouptitleStyle = TextStyle(
    fontSize: 16, color: textColor1, fontWeight: FontWeight.w600);
const groupSubTitleStyle = TextStyle(
    fontSize: 16, color: grey, fontWeight: FontWeight.normal);
const movieCountTextStyle =
    TextStyle(fontSize: 8, color: white, fontWeight: FontWeight.bold);
// const catTitleStyle =
//     TextStyle(fontSize: 14, color: catTitleyColor, fontWeight: FontWeight.bold);
const catChatTitleStyle = TextStyle(
    fontSize: 12, color: catTitleyColor, fontWeight: FontWeight.normal);
const catChatSubTitleStyle =
    TextStyle(fontSize: 10, color: grey, fontWeight: FontWeight.normal);
const chatSubTitleStyle =
    TextStyle(fontSize: 12, color: grey, fontWeight: FontWeight.normal);
const blogCountTextStyle = TextStyle(
    fontSize: 12, color: blogCountTextColor, fontWeight: FontWeight.bold);
const catTextStyle =
    TextStyle(fontSize: 12, color: white, fontWeight: FontWeight.normal);
const formTitleStyle =
    TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.bold);
const radioTitle2Style =
    TextStyle(fontSize: 10, color: white, fontWeight: FontWeight.bold);
const formRequirdText = Text('必須',
    style: TextStyle(color: white, fontSize: 10, fontWeight: FontWeight.bold));
const formAnyText = Text('任意',
    style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold));
const reportDateTitleStyle =
    TextStyle(fontSize: 12, color: grey, fontWeight: FontWeight.normal);
const reportTitleStyle =
    TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w300);
const reportStatusTextStyle =
    TextStyle(fontSize: 12, color: white, fontWeight: FontWeight.w300);
const audioTitleStyle =
    TextStyle(fontSize: 16, color: catTitleyColor, fontWeight: FontWeight.bold);
const chatTitleStyle =
    TextStyle(fontSize: 12, color: catTitleyColor, fontWeight: FontWeight.bold);

const dateTextStyle = TextStyle(
    fontSize: 10, color: grey, fontWeight: FontWeight.bold);
const inquiryTextStyle =
    TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w600);
const buttonBoldTextStyle =
    TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.bold);

const switchTextStyle = TextStyle(fontSize: 10.0, color: white, fontWeight: FontWeight.normal);
const textHighlightStyle = TextStyle( color: black,decoration: TextDecoration.none, backgroundColor: borderWrapper);
const badgeCounterTextStyle = TextStyle(fontSize:10, color: white,fontWeight: FontWeight.normal);

//chat
const chatUserNameStyle = TextStyle(fontSize: 10.0, color: darkGrey, fontWeight: FontWeight.normal);
const chatDateeStyle = TextStyle(fontSize: 10.0, color: grey, fontWeight: FontWeight.normal);
const chatBoxHintStyle = TextStyle(fontSize: 14.0, color: grey, fontWeight: FontWeight.normal);
const chatBoxTextStyle = TextStyle(fontSize: 14.0, color: darkGrey, fontWeight: FontWeight.normal);

const chatSystemMessageWhiteStyle = TextStyle(fontSize: 10.0, color: white, fontWeight: FontWeight.normal);
const chatSystemMessageBlackStyle = TextStyle(fontSize: 10.0, color: grey, fontWeight: FontWeight.normal);

const chatTextWhiteHeaderStyle = TextStyle(fontSize: 14.0, color: white, fontWeight: FontWeight.normal);
const chatTextBlackHeaderStyle =TextStyle(fontSize: 14.0, color: darkGrey, fontWeight: FontWeight.normal);

const chatReplyWhiteContentStyle = TextStyle(fontSize: 10.0, color: white, fontWeight: FontWeight.normal);
const chatReplyBlackContentStyle = TextStyle(fontSize: 10.0, color: darkGrey, fontWeight: FontWeight.normal);

const chatReplyWidgetUserNameStyle = TextStyle(fontSize: 10.0, color: darkGrey, fontWeight: FontWeight.normal);
const chatReplyWidgetSubTextStyle = TextStyle(fontSize: 14.0, color: darkGrey, fontWeight: FontWeight.normal);

//chatAddMedia
const chatAddMediaTextHeaderStyle = TextStyle(fontSize: 14.0, color: darkGrey, fontWeight: FontWeight.bold);
const chatAddMediaTextSubTitleStyle = TextStyle(fontSize: 10.0, color: grey, fontWeight: FontWeight.normal);

//chat imageUpload completed/total text
const imageUploadCounterTextStyle = TextStyle(fontSize:8.0, color: black,fontWeight: FontWeight.normal);

//mention textStyle
const mentionTextStyle = TextStyle(fontSize: 14.0,color: black,fontWeight:FontWeight.normal);


const formFieldDecoration = InputDecoration(
  border: InputBorder.none,
  filled: true,
  fillColor: white,
  hintText: '',
  hintStyle: TextStyle(color: primaryColor),
  contentPadding: EdgeInsets.only(left: 10, right: 10),
);
const viewMorebuttonStyle = TextStyle(fontSize: 12, color: black, fontWeight: FontWeight.normal);

formField(hintText) {
  InputDecoration(
    border: InputBorder.none,
    filled: true,
    fillColor: white,
    hintText: hintText.toString(),
    hintStyle: const TextStyle(color: black),
    contentPadding: const EdgeInsets.only(left: 10, right: 10),
  );
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return primaryColor;
}
