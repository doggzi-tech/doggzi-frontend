import 'package:flutter/material.dart';
import 'package:doggzi/widgets/custom_app_bar.dart';
import '../../theme/text_style.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: [
            const CustomAppBar(
              title: 'PRIVACY POLICY',
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protecting our Privacy is a top priority at Doggzi. We understand that you entrust us with your personal information, and we take that responsibility seriously.\n',
                      style: TextStyles.bodyM,
                    ),
                    Text(
                      'Here’s a summary of how we handle your data:\n',
                      style: TextStyles.bodyM,
                    ),
                    Text(
                      '1. What We Collect: Name, address, email, phone number, pet details, and payment info.\n'
                      '2. Why We Collect It: To process orders, manage subscriptions, and improve user experience.\n'
                      '3. Data Sharing: We do not sell your data. Limited sharing occurs only with delivery and payment partners.\n'
                      '4. Security: Your information is protected with encryption and secure servers.\n'
                      '5. Cookies: We use cookies to personalize your experience.\n'
                      '6. Your Rights: You can request, update, or delete your personal information at any time.\n',
                      style: TextStyles.bodyM,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'If you have any questions or concerns regarding our Privacy practices, please do not hesitate to contact us. '
                      'Your trust and satisfaction is important to us, and we will do everything we can to protect your privacy and ensure peace of mind.\n',
                      style: TextStyles.bodyM,
                    ),
                    Text(
                      'For privacy-related concerns, email us at [privacy@Doggzi.com].',
                      style: TextStyles.bodyM,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
