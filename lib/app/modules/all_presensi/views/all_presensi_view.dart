import 'package:chatapp/app/modules/presensi_siswa/views/widget/card_presensi.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AllPresensiView'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamAllPresence(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Tidak Ada Data Presensi"),
                    );
                  }
                  print(snapshot.data!.docs);
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic>? data =
                          snapshot.data!.docs[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Material(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Get.toNamed(Routes.DETAIL_PRESENSI,
                                  arguments: data);
                            },
                            child: CardPresensi(
                              date: DateFormat.yMMMEd("id_ID")
                                  .format(DateTime.parse(data['date'])),
                              jamK: data['keluar']?['date'] == null
                                  ? "-"
                                  : "${DateFormat.Hm().format(DateTime.parse(data['keluar']!['date']))} WIB",
                              jamM: data['masuk']?['date'] == null
                                  ? "-"
                                  : "${DateFormat.Hm().format(DateTime.parse(data['masuk']!['date']))} WIB",
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ));
  }
}
