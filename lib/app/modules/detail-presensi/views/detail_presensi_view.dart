import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Presensi'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(18),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Text(
                      "Masuk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    Center(
                        child: Text(DateFormat.yMMMMEEEEd()
                            .format(DateTime.parse(data['date'])))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Jam",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        " ${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}"),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Status",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(data['masuk']['status']),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Jarak",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "${data['masuk']['distanse'].toString().split('.').first} Meter"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Posisi",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(data['masuk']['address']),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(18),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Text(
                      "Pulang",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    Center(
                        child: Text(DateFormat.yMMMMEEEEd()
                            .format(DateTime.parse(data['date'])))),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Jam",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(data['masuk']['date'] == null
                        ? "-"
                        : " ${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Status",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(data['keluar']['status'] ?? "-"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Jarak",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "${data['keluar']['distanse'].toString().split('.').first} Meter" ??
                            "-"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Posisi",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(data['keluar']['address'] ?? "-"),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
