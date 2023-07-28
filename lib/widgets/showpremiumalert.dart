import 'package:flutter/material.dart';
import 'package:msa/widgets/premium_alert.dart';

showPremiumAlert(BuildContext ctx){
  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(opacity: a1.value, child: const PremiumAlertWidget()),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: ctx,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    }
  );
}