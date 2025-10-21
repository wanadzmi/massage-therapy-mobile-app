import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/views/home_view.dart';
import '../home/controllers/home_controller.dart';
import '../booking/views/booking_view.dart';
import '../booking/controllers/booking_controller.dart';
import '../profile/views/profile_view.dart';
import '../profile/controllers/profile_controller.dart';

class MainNavigationController extends GetxController {
  final currentIndex = 0.obs;

  final List<Widget> pages = [
    const HomeView(),
    const BookingView(),
    const ProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;

    // Refresh the respective controller when switching tabs
    _refreshCurrentPage(index);
  }

  void _refreshCurrentPage(int index) {
    try {
      switch (index) {
        case 0: // Home tab
          final homeController = Get.find<HomeController>();
          homeController.refresh();
          break;
        case 1: // Booking tab
          final bookingController = Get.find<BookingController>();
          bookingController.loadBookings(refresh: true);
          break;
        case 2: // Profile tab
          final profileController = Get.find<ProfileController>();
          profileController.refresh();
          break;
      }
    } catch (e) {
      // Controller not found, it's okay
      print('⚠️ Controller not found for tab $index: $e');
    }
  }
}
