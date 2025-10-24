import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/otp_verification_controller.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../core/theme/app_colors.dart';

class OTPVerificationView extends GetView<OTPVerificationController> {
  const OTPVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
          onPressed: controller.navigateBack,
        ),
        title: const Text(
          'Verify Phone',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Icon
              _buildIcon(),
              const SizedBox(height: 32),

              // Header
              _buildHeader(),
              const SizedBox(height: 40),

              // OTP Input Fields
              _buildOTPFields(),
              const SizedBox(height: 32),

              // Resend OTP
              _buildResendSection(),
              const SizedBox(height: 40),

              // Verify Button
              _buildVerifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.phone_android,
        size: 64,
        color: Color(0xFFD4AF37),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Verify Your Phone',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE0E0E0),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'We\'ve sent a 6-digit code to\n${controller.phone ?? "your phone"}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF808080),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOTPField(controller.otp1Controller, controller.otp1Focus, 1),
        _buildOTPField(controller.otp2Controller, controller.otp2Focus, 2),
        _buildOTPField(controller.otp3Controller, controller.otp3Focus, 3),
        _buildOTPField(controller.otp4Controller, controller.otp4Focus, 4),
        _buildOTPField(controller.otp5Controller, controller.otp5Focus, 5),
        _buildOTPField(controller.otp6Controller, controller.otp6Focus, 6),
      ],
    );
  }

  Widget _buildOTPField(
    TextEditingController textController,
    FocusNode focusNode,
    int position,
  ) {
    return SizedBox(
      width: 45,
      height: 56,
      child: TextFormField(
        controller: textController,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
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
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (value) => controller.onOTPChanged(value, position),
      ),
    );
  }

  Widget _buildResendSection() {
    return Obx(() {
      if (controller.canResend) {
        return TextButton(
          onPressed: controller.resendOTP,
          child: const Text(
            'Resend OTP',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        return Text(
          'Resend OTP in ${controller.countdown}s',
          style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
        );
      }
    });
  }

  Widget _buildVerifyButton() {
    return Obx(
      () => CustomButton(
        text: 'Verify',
        onPressed: controller.isOTPComplete ? controller.verifyOTP : null,
        isLoading: controller.isLoading,
        backgroundColor: AppColors.primary,
        width: double.infinity,
        height: 56,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
