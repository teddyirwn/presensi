import 'package:get/get.dart';

import '../controllers/add_petugas_controller.dart';

class AddPetugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPetugasController>(
      () => AddPetugasController(),
    );
  }
}
