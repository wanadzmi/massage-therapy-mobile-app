import 'package:get/get.dart';
import '../controllers/wallet_topup_controller.dart';

class WalletTopUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletTopUpController>(() => WalletTopUpController());
  }
}
