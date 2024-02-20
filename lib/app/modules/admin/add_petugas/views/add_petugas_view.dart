import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/add_petugas_controller.dart';

class AddPetugasView extends GetView<AddPetugasController> {
  const AddPetugasView({Key? key}) : super(key: key);
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
                controller: controller.emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
              ),
              TextField(
                controller: controller.fNameC,
                decoration: InputDecoration(
                    labelText: "Full name", border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: () {
                    controller.addPetugas();
                  },
                  child: Text("Tambah"))
            ],
          ),
        ));
  }
}
