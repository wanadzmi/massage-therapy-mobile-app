import 'package:get/get.dart';
import '../controllers/wallet_topup_controller.dart';

class WalletTopupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletTopupController>(() => WalletTopupController());
  }
}
