


import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

void openAddressSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select An Address", style: TextStyles.actionL),
            SizedBox(height: 16.h),
            // Add Address Button
            InkWell(
              onTap: () {
                // TODO: Implement address add logic
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ZoomTapAnimation(
                  onTap: () {

                  },
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 20.sp),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text("Add Address",
                            style: TextStyles.captionM.copyWith(
                                color: AppColors.darkGrey500)),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16.sp, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Saved Address", style: TextStyles.captionL),
            ),
            SizedBox(height: 12.h),

            // Saved Address Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin,
                          color: Colors.green, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text("Delivers To",
                          style: TextStyles.captionM),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text("Flat No. 101, Lohegaon, Pune, 411001",
                      style: TextStyles.captionM.copyWith(color: AppColors.darkGrey300)),
                  Text("Harshita, +91-7631056337",
                      style: TextStyles.captionM.copyWith(color: AppColors.darkGrey300)),
                  SizedBox(height: 24.h),
                ],
              ),
            ),

            SizedBox(height: 50.h),
          ],
        ),
      );
    },
  );
}