import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/services/chat_service.dart';
import '../views/chat_view.dart';
import '../bindings/chat_binding.dart';

class ChatListController extends GetxController {
  final ChatService _chatService = ChatService();

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _chats = <Chat>[].obs;
  final _currentPage = 1.obs;
  final _hasMore = true.obs;
  final _selectedFilter = 'all'.obs; // all, active, closed

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  List<Chat> get chats => _chats;
  String get selectedFilter => _selectedFilter.value;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  Future<void> loadChats({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _chats.clear();
      _hasMore.value = true;
    }

    if (_isLoading.value || _isLoadingMore.value) return;

    if (_currentPage.value == 1) {
      _isLoading.value = true;
    } else {
      _isLoadingMore.value = true;
    }

    try {
      final statusFilter = _selectedFilter.value == 'all'
          ? null
          : _selectedFilter.value;

      final response = await _chatService.getChats(
        status: statusFilter,
        page: _currentPage.value,
        limit: 20,
      );

      if (response.error != null) {}

      if (response.isSuccess && response.data != null) {
        final chatsData = response.data!;

        // Log each chat's basic info
        if (chatsData.chats != null) {
          for (var i = 0; i < chatsData.chats!.length; i++) {}
        }

        if (chatsData.chats != null && chatsData.chats!.isNotEmpty) {
          if (refresh || _currentPage.value == 1) {
            _chats.value = chatsData.chats!;
          } else {
            _chats.addAll(chatsData.chats!);
          }

          // Check if there are more pages
          if (chatsData.pagination != null) {
            final current = chatsData.pagination!.current ?? 1;
            final total = chatsData.pagination!.total ?? 1;
            _hasMore.value = current < total;
          } else {
            _hasMore.value = false;
          }
        } else {
          if (_currentPage.value == 1) {
            _chats.clear();
          }
          _hasMore.value = false;
        }
      } else {
        Get.snackbar(
          'Error',
          response.error?.toString() ?? 'Failed to load chats',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFFE53E3E),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while loading chats',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
    } finally {
      _isLoading.value = false;
      _isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreChats() async {
    if (!_hasMore.value || _isLoadingMore.value) return;

    _currentPage.value++;
    await loadChats();
  }

  Future<void> refreshChats() async {
    await loadChats(refresh: true);
  }

  void filterByStatus(String status) {
    if (_selectedFilter.value != status) {
      _selectedFilter.value = status;
      loadChats(refresh: true);
    }
  }

  void openChat(Chat chat) {
    // Use chatId (CHT123...) instead of id (MongoDB ObjectID)
    final chatId = chat.chatId ?? chat.id;

    if (chatId == null) {
      Get.snackbar(
        'Error',
        'Invalid chat ID',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
      return;
    }

    Get.to(
      () => const ChatView(),
      binding: ChatBinding(),
      arguments: {'chatId': chatId},
    );
  }

  String formatLastMessageTime(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String getChatStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'waiting':
        return 'Waiting';
      case 'closed':
        return 'Closed';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  Color getChatStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return const Color(0xFF4CAF50); // Green
      case 'waiting':
        return const Color(0xFFFFEB3B); // Yellow - waiting for agent
      case 'closed':
        return const Color(0xFF808080); // Gray
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF808080);
    }
  }
}
