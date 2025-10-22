import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/booking_model.dart';
import '../controllers/review_controller.dart';

class WriteReviewView extends GetView<ReviewController> {
  const WriteReviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Booking booking = Get.arguments as Booking;

    return _WriteReviewForm(booking: booking);
  }
}

class _WriteReviewForm extends StatefulWidget {
  final Booking booking;

  const _WriteReviewForm({required this.booking});

  @override
  State<_WriteReviewForm> createState() => _WriteReviewFormState();
}

class _WriteReviewFormState extends State<_WriteReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _prosController = TextEditingController();
  final _consController = TextEditingController();

  // Rating values (1-5)
  double _overallRating = 5;
  double _techniqueRating = 5;
  double _professionalismRating = 5;
  double _cleanlinessRating = 5;
  double _comfortRating = 5;
  double _valueRating = 5;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _prosController.dispose();
    _consController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<ReviewController>();

      final ratings = {
        'overall': _overallRating.toInt(),
        'technique': _techniqueRating.toInt(),
        'professionalism': _professionalismRating.toInt(),
        'cleanliness': _cleanlinessRating.toInt(),
        'comfort': _comfortRating.toInt(),
        'valueForMoney': _valueRating.toInt(),
      };

      final pros = _prosController.text.trim().isNotEmpty
          ? _prosController.text.split(',').map((e) => e.trim()).toList()
          : null;

      final cons = _consController.text.trim().isNotEmpty
          ? _consController.text.split(',').map((e) => e.trim()).toList()
          : null;

      controller.submitReview(
        booking: widget.booking,
        ratings: ratings,
        content: _contentController.text.trim(),
        title: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        pros: pros,
        cons: cons,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFE0E0E0)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Write Review',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Info Card
              _buildBookingInfo(),
              const SizedBox(height: 24),

              // Overall Rating
              _buildOverallRating(),
              const SizedBox(height: 24),

              // Detailed Ratings
              _buildDetailedRatings(),
              const SizedBox(height: 24),

              // Review Title
              _buildTextField(
                controller: _titleController,
                label: 'Title (Optional)',
                hint: 'e.g., Amazing Experience!',
                maxLength: 100,
              ),
              const SizedBox(height: 16),

              // Review Content
              _buildTextField(
                controller: _contentController,
                label: 'Your Review',
                hint: 'Share your experience...',
                maxLines: 5,
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please write your review';
                  }
                  if (value.trim().length < 10) {
                    return 'Review must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pros
              _buildTextField(
                controller: _prosController,
                label: 'What was good? (Optional)',
                hint: 'Professional, Clean, Relaxing (comma separated)',
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Cons
              _buildTextField(
                controller: _consController,
                label: 'What could improve? (Optional)',
                hint: 'Parking, Wait time (comma separated)',
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // Submit Button
              GetX<ReviewController>(
                builder: (ctrl) => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: ctrl.isSubmitting ? null : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      disabledBackgroundColor: const Color(
                        0xFFD4AF37,
                      ).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: ctrl.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFF0A0A0A),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Review',
                            style: TextStyle(
                              color: Color(0xFF0A0A0A),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.spa,
                  color: Color(0xFFD4AF37),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.booking.service?.name ?? 'Service',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.booking.therapist?.name ?? 'Therapist',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF808080),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: Color(0xFF808080),
              ),
              const SizedBox(width: 6),
              Text(
                widget.booking.date != null
                    ? DateFormat('MMM dd, yyyy').format(widget.booking.date!)
                    : 'Date',
                style: const TextStyle(fontSize: 13, color: Color(0xFF808080)),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Color(0xFF808080)),
              const SizedBox(width: 6),
              Text(
                widget.booking.startTime ?? 'Time',
                style: const TextStyle(fontSize: 13, color: Color(0xFF808080)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRating() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          const Text(
            'Overall Rating',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 16),
          // Large rating number
          Text(
            _overallRating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD4AF37),
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          // Horizontal interactive stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() => _overallRating = (index + 1).toDouble());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _overallRating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: const Color(0xFFD4AF37),
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Helper text
          Text(
            'Tap stars or use slider to rate',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          // Slider for fine-tuning
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFD4AF37),
              inactiveTrackColor: const Color(0xFF2A2A2A),
              thumbColor: const Color(0xFFD4AF37),
              overlayColor: const Color(0xFFD4AF37).withOpacity(0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _overallRating,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                setState(() => _overallRating = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedRatings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Ratings',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 16),
          _buildRatingSlider(
            'Technique',
            _techniqueRating,
            (value) => setState(() => _techniqueRating = value),
          ),
          _buildRatingSlider(
            'Professionalism',
            _professionalismRating,
            (value) => setState(() => _professionalismRating = value),
          ),
          _buildRatingSlider(
            'Cleanliness',
            _cleanlinessRating,
            (value) => setState(() => _cleanlinessRating = value),
          ),
          _buildRatingSlider(
            'Comfort',
            _comfortRating,
            (value) => setState(() => _comfortRating = value),
          ),
          _buildRatingSlider(
            'Value for Money',
            _valueRating,
            (value) => setState(() => _valueRating = value),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Color(0xFFE0E0E0)),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < value ? Icons.star : Icons.star_border,
                    color: const Color(0xFFD4AF37),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            activeColor: const Color(0xFFD4AF37),
            inactiveColor: const Color(0xFF2A2A2A),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE0E0E0),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Color(0xFFE0E0E0)),
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF606060)),
            filled: true,
            fillColor: const Color(0xFF0A0A0A),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 2),
            ),
            counterStyle: const TextStyle(color: Color(0xFF808080)),
          ),
        ),
      ],
    );
  }
}
