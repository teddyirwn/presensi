import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/controllers/presensi_location_controller.dart';
import 'package:chatapp/app/modules/presensi_siswa/views/widget/card_presensi.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/utils/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/presensi_siswa_controller.dart';

class PresensiSiswaView extends GetView<PresensiSiswaController> {
  const PresensiSiswaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final presensiC = Get.put(PresensiLocationController(), permanent: true);
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: SafeArea(
          child: ListView(
        children: [
          const ListTile(
            title: Text(
              "Absen",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(() => ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            width: 55,
                            height: 55,
                            child: authC.user.value.photoUrl! != "noimage"
                                ? Image.network(
                                    authC.user.value.photoUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/logo/noimage.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              "${authC.user.value.name}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        Text(
                          "${authC.user.value.role}",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamTodayPresence(),
                    builder: (context, snapToday) {
                      if (snapToday.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      Map<String, dynamic>? dataToday = snapToday.data?.data();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            dataToday?['masuk'] == null
                                ? "-"
                                : dataToday?['keluar'] == null
                                    ? "${DateFormat.Hm().format(DateTime.parse(dataToday?['masuk']['date']))} WIB"
                                    : "${DateFormat.Hm().format(DateTime.parse(dataToday?['keluar']['date']))} WIB",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            dataToday?['date'] == null
                                ? "-"
                                : DateFormat.yMMMEd()
                                    .format(DateTime.parse(dataToday?['date'])),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.checklist_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 30),
                    backgroundColor: Colors.red.shade300,
                  ),
                  onPressed: () {
                    presensiC.getPosisition();
                  },
                  child: const Text(
                    "Absen",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
            width: double.infinity,
            // height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Riwayat Presensi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.ALL_PRESENSI);
                          },
                          child: const Text(
                            "Lihat Semua",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: controller.streamPresence(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data!.docs.length == 0 ||
                              snapshot.data == null) {
                            return const Center(
                              child: Text(
                                "Tidak Ada History Presensi",
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> data =
                                  snapshot.data!.docs[index].data();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Material(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Get.toNamed(
                                        Routes.DETAIL_PRESENSI,
                                        arguments: data,
                                      );
                                    },
                                    child: CardPresensi(
                                      date: DateFormat.yMMMEd('id_ID')
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
                ],
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: NavigationMenu(),
    );
  }
}
