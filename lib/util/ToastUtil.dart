import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        webPosition: "left",
        fontSize: 22.0);
  }
}
