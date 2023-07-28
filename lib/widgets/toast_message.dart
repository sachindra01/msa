import 'package:fluttertoast/fluttertoast.dart';

showToastMessage(message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM
  );
}