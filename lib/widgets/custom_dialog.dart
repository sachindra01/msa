 import 'package:flutter/material.dart';

void openCustomDialog(route,context) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.1),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Colors.transparent)),
              content: route,
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