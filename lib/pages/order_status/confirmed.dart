import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200.w,
                    height: 200.w,
                    decoration: const BoxDecoration(
                      color: AppColors.orange400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: AppColors.lightGrey400),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    'Thank You !',
                    style: TextStyles.h1,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'ORDER CONFIRMED',
                    style: TextStyles.h2,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Thank You For Confirming Your Order.',
                    style: TextStyles.actionL,
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        Get.offAllNamed('/main-page'); // Adjust route as needed
                      },
                      child: Text(
                        'Continue Shopping',
                        style: TextStyles.actionL.copyWith(
                          color: AppColors.lightGrey100,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
