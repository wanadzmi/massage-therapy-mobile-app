import 'package:get/get.dart';
import '../controllers/therapist_selection_controller.dart';

class TherapistSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TherapistSelectionController>(
      () => TherapistSelectionController(),
    );
  }
}
