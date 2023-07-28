import 'package:get/get.dart';

class Validations {

  email(value) {
    if(GetUtils.isLengthLessThan(value, 1)) {
      return "メールアドレスが正しくありません";
    } else if(!GetUtils.isEmail(value)) {
      return "無効なメール";
    } else if(value.contains('+@')) {
      return "無効なメール";
    } else {
      return null;
    }
  }

  userName(value) {
    final regExp = RegExp(r'^[a-zA-Z一-龠ぁ-ゔァ-ヴー0-9_\-.々〆〤]+$');
    if(GetUtils.isLengthLessThan(value, 1)) {
      return "usernamedBlankError".tr;
    } else if(checkForWhiteSpaces(value)) {
      return 'emptyField';
    } else if(!GetUtils.isLengthBetween(value, 4, 20)) {
      return "usernameLimit".tr;
    } else if(!regExp.hasMatch(value)) {
      return '無効なメール';
    } else {
      return null;
    }
  }

  password(value) {
    if(checkForWhiteSpaces(value)) {
      return 'パスワードは空にできません';
    } else if(GetUtils.isLengthLessThan(value, 1)) {
      return "パスワードは空にできません";
    } else if(!GetUtils.isLengthBetween(value, 6, 20)) {
      return "パスワードは6〜20文字の長さである必要があります";
    } else {
      return null;
    }
  }

  isWhiteSpace(value) {
    if(checkForWhiteSpaces(value)) {
      return '必須項目を入力してください。';
    } else {
      return null;
    }
  }

  checkForWhiteSpaces(value) {
    if(value!.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  limit255(value) {
    if(checkForWhiteSpaces(value)) {
      return 'emptyField';
    } else if(GetUtils.isLengthLessThan(value, 1)) {
      return "emptyField".tr;
    } else if(GetUtils.isLengthGreaterThan(value, 255)) {
      return "limit255".tr;
    } else {
      return null;
    }
  }

  maxLimit255(value) {
    if(GetUtils.isLengthGreaterThan(value, 255)) {
      return "limit255".tr;
    } else {
      return null;
    }
  }

  token(value) {
    if(!GetUtils.isLengthEqualTo(value, 6)) {
      return 'コード制限は6';
    } else {
      return null;
    }
  } 

}