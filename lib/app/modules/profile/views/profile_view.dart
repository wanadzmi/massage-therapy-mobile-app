import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Color(0xFFD4AF37),
                size: 18,
              ),
            ),
            onPressed: () => controller.editProfile(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Profile Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4AF37),
                        width: 2,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD4AF37).withOpacity(0.3),
                          const Color(0xFFD4AF37).withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Text(
                      controller.userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => Text(
                      controller.userEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF808080),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('12', 'Bookings')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('4.8', 'Rating')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('2', 'Years')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF808080),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Account Options
            _buildMenuOption(
              'Personal Information',
              'Update your personal details',
              Icons.person_outline,
              () => controller.editProfile(),
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              'Booking History',
              'View all your past bookings',
              Icons.receipt_long_outlined,
              () => controller.viewBookingHistory(),
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              'Payment Methods',
              'Manage your payment options',
              Icons.credit_card_outlined,
              () {
                Get.snackbar(
                  'Payment Methods',
                  'Payment methods coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1E1E1E),
                  colorText: const Color(0xFFE0E0E0),
                );
              },
            ),

            const SizedBox(height: 32),

            const Text(
              'Preferences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF808080),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            _buildMenuOption(
              'Notifications',
              'Manage notification settings',
              Icons.notifications_outlined,
              () {
                Get.snackbar(
                  'Notifications',
                  'Notification settings coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1E1E1E),
                  colorText: const Color(0xFFE0E0E0),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              'Language',
              'English',
              Icons.language_outlined,
              () {
                Get.snackbar(
                  'Language',
                  'Language settings coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1E1E1E),
                  colorText: const Color(0xFFE0E0E0),
                );
              },
            ),

            const SizedBox(height: 32),

            const Text(
              'Support',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF808080),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            _buildMenuOption(
              'Help Center',
              'Get help with any issues',
              Icons.help_outline,
              () {
                Get.snackbar(
                  'Help Center',
                  'Help center coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1E1E1E),
                  colorText: const Color(0xFFE0E0E0),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              'Contact Support',
              'Reach out to our support team',
              Icons.headset_mic_outlined,
              () {
                Get.snackbar(
                  'Contact Support',
                  'Email: support@therapymassage.com\nPhone: +1 234 567 890',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1E1E1E),
                  colorText: const Color(0xFFE0E0E0),
                  duration: const Duration(seconds: 4),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              'Terms & Privacy',
              'Read our terms and privacy policy',
              Icons.description_outlined,
              () {
                Get.snackbar(
                  'Terms & Privacy',
                  'Terms and privacy policy coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1E1E1E),
                  colorText: const Color(0xFFE0E0E0),
                );
              },
            ),

            const SizedBox(height: 32),

            // Logout Button
            GestureDetector(
              onTap: () => controller.logout(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12, color: const Color(0xFF606060)),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF808080)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFD4AF37), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF808080),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF606060),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
