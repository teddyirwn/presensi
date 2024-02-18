import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController nisnC = TextEditingController();
  TextEditingController pwC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (nisnC.text.isNotEmpty && pwC.text.isNotEmpty) {
      try {} catch (e) {}
    } else {
      Get.snackbar("Terjadi esalahan", "Nisn dan password wajib diisi");
    }
  }
}
