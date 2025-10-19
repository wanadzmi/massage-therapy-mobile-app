import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/chat_controller.dart';
import '../../../data/models/chat_model.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }

        return Column(
          children: [
            // Chat status banner (if closed)
            if (controller.chat?.status == 'closed')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                color: const Color(0xFF2A2A2A),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFF9800),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'This chat has been closed',
                        style: TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Messages Area
            Expanded(
              child: controller.messages.isEmpty
                  ? _buildEmptyState()
                  : _buildMessagesList(),
            ),

            // Typing Indicator
            if (controller.isTyping)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTypingDot(0),
                          const SizedBox(width: 4),
                          _buildTypingDot(1),
                          const SizedBox(width: 4),
                          _buildTypingDot(2),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Agent is typing...',
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            // Message Input Area
            if (controller.chat?.status != 'closed') _buildMessageInput(),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
        onPressed: () => Get.back(),
      ),
      title: Obx(() {
        final agent = controller.chat?.assignment?.assignedAgent;
        final agentName = agent?.name ?? 'Admin Support';
        final agentAvatar = agent?.avatar;

        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: agentAvatar != null
                  ? ClipOval(
                      child: Image.network(
                        agentAvatar,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.support_agent,
                          color: Color(0xFFD4AF37),
                          size: 20,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.support_agent,
                      color: Color(0xFFD4AF37),
                      size: 20,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agentName,
                    style: const TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    controller.chat?.status == 'active'
                        ? 'Online'
                        : controller.chat?.status == 'waiting'
                        ? 'Waiting for agent...'
                        : 'Offline',
                    style: const TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      actions: [
        if (controller.chat?.status != 'closed')
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFFE0E0E0)),
            color: const Color(0xFF1A1A1A),
            onSelected: (value) {
              if (value == 'close') {
                controller.showCloseChatDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'close',
                child: Row(
                  children: [
                    Icon(Icons.close, color: Color(0xFFFF5252), size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Close Chat',
                      style: TextStyle(color: Color(0xFFE0E0E0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2A2A2A), width: 2),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Start a Conversation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Send a message to our support team\nWe typically reply within a few minutes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF808080),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFFD4AF37),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Quick Tips',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Ask about bookings and services'),
                  const SizedBox(height: 8),
                  _buildTip('Get help with payments'),
                  const SizedBox(height: 8),
                  _buildTip('Report any issues'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: controller.scrollController,
      reverse: true, // Newest messages at bottom
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount:
          controller.messages.length + (controller.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (controller.isLoadingMore && index == controller.messages.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Color(0xFFD4AF37),
                strokeWidth: 2,
              ),
            ),
          );
        }

        final message = controller.messages[index];
        final isFromMe = message.isFromMe(controller.currentUserId ?? '');

        // Show date separator if needed
        final showDateSeparator = _shouldShowDateSeparator(index);

        return Column(
          children: [
            if (showDateSeparator) _buildDateSeparator(message.createdAt),
            _buildMessageBubble(message, isFromMe),
          ],
        );
      },
    );
  }

  bool _shouldShowDateSeparator(int index) {
    if (index == controller.messages.length - 1) return true;

    final currentMessage = controller.messages[index];
    final nextMessage = controller.messages[index + 1];

    if (currentMessage.createdAt == null || nextMessage.createdAt == null) {
      return false;
    }

    final currentDate = DateTime(
      currentMessage.createdAt!.year,
      currentMessage.createdAt!.month,
      currentMessage.createdAt!.day,
    );
    final nextDate = DateTime(
      nextMessage.createdAt!.year,
      nextMessage.createdAt!.month,
      nextMessage.createdAt!.day,
    );

    return !currentDate.isAtSameMomentAs(nextDate);
  }

  Widget _buildDateSeparator(DateTime? date) {
    if (date == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMM dd, yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFF2A2A2A))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              dateText,
              style: const TextStyle(
                color: Color(0xFF808080),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFF2A2A2A))),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isFromMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1A1A1A),
              backgroundImage: message.sender?.avatar != null
                  ? NetworkImage(message.sender!.avatar!)
                  : null,
              child: message.sender?.avatar == null
                  ? const Icon(
                      Icons.support_agent,
                      size: 16,
                      color: Color(0xFFD4AF37),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isFromMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isFromMe
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isFromMe ? 16 : 4),
                      bottomRight: Radius.circular(isFromMe ? 4 : 16),
                    ),
                    border: !isFromMe
                        ? Border.all(color: const Color(0xFF2A2A2A))
                        : null,
                  ),
                  child: Text(
                    message.content?.text ?? '',
                    style: TextStyle(
                      color: isFromMe ? Colors.black : const Color(0xFFE0E0E0),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatMessageTime(message.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF606060),
                        fontSize: 11,
                      ),
                    ),
                    if (isFromMe) ...[
                      const SizedBox(width: 4),
                      _buildMessageStatusIcon(message.status),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isFromMe) const SizedBox(width: 40), // Balance alignment
        ],
      ),
    );
  }

  Widget _buildMessageStatusIcon(String? status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'sending':
        icon = Icons.access_time;
        color = const Color(0xFF606060);
        break;
      case 'sent':
        icon = Icons.check;
        color = const Color(0xFF606060);
        break;
      case 'delivered':
        icon = Icons.done_all;
        color = const Color(0xFF606060);
        break;
      case 'read':
        icon = Icons.done_all;
        color = const Color(0xFF4CAF50);
        break;
      default:
        icon = Icons.error_outline;
        color = const Color(0xFFFF5252);
    }

    return Icon(icon, size: 12, color: color);
  }

  String _formatMessageTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('HH:mm').format(date);
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = ((value + delay) % 1.0);
        final opacity = 0.3 + (animValue * 0.7);

        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Color(0xFFD4AF37).withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: TextField(
                  controller: controller.messageController,
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Color(0xFF606060)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: controller.isSending
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: controller.isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4AF37),
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.black, size: 20),
                  onPressed: controller.isSending
                      ? null
                      : controller.sendMessage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
        ),
      ],
    );
  }
}
