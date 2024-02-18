import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/widget/Ctextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.emailC.text = authC.user.value.nisn!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status ?? "";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.backgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Change Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                authC.changeProfile(
                  controller.nameC.text,
                  controller.statusC.text,
                );
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: ListView(
            children: [
              Obx(() => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 15),
                    width: 120,
                    height: 120,
                    child: authC.user.value.photoUrl == "noimage"
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "assets/logo/noimage.png",
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(120),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        authC.user.value.photoUrl!,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                  )),
              CtextField(
                controller: controller.emailC,
                label: "Nisn",
                readOnly: true,
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              SizedBox(
                height: 8,
              ),
              CtextField(
                controller: controller.nameC,
                textInputAction: TextInputAction.next,
                label: "Full Name",
              ),
              SizedBox(
                height: 8,
              ),
              CtextField(
                controller: controller.statusC,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  authC.changeProfile(
                    controller.nameC.text,
                    controller.statusC.text,
                  );
                },
                label: "Bio",
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<ChangeProfileController>(builder: (c) {
                      return c.pickedImage != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 125,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: FileImage(
                                                  File(
                                                    c.pickedImage!.path,
                                                  ),
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -5,
                                        child: IconButton(
                                          onPressed: () {
                                            return controller.resetImage();
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red[900],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => c
                                      .uploadImage(authC.user.value.uid!)
                                      .then((value) {
                                    print(value);
                                    if (value != null) {
                                      authC.updatePhotoUrl(value);
                                    }
                                  }),
                                  child: const Text("Upload"),
                                )
                              ],
                            )
                          : Text("no image");
                    }),
                    TextButton(
                      onPressed: () {
                        return controller.selectImage();
                      },
                      child: const Text("choosen"),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.changeProfile(
                      controller.nameC.text,
                      controller.statusC.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      )),
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
