import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final controller = Get.find<ProfileController>();

  late final TextEditingController nameController;
  late final TextEditingController dateOfBirthController;

  late final Rx<String?> selectedGender;
  late final Rx<DateTime?> selectedDateOfBirth;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current profile data
    nameController = TextEditingController(text: controller.userName);
    dateOfBirthController = TextEditingController(
      text: controller.dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(controller.dateOfBirth!)
          : '',
    );

    selectedGender =
        (controller.gender.isNotEmpty ? controller.gender : null).obs;
    selectedDateOfBirth = controller.dateOfBirth.obs;
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          l10n.editProfile,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Information Section
                    _buildSectionTitle(l10n.personalInformation),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: nameController,
                      label: l10n.fullName,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      controller: dateOfBirthController,
                      label: l10n.dateOfBirth,
                      icon: Icons.calendar_today_outlined,
                      context: context,
                      selectedDate: selectedDateOfBirth,
                    ),
                    const SizedBox(height: 16),
                    _buildGenderDropdown(selectedGender, l10n),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.updateProfile(
                            name: nameController.text.trim().isEmpty
                                ? null
                                : nameController.text.trim(),
                            dateOfBirth: selectedDateOfBirth.value,
                            gender: selectedGender.value,
                          );
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.saveChanges,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFFD4AF37),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFFE0E0E0)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF808080)),
        prefixIcon: Icon(icon, color: Color(0xFF808080)),
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
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required BuildContext context,
    required Rx<DateTime?> selectedDate,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Color(0xFFE0E0E0)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF808080)),
        prefixIcon: Icon(icon, color: Color(0xFF808080)),
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
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
      ),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate.value ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFD4AF37),
                  onPrimary: Colors.black,
                  surface: Color(0xFF1A1A1A),
                  onSurface: Color(0xFFE0E0E0),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          selectedDate.value = pickedDate;
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }

  Widget _buildGenderDropdown(
    Rx<String?> selectedGender,
    AppLocalizations l10n,
  ) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedGender.value,
            hint: Text(
              l10n.selectGender,
              style: const TextStyle(color: Color(0xFF808080)),
            ),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF808080)),
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Color(0xFFE0E0E0)),
            items: [
              DropdownMenuItem(value: 'male', child: Text(l10n.male)),
              DropdownMenuItem(value: 'female', child: Text(l10n.female)),
              DropdownMenuItem(value: 'other', child: Text(l10n.other)),
            ],
            onChanged: (value) {
              selectedGender.value = value;
            },
          ),
        ),
      ),
    );
  }
}
