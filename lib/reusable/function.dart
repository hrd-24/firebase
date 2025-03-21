  // Fungsi untuk menampilkan Toast
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 3, 110, 182),
      textColor: const Color.fromARGB(255, 245, 242, 242),
      fontSize: 14.0,
    );
  }

Color appBarBG() {
  return const Color.fromARGB(255, 137, 176, 207);
}

Color textBar() {
  return  Colors.black;
}
