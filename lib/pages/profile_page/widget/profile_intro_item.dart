import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_icon.dart';

class ProfileIntroItem extends StatelessWidget {
  const ProfileIntroItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/content.png'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Doe',
              style: DoggziTextStyles.bold16,
            ),
            const SizedBox(height: 4),
            Text(
              '2 pets added',
              style: DoggziTextStyles.bodyText.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
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
