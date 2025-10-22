import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../controllers/notification_preferences_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<NotificationPreferencesController>(
      () => NotificationPreferencesController(),
    );
  }
}
