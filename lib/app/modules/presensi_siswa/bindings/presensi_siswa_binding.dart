import 'package:get/get.dart';

import '../controllers/presensi_siswa_controller.dart';

class PresensiSiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiSiswaController>(
      () => PresensiSiswaController(),
    );
  }
}
