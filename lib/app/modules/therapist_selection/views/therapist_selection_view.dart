import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/therapist_selection_controller.dart';
import '../../../data/services/booking_discovery_service.dart';
import '../../../../l10n/app_localizations.dart';

class TherapistSelectionView extends GetView<TherapistSelectionController> {
  const TherapistSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
          onPressed: () => controller.goBack(),
        ),
        title: Obx(() {
          // NEW ORDER: No selection -> Therapist -> Date -> Time
          if (controller.selectedSlot != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.confirmBooking,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (controller.store != null)
                  Text(
                    controller.store!.name ?? '',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          } else if (controller.selectedDate != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectTime,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (controller.store != null)
                  Text(
                    controller.store!.name ?? '',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          } else if (controller.selectedTherapist != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectDate,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (controller.store != null)
                  Text(
                    controller.store!.name ?? '',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectTherapist,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (controller.store != null)
                  Text(
                    controller.store!.name ?? '',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          }
        }),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
            ),
          );
        }

        // NEW ORDER: Therapist List -> Date -> Time -> Confirmation
        if (controller.selectedSlot != null) {
          return _buildBookingConfirmation();
        }
        if (controller.selectedDate != null) {
          return _buildTimeSlotSelection();
        }
        if (controller.selectedTherapist != null) {
          // Show calendar filtered by therapist
          if (controller.availabilityCalendar.isEmpty) {
            return Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      l10n.noAvailabilityForTherapist,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          }
          return _buildDateSelection();
        }

        // Default: Show therapist list
        return _buildTherapistList();
      }),
    );
  }

  Widget _buildDateSelection() {
    final availability = controller.availabilityCalendar;
    if (availability.isEmpty) return const SizedBox();

    // Create a map of dates to availability info
    final availabilityMap = <DateTime, DayAvailability>{};
    DateTime? firstAvailable;
    DateTime? lastAvailable;

    for (var day in availability) {
      if (day.date != null && (day.totalAvailableSlots ?? 0) > 0) {
        final dateStr = day.date!;
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          final date = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          availabilityMap[date] = day;

          if (firstAvailable == null) firstAvailable = date;
          lastAvailable = date;
        }
      }
    }

    final focusedDay = firstAvailable ?? DateTime.now();
    final firstDay = firstAvailable ?? DateTime.now();
    final lastDay = lastAvailable ?? DateTime.now().add(Duration(days: 60));

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Legend
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(l10n.available, const Color(0xFFD4AF37)),
                    const SizedBox(width: 24),
                    _buildLegendItem(l10n.notAvailableLabel, Colors.white24),
                  ],
                ),
              ),

              // Calendar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFF2A2A2A)),
                ),
                child: TableCalendar(
                  firstDay: firstDay,
                  lastDay: lastDay,
                  focusedDay: focusedDay,
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  selectedDayPredicate: (day) => false,
                  onDaySelected: (selectedDay, focusedDay) {
                    final normalizedDay = DateTime(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                    );
                    final dayAvailability = availabilityMap[normalizedDay];
                    if (dayAvailability != null) {
                      controller.selectDate(dayAvailability);
                    }
                  },
                  calendarStyle: const CalendarStyle(
                    // Today
                    todayDecoration: BoxDecoration(
                      color: Color(0x4DD4AF37),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),

                    // Default days
                    defaultTextStyle: TextStyle(color: Colors.white70),
                    weekendTextStyle: TextStyle(color: Colors.white70),

                    // Outside days (other months)
                    outsideTextStyle: TextStyle(color: Colors.white24),

                    // Disabled days
                    disabledTextStyle: TextStyle(color: Colors.white24),

                    // Remove default decorations
                    defaultDecoration: BoxDecoration(),
                    weekendDecoration: BoxDecoration(),
                    outsideDecoration: BoxDecoration(),
                    disabledDecoration: BoxDecoration(),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(
                        day.year,
                        day.month,
                        day.day,
                      );
                      final dayAvailability = availabilityMap[normalizedDay];
                      final isAvailable =
                          dayAvailability != null &&
                          (dayAvailability.totalAvailableSlots ?? 0) > 0;

                      return Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? Color(0xFFD4AF37).withValues(alpha: 0.2)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: isAvailable
                              ? Border.all(color: Color(0xFFD4AF37), width: 1)
                              : null,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isAvailable
                                      ? Colors.white
                                      : Colors.white38,
                                  fontWeight: isAvailable
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              if (isAvailable) ...[
                                SizedBox(height: 2),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD4AF37),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(
                        day.year,
                        day.month,
                        day.day,
                      );
                      final dayAvailability = availabilityMap[normalizedDay];
                      final isAvailable =
                          dayAvailability != null &&
                          (dayAvailability.totalAvailableSlots ?? 0) > 0;

                      return Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? Color(0xFFD4AF37).withValues(alpha: 0.3)
                              : Color(0xFF2A2A2A),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isAvailable
                                ? Color(0xFFD4AF37)
                                : Colors.white38,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isAvailable) ...[
                                SizedBox(height: 2),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD4AF37),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Color(0xFFD4AF37),
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Color(0xFFD4AF37),
                    ),
                    headerPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  enabledDayPredicate: (day) {
                    final normalizedDay = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    );
                    final dayAvailability = availabilityMap[normalizedDay];
                    return dayAvailability != null &&
                        (dayAvailability.totalAvailableSlots ?? 0) > 0;
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Instruction text
              Center(
                child: Text(
                  l10n.tapHighlightedDate,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1),
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    final selectedDay = controller.selectedDate;
    if (selectedDay == null) return const SizedBox();
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1A1A1A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedDay.displayDate ?? '',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.slotsAvailable(selectedDay.totalAvailableSlots ?? 0),
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: selectedDay.slotDetails?.length ?? 0,
                itemBuilder: (context, index) {
                  final slot = selectedDay.slotDetails![index];
                  if ((slot.therapists?.length ?? 0) == 0) {
                    return const SizedBox();
                  }
                  return Card(
                    color: const Color(0xFF1A1A1A),
                    child: InkWell(
                      onTap: () => controller.selectSlot(slot),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Center(
                          child: Text(
                            slot.time ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  } // OLD METHOD REMOVED - using _buildBookingConfirmation below instead

  /// NEW: Show therapist list first
  Widget _buildTherapistList() {
    if (controller.availableTherapists.isEmpty) {
      return Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                l10n.noTherapistsAvailable,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.availableTherapists.length,
      itemBuilder: (context, index) {
        final l10n = AppLocalizations.of(context)!;
        final therapist = controller.availableTherapists[index];
        return Card(
          color: const Color(0xFF1A1A1A),
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => controller.selectTherapist(therapist),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFFD4AF37),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          therapist.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFD4AF37),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (therapist.rating ?? 0.0).toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            if (therapist.isVerified) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF4CAF50),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.verified,
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (therapist.specializations.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            therapist.specializations.take(2).join(', '),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFD4AF37),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Rename: _buildTherapistConfirmation -> _buildBookingConfirmation
  Widget _buildBookingConfirmation() {
    final selectedDate = controller.selectedDate;
    final selectedSlot = controller.selectedSlot;
    final selectedTherapist = controller.selectedTherapist;
    if (selectedDate == null ||
        selectedSlot == null ||
        selectedTherapist == null) {
      return const SizedBox();
    }
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bookingSummary,
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: const Color(0xFF1A1A1A),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFD4AF37),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.dateAndTime,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              selectedDate.displayDate ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              selectedSlot.time ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: const Color(0xFF1A1A1A),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color(0xFFD4AF37),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.yourTherapist,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              selectedTherapist.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFD4AF37),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  (selectedTherapist.rating ?? 0.0)
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1A1A1A),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.proceedToBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.proceedToBooking,
                      style: const TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
