import 'package:doggzi/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/pet_controller.dart';
import '../../../theme/text_style.dart';
import '../../../widgets/custom_icon.dart';

class ProfileIntroItem extends GetView<PetController> {
  ProfileIntroItem({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/content.png'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () {
                final firstName = authController.user?.firstName;
                final lastName = authController.user?.lastName;

                final displayName = (firstName != null && lastName != null)
                    ? "$firstName $lastName"
                    : 'User Name';

                return Text(
                  displayName,
                  style: DoggziTextStyles.bold16,
                );
              },
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                controller.pets.isNotEmpty
                    ? '${controller.pets.length} Pets Added'
                    : 'No pets added',
                style: DoggziTextStyles.bodyText.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        CustomIcon(
          radius: 30,
          icon: Icons.edit,
          onTap: () {
            // Handle edit profile action
          },
        ),
      ],
    );
  }
}
