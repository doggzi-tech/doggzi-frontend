import 'package:doggzi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: CustomAppBar(
                  title: 'TERMS OF SERVICE',
                  showBackButton: true,
                  isTrailingIconVisible: false,
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms of Service',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Thank you for using Doggzi. These Terms of Services (the “Terms”) are intended to make you aware of your legal rights and responsibilities with respect to your access and use of Doggzi.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Please read these Terms carefully. By accessing or using Doggzi platform, you are agreeing to these Terms and conditions. ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        ' 1. Eligibility: You must be 18+ to place orders. \n 2. Ordering & Payment: Orders can be placed through our platform. All prices are inclusive of applicable taxes. Payment must be made in advance. \n 3. Delivery: We aim for timely delivery. However, delays due to unforeseen events may occur. \n 4. Returns & Refunds: Perishable items are non-returnable. Refunds are processed only for incorrect or damaged deliveries. \n 5. Subscription Plans: If you choose a subscription, it will auto-renew unless cancelled before the next billing cycle. \n 6. Account Responsibility: You are responsible for maintaining your login credentials. \n 7. Modifications: We reserve the right to update these terms at any time.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'For questions, contact us at [support@yourdomain.com].',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      // We can make tos and pp dynamic if needed as client might want to change them..
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
