import 'package:get/get.dart';
import 'main_navigation_controller.dart';
import '../home/controllers/home_controller.dart';
import '../booking/controllers/booking_controller.dart';
import '../profile/controllers/profile_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BookingController>(() => BookingController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
