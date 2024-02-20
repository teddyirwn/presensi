import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AllPresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllPresence() async* {
    final uid = GetStorage().read("uid");

    yield* firestore
        .collection('siswa')
        .doc(uid)
        .collection('presence')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
