import 'package:chatapp/app/modules/presensi_siswa/views/widget/card_presensi.dart';
import 'package:chatapp/app/routes/app_pages.dart';
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
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Material(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_PRESENSI);
                      },
                      child: CardPresensi(
                        date: DateFormat.yMMMEd().format(DateTime.now()),
                        jamK: DateFormat.jms().format(DateTime.now()),
                        jamM: DateFormat.jms().format(DateTime.now()),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
