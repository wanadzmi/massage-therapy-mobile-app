import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/services/chat_service.dart';
import '../../../data/services/chat_socket_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  ChatSocketService? _socketService; // Made nullable

  final _isLoading = false.obs;
  final _isSending = false.obs;
  final _isLoadingMore = false.obs;
  final _messages = <ChatMessage>[].obs;
  final _chat = Rxn<Chat>();
  final _isTyping = false.obs;
  final _hasMore = true.obs;

  bool get isLoading => _isLoading.value;
  bool get isSending => _isSending.value;
  bool get isLoadingMore => _isLoadingMore.value;
  List<ChatMessage> get messages => _messages;
  Chat? get chat => _chat.value;
  bool get isTyping => _isTyping.value;
  bool get hasMore => _hasMore.value;

  String? chatId;
  String? currentUserId;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? _typingTimer;
  int _currentPage = 1;
  static const int _pageLimit = 50;
  bool _listenersSetup = false; // Flag to prevent duplicate listeners

  // Worker references for cleanup
  Worker? _newMessageWorker;
  Worker? _typingWorker;
  Worker? _assignedWorker;
  Worker? _closedWorker;
  Worker? _receiptWorker;

  @override
  void onInit() {
    super.onInit();

    // Get chat socket service
    try {
      _socketService = Get.find<ChatSocketService>();
    } catch (e) {
      // Will be initialized by ChatBinding, give it a moment
      // Listeners will be set up in _joinChatWhenReady()
    }

    // Get chat ID from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    chatId = args?['chatId'] as String?;

    if (chatId != null) {
      loadChatData();
      loadMessages();

      // Join chat room once socket is connected
      _joinChatWhenReady();
    }

    // Setup infinite scroll
    scrollController.addListener(_onScroll);

    // Listen to message text field changes for typing indicator
    messageController.addListener(_onMessageTextChanged);
  }

  /// Wait for socket to be connected before joining chat
  Future<void> _joinChatWhenReady() async {
    if (_socketService == null || chatId == null) return;

    // Check if already connected
    if (_socketService!.isConnected) {
      _socketService?.joinChat(chatId!);
      _setupSocketListeners();
      return;
    }

    // Wait for connection (max 10 seconds)
    int attempts = 0;
    const maxAttempts = 20; // 20 attempts × 500ms = 10 seconds

    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (_socketService?.isConnected == true) {
        _socketService?.joinChat(chatId!);
        _setupSocketListeners();
        return;
      }

      attempts++;
    }
  }

  void _setupSocketListeners() {
    if (_socketService == null) {
      return;
    }

    // Prevent setting up listeners multiple times
    if (_listenersSetup) {
      return;
    }

    _listenersSetup = true;

    // Dispose old workers first (in case they exist from previous navigation)
    _newMessageWorker?.dispose();
    _typingWorker?.dispose();
    _assignedWorker?.dispose();
    _closedWorker?.dispose();
    _receiptWorker?.dispose();

    // Listen for new messages
    _newMessageWorker = ever(_socketService!.newMessage, (
      ChatMessage? message,
    ) {
      // Match against both chatId (CHT format) and chat.id (MongoDB _id)
      final matchesChatId = message?.chat == chatId;
      final matchesMongoId = message?.chat == _chat.value?.id;

      if (message != null && (matchesChatId || matchesMongoId)) {
        // Skip messages from current user (already handled optimistically)
        final isOwnMessage = message.sender?.id == currentUserId;

        if (isOwnMessage) {
          return;
        }

        _addMessageToList(message);

        // Auto-scroll to bottom if near bottom
        if (scrollController.hasClients) {
          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.offset;
          if (maxScroll - currentScroll < 200) {
            _scrollToBottom();
          }
        }
      }
    });

    // Listen for typing indicators
    _typingWorker = ever(_socketService!.typingIndicator, (
      Map<String, dynamic>? data,
    ) {
      if (data != null && data['chatId'] == chatId) {
        _isTyping.value = data['isTyping'] == true;

        // Auto-hide after 5 seconds
        if (_isTyping.value) {
          Future.delayed(const Duration(seconds: 5), () {
            if (_isTyping.value) {
              _isTyping.value = false;
            }
          });
        }
      }
    });

    // Listen for chat assigned
    _assignedWorker = ever(_socketService!.chatAssigned, (
      Map<String, dynamic>? data,
    ) {
      if (data != null && data['chatId'] == chatId) {
        // Reload chat data to get agent info
        loadChatData();

        // Show notification
        Get.snackbar(
          'Agent Assigned',
          '${data['assignedAgent']?['name'] ?? 'An agent'} has joined the chat',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF2A2A2A),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });

    // Listen for chat closed
    _closedWorker = ever(_socketService!.chatClosed, (
      Map<String, dynamic>? data,
    ) {
      if (data != null && data['chatId'] == chatId) {
        // Reload chat data to update status
        loadChatData();

        Get.snackbar(
          'Chat Closed',
          'This conversation has been closed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF2A2A2A),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });

    // Listen for read receipts
    _receiptWorker = ever(_socketService!.readReceipt, (
      Map<String, dynamic>? data,
    ) {
      if (data != null && data['chatId'] == chatId) {
        final messageId = data['messageId'];
        final index = _messages.indexWhere((m) => m.messageId == messageId);
        if (index != -1) {
          // Update message status to read
          final updatedMessage = _messages[index];
          _messages[index] = ChatMessage(
            id: updatedMessage.id,
            messageId: updatedMessage.messageId,
            chat: updatedMessage.chat,
            sender: updatedMessage.sender,
            content: updatedMessage.content,
            status: 'read',
            delivery: updatedMessage.delivery,
            attachments: updatedMessage.attachments,
            replyTo: updatedMessage.replyTo,
            isEdited: updatedMessage.isEdited,
            isDeleted: updatedMessage.isDeleted,
            createdAt: updatedMessage.createdAt,
            updatedAt: updatedMessage.updatedAt,
          );
          _messages.refresh();
        }
      }
    });
  }

  void _onScroll() {
    // Load more messages when scrolling to top
    if (scrollController.position.pixels <= 100 &&
        !_isLoadingMore.value &&
        _hasMore.value) {
      loadMoreMessages();
    }
  }

  void _onMessageTextChanged() {
    // Send typing indicator
    if (messageController.text.isNotEmpty && chatId != null) {
      _sendTypingIndicator(true);

      // Cancel previous timer
      _typingTimer?.cancel();

      // Stop typing after 3 seconds of inactivity
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _sendTypingIndicator(false);
      });
    } else {
      _sendTypingIndicator(false);
    }
  }

  void _sendTypingIndicator(bool isTyping) {
    if (chatId != null) {
      try {
        _socketService?.sendTyping(chatId!, isTyping);
      } catch (e) {}
    }
  }

  Future<void> loadChatData() async {
    if (chatId == null) return;

    final response = await _chatService.getChatDetails(chatId!);

    if (response.isSuccess && response.data != null) {
      _chat.value = response.data;

      // Get current user ID from chat participants
      final customerParticipant = response.data!.participants?.firstWhere(
        (p) => p.role == 'customer',
        orElse: () => Participant(),
      );
      currentUserId = customerParticipant?.user?.id;
    }
  }

  Future<void> loadMessages({bool showLoading = true}) async {
    if (chatId == null) return;

    if (showLoading) {
      _isLoading.value = true;
    }

    _currentPage = 1;

    final response = await _chatService.getChatMessages(
      chatId!,
      page: _currentPage,
      limit: _pageLimit,
    );

    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      // Reverse messages so newest is first (for reversed ListView)
      final messages = response.data!.messages ?? [];
      _messages.value = messages.reversed.toList();
      _hasMore.value = response.data!.hasMore ?? false;

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } else {
      Get.snackbar(
        'Error',
        'Failed to load messages',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadMoreMessages() async {
    if (chatId == null || !_hasMore.value || _isLoadingMore.value) return;

    _isLoadingMore.value = true;
    _currentPage++;

    final response = await _chatService.getChatMessages(
      chatId!,
      page: _currentPage,
      limit: _pageLimit,
    );

    _isLoadingMore.value = false;

    if (response.isSuccess && response.data != null) {
      final newMessages = response.data!.messages ?? [];
      // Reverse and add older messages to the end (for reversed ListView)
      _messages.addAll(newMessages.reversed.toList());
      _hasMore.value = response.data!.hasMore ?? false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || chatId == null) return;

    // Stop typing indicator
    _sendTypingIndicator(false);
    _typingTimer?.cancel();

    _isSending.value = true;

    // Create optimistic message
    final tempMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      chat: chatId,
      sender: MessageSender(id: currentUserId, name: 'You', role: 'customer'),
      content: MessageContent(text: text, type: 'text'),
      status: 'sending',
      delivery: MessageDelivery(sentAt: DateTime.now()),
      createdAt: DateTime.now(),
    );

    // Add to list immediately (optimistic UI)
    _addMessageToList(tempMessage);

    // Clear input
    messageController.clear();

    // Scroll to bottom
    _scrollToBottom();

    // Send to server
    final response = await _chatService.sendMessage(
      chatId!,
      text: text,
      type: 'text',
    );

    _isSending.value = false;

    if (response.isSuccess && response.data != null) {
      // Replace temp message with real one
      final index = _messages.indexWhere((m) => m.id == tempMessage.id);
      if (index != -1) {
        _messages[index] = response.data!;
        _messages.refresh();
      }
    } else {
      // Remove temp message and show error
      _messages.removeWhere((m) => m.id == tempMessage.id);

      Get.snackbar(
        'Error',
        'Failed to send message. ${response.error}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () {
            messageController.text = text;
          },
          child: const Text(
            'Retry',
            style: TextStyle(color: Color(0xFFD4AF37)),
          ),
        ),
      );
    }
  }

  void _addMessageToList(ChatMessage message) {
    // Check if message already exists
    final exists = _messages.any(
      (m) => m.id == message.id || m.messageId == message.messageId,
    );

    if (!exists) {
      _messages.insert(0, message); // Insert at beginning (newest first)
    } else {}
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> closeChat({String? feedback, int? rating}) async {
    if (chatId == null) return;

    final response = await _chatService.closeChat(
      chatId!,
      feedback: feedback,
      rating: rating,
    );

    if (response.isSuccess) {
      Get.back();

      Get.snackbar(
        'Success',
        'Chat closed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD4AF37),
        colorText: Colors.black,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to close chat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  void showCloseChatDialog() {
    int? selectedRating;
    final feedbackController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Close Chat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 20),

              // Rating
              const Text(
                'Rate your experience',
                style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final star = index + 1;
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = star;
                          });
                        },
                        icon: Icon(
                          selectedRating != null && star <= selectedRating!
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFD4AF37),
                          size: 32,
                        ),
                      );
                    }),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Feedback
              TextField(
                controller: feedbackController,
                maxLines: 3,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: 'Share your feedback (optional)',
                  hintStyle: const TextStyle(color: Color(0xFF606060)),
                  filled: true,
                  fillColor: const Color(0xFF0A0A0A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF808080),
                        side: const BorderSide(color: Color(0xFF2A2A2A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        closeChat(
                          rating: selectedRating,
                          feedback: feedbackController.text.trim().isNotEmpty
                              ? feedbackController.text.trim()
                              : null,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Close Chat',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    // Cancel all workers
    _newMessageWorker?.dispose();
    _typingWorker?.dispose();
    _assignedWorker?.dispose();
    _closedWorker?.dispose();
    _receiptWorker?.dispose();

    // Leave chat room
    if (chatId != null) {
      try {
        _socketService?.leaveChat(chatId!);
      } catch (e) {}
    }

    // Stop typing indicator
    _sendTypingIndicator(false);
    _typingTimer?.cancel();

    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
