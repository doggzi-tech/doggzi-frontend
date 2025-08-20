import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderCancelledPage extends StatelessWidget {
  const OrderCancelledPage({super.key});

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
                      color: AppColors.orange500,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Lottie.asset('assets/lottie/cancelled.json',width:double.infinity,height:double.infinity,fit: BoxFit.contain)),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    'Oops!',
                    style: TextStyles.h1,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'ORDER CANCELLED',
                    style: TextStyles.h2,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your order has been cancelled.',
                    style: TextStyles.actionL,
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        Get.offAllNamed('/main-page'); // Adjust route
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
