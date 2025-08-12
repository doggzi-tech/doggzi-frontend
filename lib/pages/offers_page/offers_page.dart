import 'package:doggzi/controllers/promo_code_controller.dart';
import 'package:doggzi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math';

class OffersPage extends GetView<PromoCodeController> {
  const OffersPage({super.key});

  // Define attractive gradient colors suitable for offers
  static const List<List<Color>> offerGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)], // Red to Orange
    [Color(0xFF4ECDC4), Color(0xFF44A08D)], // Teal to Green
    [Color(0xFF45B7D1), Color(0xFF96C93D)], // Blue to Green
    [Color(0xFFFF9A9E), Color(0xFFFECFEF)], // Pink to Light Pink
    [Color(0xFFA18CD1), Color(0xFFFBC2EB)], // Purple to Pink
    [Color(0xFFFAD0C4), Color(0xFFFFD1FF)], // Peach to Pink
    [Color(0xFFFEC163), Color(0xFFDE4313)], // Yellow to Red
    [Color(0xFFBBE4E8), Color(0xFF92F3EC)], // Light Blue to Mint
    [Color(0xFFFF8A80), Color(0xFFFF80AB)], // Light Red to Pink
    [Color(0xFF81C784), Color(0xFF66BB6A)], // Light Green to Green
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const CustomAppBar(
            title: "Offers",
            showBackButton: true,
          ),
          Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.offers.isEmpty
                    ? const Center(child: Text("No offers available"))
                    : _buildOffersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.builder(
          itemCount: controller.offers.length,
          itemBuilder: (context, index) {
            final offer = controller.offers[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildOfferCard(offer, index),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOfferCard(dynamic offer, int index) {
    // Get a consistent random gradient for each offer based on index
    final gradientIndex = index % offerGradients.length;
    final gradient = offerGradients[gradientIndex];

    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            right: -20.w,
            top: -20.h,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 10.w,
            bottom: -10.h,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Left side content
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        offer.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      // Promo code container with copy functionality
                      GestureDetector(
                        onTap: () => _copyPromoCode(offer.code),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                offer.code,
                                style: TextStyle(
                                  color: const Color(0xFF1A365D),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.copy,
                                size: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side - Discount badge
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2.w,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Star/burst shape background
                            Center(
                              child: CustomPaint(
                                size: Size(80.w, 80.h),
                                painter: StarBurstPainter(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                            // Percentage icon
                            Center(
                              child: Icon(
                                Icons.percent,
                                color: Colors.black,
                                size: 24.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to copy promo code to clipboard
  void _copyPromoCode(String promoCode) async {
    await Clipboard.setData(ClipboardData(text: promoCode));
    // Show success snackbar
    Get.snackbar(
      "Copied!",
      "Promo code '$promoCode' copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
      borderRadius: 8.r,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    );
  }
}

// Custom painter for star burst shape
class StarBurstPainter extends CustomPainter {
  final Color color;

  StarBurstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    final path = Path();
    const numberOfPoints = 12;
    const angle = 2 * pi / numberOfPoints;

    for (int i = 0; i < numberOfPoints; i++) {
      final currentAngle = i * angle;
      final isOuter = i % 2 == 0;
      final currentRadius = isOuter ? radius : radius * 0.6;

      final x = center.dx + cos(currentAngle) * currentRadius;
      final y = center.dy + sin(currentAngle) * currentRadius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
