import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_create_controller.dart';

class ChatCreateView extends GetView<ChatCreateController> {
  const ChatCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Contact Support',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: Color(0xFFD4AF37),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How can we help?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'We typically respond within minutes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Category Selection
            const Text(
              'Select Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 12),

            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.categories.map((category) {
                  final isSelected =
                      controller.selectedCategory == category['value'];
                  return _buildCategoryChip(
                    category['label'] as String,
                    category['icon'] as IconData,
                    category['value'] as String,
                    isSelected,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Subject (Optional)
            const Text(
              'Subject (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.subjectController,
              style: const TextStyle(color: Color(0xFFE0E0E0)),
              decoration: InputDecoration(
                hintText: 'Brief subject line...',
                hintStyle: const TextStyle(color: Color(0xFF606060)),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
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
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 24),

            // Message (Required)
            Row(
              children: [
                const Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Required',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.messageController,
              style: const TextStyle(color: Color(0xFFE0E0E0)),
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                    'Describe your issue or question in detail...\n\nMinimum 10 characters',
                hintStyle: const TextStyle(color: Color(0xFF606060)),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
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
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFD4AF37), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Our support team will be notified immediately and will respond as soon as possible. You can view your conversation history in the chat screen.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE0E0E0),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Start Chat Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isCreating
                      ? null
                      : controller.createChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: const Color(0xFF2A2A2A),
                    disabledForegroundColor: const Color(0xFF606060),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: controller.isCreating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Start Chat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    IconData icon,
    String value,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => controller.setCategory(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFF2A2A2A),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.black : const Color(0xFF808080),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
