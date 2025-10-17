import 'package:get/get.dart';

class BookingController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _appointments = <Map<String, dynamic>>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Map<String, dynamic>> get appointments => _appointments;

  @override
  void onInit() {
    super.onInit();
    _loadMockAppointments();
  }

  void _loadMockAppointments() {
    // Mock data - replace with API call later
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    _appointments.value = [
      {
        'service': 'Swedish Massage',
        'date': today,
        'time': '10:00 AM',
        'therapist': 'Sarah Johnson',
        'location': 'Main Branch',
        'status': 'confirmed',
      },
      {
        'service': 'Deep Tissue Massage',
        'date': today,
        'time': '2:00 PM',
        'therapist': 'Mike Chen',
        'location': 'Home Service',
        'status': 'pending',
      },
      {
        'service': 'Hot Stone Massage',
        'date': tomorrow,
        'time': '11:00 AM',
        'therapist': 'Emma Wilson',
        'location': 'Spa Center',
        'status': 'confirmed',
      },
      {
        'service': 'Aromatherapy Massage',
        'date': nextWeek,
        'time': '3:00 PM',
        'therapist': 'Lisa Anderson',
        'location': 'Downtown Branch',
        'status': 'cancelled',
      },
    ];
  }
}
