import 'package:get/get.dart';
import '../controllers/tier_subscription_controller.dart';

class TierSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TierSubscriptionController>(() => TierSubscriptionController());
  }
}
