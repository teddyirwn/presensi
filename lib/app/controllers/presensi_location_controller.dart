import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class PresensiLocationController extends GetxController {
  final nisn = GetStorage().read("nisn");
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getPosisition() async {
    Map<String, dynamic> res = await determinePosition();

    if (!res['error']) {
      Position position = res['position'];

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          "${placemarks[0].name},  ${placemarks[0].subLocality}, ${placemarks[0].locality}";

      double distanse = Geolocator.distanceBetween(
          -0.0706905, 109.4009582, position.latitude, position.longitude);

      if (distanse >= 200) {
        Get.defaultDialog(
            title: "Oppstt",
            middleText: "Anda Berada DiLuar Jangkauan yang ditentukan",
            confirm: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Oke")));
      } else {
        await updatePosition(position, address);
        await presensi(position, address, distanse);
      }
    } else {
      Get.defaultDialog(
          title: "Error",
          middleText: "${res['message']}",
          confirm: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Oke")));
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    await firestore.collection("siswa").doc(nisn).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<void> presensi(
      Position position, String address, double distanse) async {
    final nisn = GetStorage().read("nisn");
    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("siswa").doc(nisn).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresece = await colPresence.get();
    String todayDocId =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    String status = "Di dalam Area Sekolah";

    if (snapPresece.docs.length == 0) {
      // set absen masuk
      await sheetBottom(
        "Selamat data Masuk anda berhasil di rekam",
        DateTime.now(),
        DateTime.now(),
      );
      await colPresence.doc(todayDocId).set({
        "date": DateTime.now().toIso8601String(),
        "masuk": {
          "date": DateTime.now().toIso8601String(),
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "status": status,
          "distanse": distanse,
        }
      });
    } else {
      // cek hari ini sudah absen masuk/keluar
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocId).get();

      if (todayDoc.exists == true) {
        // absen Keluar / sudah absen masuk dan keluar
        Map<String, dynamic>? dataPresence = todayDoc.data();
        if (dataPresence?['keluar'] != null) {
          Get.defaultDialog(
              title: "oppstt",
              middleText: "Hari ini kamu sudah absen",
              confirm: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Oke")));
        } else {
          await sheetBottom(
            "Selamat data Pulang anda berhasil di rekam",
            DateTime.now(),
            DateTime.now(),
          );
          await colPresence.doc(todayDocId).update({
            "keluar": {
              "date": DateTime.now().toIso8601String(),
              "lat": position.latitude,
              "long": position.longitude,
              "address": address,
              "status": status,
              "distanse": distanse,
            }
          });
        }
      } else {
        // absen masuk

        await colPresence.doc(todayDocId).set({
          "date": DateTime.now().toIso8601String(),
          "masuk": {
            "date": DateTime.now().toIso8601String(),
            "lat": position.latitude,
            "long": position.longitude,
            "address": address,
            "status": status,
            "distanse": distanse,
          }
        });
        await sheetBottom(
          "Selamat data Masuk anda berhasil di rekam",
          DateTime.now(),
          DateTime.now(),
        );
      }
    }
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message": "Tidak dapat Mengakses GPS. Aktifkan Lokasi kamu",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Izin menggunakan GPS ditolak",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Settingan Hp tidak mengizinkan akses GPS",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Lokasi didapatkan",
      "error": false,
    };
  }

  Future<dynamic> sheetBottom(String subtitle, DateTime tgl, DateTime jam) {
    return Get.bottomSheet(
        backgroundColor: Colors.white,
        isDismissible: false,
        enterBottomSheetDuration: Duration(milliseconds: 400),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 18, left: 18),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.red.shade400,
                  ),
                  const Text(
                    "Anda Berhasil Absen",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle),
                  const SizedBox(
                    height: 18,
                  ),
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Detail Absen",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.red.shade300,
                              ),
                              Text(DateFormat.yMMMEd().format(tgl))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.alarm,
                                color: Colors.red.shade300,
                              ),
                              Text(DateFormat.jms().format(jam))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(300, 30),
                      backgroundColor: Colors.red.shade300,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Tutup"),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
