import 'package:get/get.dart';
import '../controllers/tier_detail_controller.dart';

class TierDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TierDetailController>(() => TierDetailController());
  }
}
