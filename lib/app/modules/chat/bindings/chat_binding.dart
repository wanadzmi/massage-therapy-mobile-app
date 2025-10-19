import 'package:get/get.dart';
import '../../../data/services/chat_socket_service.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize socket service first (synchronously for immediate availability)
    // If not already initialized, create it
    if (!Get.isRegistered<ChatSocketService>()) {
      final socketService = ChatSocketService();
      Get.put<ChatSocketService>(socketService, permanent: true);
      // Initialize connection in background
      socketService.init();
    }

    // Then create the chat controller
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
