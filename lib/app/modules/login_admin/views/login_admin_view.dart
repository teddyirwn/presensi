import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_admin_controller.dart';

class LoginAdminView extends GetView<LoginAdminController> {
  const LoginAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: controller.emailC,
                      decoration: InputDecoration(
                        labelText: "NISN",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: controller.pwC,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.loginAdmin();
                      },
                      child: Text("Login"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
