import 'package:get/get.dart';
import '../controllers/find_store_controller.dart';

class FindStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FindStoreController>(() => FindStoreController());
  }
}
