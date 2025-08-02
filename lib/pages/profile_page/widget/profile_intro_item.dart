import 'package:doggzi/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../../../controllers/pet_controller.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';

class ProfileIntroItem extends GetView<PetController> {
  ProfileIntroItem({super.key});

  final authController = Get.find<AuthController>();

  // Generate a random color
  Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  // Get initials from full name
  String _getInitials(String fullName) {
    List<String> nameParts = fullName.trim().split(' ');
    if (nameParts.isEmpty) return '';

    if (nameParts.length == 1) {
      return nameParts[0].isNotEmpty ? nameParts[0][0].toUpperCase() : '';
    } else {
      String firstInitial = nameParts[0].isNotEmpty ? nameParts[0][0] : '';
      String lastInitial = nameParts[nameParts.length - 1].isNotEmpty
          ? nameParts[nameParts.length - 1][0]
          : '';
      return (firstInitial + lastInitial).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () {
            return CircleAvatar(
              radius: 30.r,
              backgroundColor: _getRandomColor(),
              child: Text(
                _getInitials(authController.user!.fullName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () {
                return Text(
                  authController.user!.fullName,
                  style: TextStyles.bodyL,
                );
              },
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                controller.pets.isNotEmpty
                    ? '${controller.pets.length} Pets Added'
                    : 'No pets added',
                style: TextStyles.bodyM.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // Handle edit profile action
          },
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(
              color: AppColors.darkGrey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              FontAwesomeIcons.pen,
              color: AppColors.orange400,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
