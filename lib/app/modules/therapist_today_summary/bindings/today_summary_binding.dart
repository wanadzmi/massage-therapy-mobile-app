import 'package:get/get.dart';
import '../controllers/today_summary_controller.dart';

class TodaySummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodaySummaryController>(() => TodaySummaryController());
  }
}
