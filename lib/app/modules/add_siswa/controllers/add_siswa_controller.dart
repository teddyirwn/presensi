import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSiswaController extends GetxController {
  TextEditingController nisnC = TextEditingController();
  TextEditingController namaC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addSiswa() async {
    if (nisnC.text.isNotEmpty && namaC.text.isNotEmpty) {
      try {
        String generateUID() {
          var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          var random = Random().nextInt(10000).toString().padLeft(4, '0');
          return '$timestamp-$random';
        }

        String uid = generateUID();

        CollectionReference siswa = firestore.collection("siswa");

        final checkSiswa = await siswa.doc(uid).get();

        if (checkSiswa.data() == null) {
          await siswa.doc(uid).set({
            "uid": uid,
            "nisn": nisnC.text,
            "name": namaC.text,
            "keyName": namaC.text.substring(0, 1).toUpperCase(),
            "photoUrl": "noimage",
            "password": "presensi123",
            "role": "Siswa",
            "status": "",
            "createTime": DateTime.now().toIso8601String(),
            "lastSignInTime": DateTime.now().toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });
          await siswa.doc(uid).collection("chats");
        } else {
          await siswa.doc(uid).update({
            "lastSignInTime": DateTime.now().toIso8601String(),
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "NISN, Nama Harus di isi");
    }
  }
}
