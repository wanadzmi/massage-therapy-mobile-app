import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';

import '../controllers/login_controller.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/values/app_strings.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo and App Title
              _buildLogo(),
              const SizedBox(height: 40),

              // Welcome Message
              _buildWelcomeMessage(),
              const SizedBox(height: 40),

              // Login Form
              _buildLoginForm(),
              const SizedBox(height: 24),

              // Remember Me and Forgot Password
              _buildRememberAndForgot(),
              const SizedBox(height: 32),

              // Login Button
              _buildLoginButton(),
              const SizedBox(height: 24),

              // Sign Up Link
              _buildSignUpLink(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: const Icon(Icons.spa, size: 64, color: Color(0xFFD4AF37)),
    );
  }

  Widget _buildWelcomeMessage() {
    final l10n = AppLocalizations.of(Get.context!)!;
    return Column(
      children: [
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.pleaseSignIn,
          style: const TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Field
        Obx(() => _buildEmailField()),
        const SizedBox(height: 20),

        // Password Field
        Obx(() => _buildPasswordField()),
      ],
    );
  }

  Widget _buildEmailField() {
    final l10n = AppLocalizations.of(Get.context!)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.email,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD4AF37),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Color(0xFFE0E0E0)),
          decoration: InputDecoration(
            hintText: l10n.enterEmail,
            hintStyle: const TextStyle(color: Color(0xFF808080)),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Color(0xFFD4AF37),
            ),
            errorText: controller.emailError,
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

  Widget _buildPasswordField() {
    final l10n = AppLocalizations.of(Get.context!)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.password,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD4AF37),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => controller.login(),
          style: const TextStyle(color: Color(0xFFE0E0E0)),
          decoration: InputDecoration(
            hintText: l10n.enterPassword,
            hintStyle: const TextStyle(color: Color(0xFF808080)),
            prefixIcon: const Icon(
              Icons.lock_outlined,
              color: Color(0xFFD4AF37),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFFD4AF37),
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            errorText: controller.passwordError,
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

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        // Forgot Password
        TextButton(
          onPressed: controller.navigateToForgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    final l10n = AppLocalizations.of(Get.context!)!;
    return Obx(
      () => CustomButton(
        text: l10n.signIn,
        onPressed: controller.isFormValid ? controller.login : null,
        isLoading: controller.isLoading,
        backgroundColor: AppColors.primary,
        width: double.infinity,
        height: 56,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Don\'t have an account? ',
            style: TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
          ),
          TextButton(
            onPressed: () => Get.toNamed('/register'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Sign Up',
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
