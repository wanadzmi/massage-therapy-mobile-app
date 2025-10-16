import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _selectedDay = Rx<DateTime?>(DateTime.now());
  final _focusedDay = DateTime.now().obs;
  final _calendarFormat = CalendarFormat.month.obs;

  // Mock appointments data
  final _appointments = <DateTime, List<Map<String, dynamic>>>{};
  final _selectedDayAppointments = <Map<String, dynamic>>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  DateTime? get selectedDay => _selectedDay.value;
  DateTime get focusedDay => _focusedDay.value;
  CalendarFormat get calendarFormat => _calendarFormat.value;
  List<Map<String, dynamic>> get selectedDayAppointments =>
      _selectedDayAppointments;

  @override
  void onInit() {
    super.onInit();
    _loadMockAppointments();
    _updateSelectedDayAppointments();
  }

  void _loadMockAppointments() {
    // Mock data - replace with API call later
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    _appointments[DateTime(today.year, today.month, today.day)] = [
      {
        'service': 'Swedish Massage',
        'time': '10:00 AM',
        'therapist': 'Sarah Johnson',
        'location': 'Main Branch',
        'status': 'confirmed',
      },
      {
        'service': 'Deep Tissue Massage',
        'time': '2:00 PM',
        'therapist': 'Mike Chen',
        'location': 'Home Service',
        'status': 'pending',
      },
    ];

    _appointments[DateTime(tomorrow.year, tomorrow.month, tomorrow.day)] = [
      {
        'service': 'Hot Stone Massage',
        'time': '11:00 AM',
        'therapist': 'Emma Wilson',
        'location': 'Spa Center',
        'status': 'confirmed',
      },
    ];
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _appointments[key] ?? [];
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay.value = selectedDay;
    _focusedDay.value = focusedDay;
    _updateSelectedDayAppointments();
  }

  void onFormatChanged(CalendarFormat format) {
    _calendarFormat.value = format;
  }

  void _updateSelectedDayAppointments() {
    if (_selectedDay.value != null) {
      _selectedDayAppointments.value = getEventsForDay(_selectedDay.value!);
    }
  }
}
