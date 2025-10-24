import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../controllers/register_controller.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../core/theme/app_colors.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
          onPressed: controller.navigateToLogin,
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Join Us Today',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your account to get started',
                style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 32),

              // Registration Form
              _buildRegistrationForm(),
              const SizedBox(height: 24),

              // Terms and Conditions
              _buildTermsCheckbox(),
              const SizedBox(height: 32),

              // Register Button
              _buildRegisterButton(),
              const SizedBox(height: 24),

              // Login Link
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        // Name Field
        _buildTextField(
          label: 'Full Name',
          controller: controller.nameController,
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          hintText: 'Enter your full name',
        ),
        const SizedBox(height: 20),

        // Phone Field with Country Selector
        _buildPhoneField(),
        const SizedBox(height: 20),

        // Email Field
        _buildTextField(
          label: 'Email',
          controller: controller.emailController,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: 'Enter your email',
        ),
        const SizedBox(height: 20),

        // Password Field
        Obx(
          () => _buildTextField(
            label: 'Password',
            controller: controller.passwordController,
            icon: Icons.lock_outlined,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            hintText: 'Enter your password',
            obscureText: !controller.isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFFD4AF37),
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Confirm Password Field
        Obx(
          () => _buildTextField(
            label: 'Confirm Password',
            controller: controller.confirmPasswordController,
            icon: Icons.lock_outlined,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            hintText: 'Confirm your password',
            obscureText: !controller.isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFFD4AF37),
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Referral Code Field (Optional)
        _buildTextField(
          label: 'Referral Code (Optional)',
          controller: controller.referralCodeController,
          icon: Icons.card_giftcard_outlined,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          hintText: 'Enter referral code',
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD4AF37),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          style: const TextStyle(color: Color(0xFFE0E0E0)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF808080)),
            prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)),
            suffixIcon: suffixIcon,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E)),
            ),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD4AF37),
          ),
        ),
        const SizedBox(height: 8),
        IntlPhoneField(
          controller: controller.phoneController,
          decoration: InputDecoration(
            hintText: '123456789',
            hintStyle: const TextStyle(color: Color(0xFF808080)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            counterText: '',
          ),
          style: const TextStyle(color: Color(0xFFE0E0E0)),
          dropdownTextStyle: const TextStyle(color: Color(0xFFE0E0E0)),
          dropdownIconPosition: IconPosition.trailing,
          initialCountryCode: 'MY',
          searchText: 'Search country',
          disableLengthCheck: true,
          onChanged: (phone) {
            controller.setCountryCode(phone.countryCode);
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: controller.agreeToTerms,
            onChanged: controller.toggleAgreeToTerms,
            activeColor: const Color(0xFFD4AF37),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  controller.toggleAgreeToTerms(!controller.agreeToTerms),
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0B0B0),
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: controller.navigateToTerms,
                          child: const Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFD4AF37),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Obx(
      () => CustomButton(
        text: 'Create Account',
        onPressed: controller.register,
        isLoading: controller.isLoading,
        backgroundColor: AppColors.primary,
        width: double.infinity,
        height: 56,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account? ',
            style: TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
          ),
          TextButton(
            onPressed: controller.navigateToLogin,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
