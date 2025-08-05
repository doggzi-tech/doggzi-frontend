import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void openContactSheet(BuildContext context) {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("Update Receiver Details", style: TextStyles.actionL),
                ),
                SizedBox(height: 16.h),

                // Name Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Receiver's Name",
                      hintStyle: TextStyles.bodyS.copyWith(
                        color: AppColors.darkGrey500,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // Contact Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Receiver's Contact",
                      hintStyle: TextStyles.bodyS.copyWith(
                        color: AppColors.darkGrey500,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Submit Button
                Container(
                  height: 52.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.orange400,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange400.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      // TODO: Save updated contact info
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Submit",
                      style: TextStyles.actionL.copyWith(
                        color: AppColors.lightGrey100,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 50.h),
              ],
            ),
          ],
        ),
      );
    },
  );
}
