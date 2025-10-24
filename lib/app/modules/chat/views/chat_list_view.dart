import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../data/models/chat_model.dart';
import '../controllers/chat_list_controller.dart';
import '../controllers/chat_create_controller.dart';
import '../views/chat_create_view.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.messages,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Color(0xFFD4AF37), size: 20),
            ),
            onPressed: () async {
              // Navigate to create chat and refresh list when returning
              await Get.to(
                () => const ChatCreateView(),
                binding: BindingsBuilder(() {
                  Get.lazyPut(() => ChatCreateController());
                }),
              );
              // Refresh chat list when returning
              controller.refreshChats();
            },
            tooltip: AppLocalizations.of(context)!.newChat,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          _buildFilterTabs(context),

          // Chat List
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.chats.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                );
              }

              if (controller.chats.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                color: const Color(0xFFD4AF37),
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: controller.refreshChats,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      controller.chats.length + (controller.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.chats.length) {
                      // Load more indicator
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Obx(
                            () => controller.isLoadingMore
                                ? const CircularProgressIndicator(
                                    color: Color(0xFFD4AF37),
                                  )
                                : TextButton(
                                    onPressed: controller.loadMoreChats,
                                    child: Text(
                                      AppLocalizations.of(context)!.loadMore,
                                      style: const TextStyle(
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }

                    final chat = controller.chats[index];
                    return _buildChatCard(context, chat);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Obx(() => _buildFilterChip(l10n.all, 'all')),
          const SizedBox(width: 8),
          Obx(() => _buildFilterChip(l10n.active, 'active')),
          const SizedBox(width: 8),
          Obx(() => _buildFilterChip(l10n.closed, 'closed')),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = controller.selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.filterByStatus(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4AF37).withValues(alpha: 0.15)
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF808080),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, chat) {
    final l10n = AppLocalizations.of(context)!;
    final lastMessage = chat.lastMessage;

    // Find agent participant, or fallback to customer (first participant)
    Participant? participant;
    if (chat.participants != null && chat.participants!.isNotEmpty) {
      try {
        participant = chat.participants!.firstWhere((p) => p.role == 'agent');
      } catch (e) {
        // No agent found, use first participant (customer)
        participant = chat.participants!.first;
      }
    }

    return GestureDetector(
      onTap: () => controller.openChat(chat),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                participant?.role == 'agent'
                    ? Icons.support_agent
                    : Icons.person,
                color: const Color(0xFFD4AF37),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Chat Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name
                      Expanded(
                        child: Text(
                          participant?.user?.name ?? l10n.supportChat,
                          style: const TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Time
                      Text(
                        controller.formatLastMessageTime(
                          lastMessage?.sentAt != null
                              ? DateTime.tryParse(lastMessage!.sentAt!)
                              : null,
                        ),
                        style: const TextStyle(
                          color: Color(0xFF606060),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Subject or Last Message
                  if (chat.subject != null && chat.subject!.isNotEmpty)
                    Text(
                      chat.subject!,
                      style: const TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (lastMessage?.text != null)
                    Text(
                      lastMessage!.text!,
                      style: const TextStyle(
                        color: Color(0xFF707070),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),

                  // Status and Category
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: controller
                              .getChatStatusColor(chat.status)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          controller.getChatStatusText(chat.status),
                          style: TextStyle(
                            color: controller.getChatStatusColor(chat.status),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Category Badge
                      if (chat.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(chat.category),
                                size: 10,
                                color: const Color(0xFF808080),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatCategoryName(chat.category!),
                                style: const TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
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
              size: 64,
              color: Color(0xFF404040),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noConversationsYet,
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.startNewChatToGetSupport,
            style: const TextStyle(color: Color(0xFF808080), fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              // Navigate to create chat and refresh list when returning
              await Get.to(
                () => const ChatCreateView(),
                binding: BindingsBuilder(() {
                  Get.lazyPut(() => ChatCreateController());
                }),
              );
              // Refresh chat list when returning
              controller.refreshChats();
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.startNewChat),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'general':
        return Icons.help_outline;
      case 'booking':
        return Icons.calendar_today;
      case 'payment':
        return Icons.payment;
      case 'service':
        return Icons.spa;
      case 'technical':
        return Icons.build;
      default:
        return Icons.chat;
    }
  }

  String _formatCategoryName(String category) {
    if (category.isEmpty) return category;
    return category[0].toUpperCase() + category.substring(1).toLowerCase();
  }
}
