import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/chat_service.dart';
import 'chat_list_controller.dart';

class ChatCreateController extends GetxController {
  final ChatService _chatService = ChatService();

  final _isCreating = false.obs;
  final _selectedCategory = 'general'.obs;

  bool get isCreating => _isCreating.value;
  String get selectedCategory => _selectedCategory.value;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final categories = [
    {
      'value': 'general',
      'label': 'General Inquiry',
      'icon': Icons.help_outline,
    },
    {
      'value': 'booking',
      'label': 'Booking Question',
      'icon': Icons.calendar_today,
    },
    {'value': 'payment', 'label': 'Payment Issue', 'icon': Icons.payment},
    {'value': 'service', 'label': 'Service Question', 'icon': Icons.spa},
    {'value': 'technical', 'label': 'Technical Support', 'icon': Icons.build},
  ];

  void setCategory(String category) {
    _selectedCategory.value = category;
  }

  Future<void> createChat() async {
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();

    if (message.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (message.length < 10) {
      Get.snackbar(
        'Message Too Short',
        'Please provide more details (minimum 10 characters)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    _isCreating.value = true;

    final response = await _chatService.createChat(
      type: 'customer_support',
      message: message,
      subject: subject.isNotEmpty ? subject : null,
      category: _selectedCategory.value,
      priority: 'normal',
    );

    _isCreating.value = false;

    if (response.isSuccess && response.data != null) {
      final chatId = response.data!.chatId ?? response.data!.id;
      print('✅ Chat created successfully with ID: $chatId');
      print('📋 Chat data: ${response.data!.toJson()}');

      Get.back(); // Close create screen

      // Try to refresh chat list if it exists
      try {
        final chatListController = Get.find<ChatListController>();
        print('🔄 Refreshing chat list after creation...');
        chatListController.refreshChats();
      } catch (e) {
        print('⚠️ ChatListController not found, skipping refresh: $e');
      }

      // Navigate to the new chat
      Get.toNamed('/chat', arguments: {'chatId': chatId});

      Get.snackbar(
        'Chat Created',
        'Connecting you with support...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD4AF37),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to create chat. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
