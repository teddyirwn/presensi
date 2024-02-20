import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/controllers/presensi_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    return BottomNavigationBar(
      currentIndex: authC.pageIndex.value,
      onTap: (int i) => authC.changePage(i),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Chat")
      ],
    );
  }
}
