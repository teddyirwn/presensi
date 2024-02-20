import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPetugasController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController fNameC = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void addPetugas() async {
    if (emailC.text.isNotEmpty && fNameC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (userCredential.user != null) {
          String? uid = userCredential.user?.uid;

          await firestore.collection("siswa").doc(uid).set({
            "uid": uid,
            "email": emailC.text,
            "fullName": fNameC.text,
            "photoUrl": "noimage",
            "role": "Petugas",
            "status": "",
            "createTime": DateTime.now().toIso8601String(),
            "lastSignInTime": DateTime.now().toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "Petugas Sudah ada Kamu tidak bisa menambahkan dengan email yang sama");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Menambahkan petugas");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Nama Lengkap dan Email Harus di Isi");
    }
  }
}
