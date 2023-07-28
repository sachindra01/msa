import 'package:flutter/material.dart';
import 'package:msa/common/styles.dart';

loadingWidget([color]) {
  return CircularProgressIndicator(
    color: color ?? primaryColor,
  );
}