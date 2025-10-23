import 'package:get/get.dart';
import '../controllers/therapist_booking_detail_controller.dart';

class TherapistBookingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TherapistBookingDetailController>(
      () => TherapistBookingDetailController(),
    );
  }
}
