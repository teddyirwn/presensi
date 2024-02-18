import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_siswa_controller.dart';

class AddSiswaView extends GetView<AddSiswaController> {
  const AddSiswaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AddSiswaView'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              TextField(
                controller: controller.nisnC,
                decoration: InputDecoration(
                    labelText: "NISN", border: OutlineInputBorder()),
              ),
              TextField(
                controller: controller.namaC,
                decoration: InputDecoration(
                    labelText: "Nama", border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: () {
                    controller.addSiswa();
                  },
                  child: Text("Tambah"))
            ],
          ),
        ));
  }
}
