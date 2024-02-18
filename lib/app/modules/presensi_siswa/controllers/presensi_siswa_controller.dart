import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class PresensiSiswaController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> streamPresence() async* {
    final nisn = GetStorage().read("nisn");

    yield* firestore
        .collection('siswa')
        .doc(nisn)
        .collection('presence')
        .orderBy('date', descending: true)
        .limit(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    final nisn = GetStorage().read("nisn");

    String todayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    yield* firestore
        .collection('siswa')
        .doc(nisn)
        .collection('presence')
        .doc(todayID)
        .snapshots();
  }
}
