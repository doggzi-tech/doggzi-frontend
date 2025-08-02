import 'package:doggzi/controllers/location_controller.dart';
import 'package:doggzi/pages/cart/widgets/address_sheet.dart';
import 'package:doggzi/pages/cart/widgets/contact_sheet.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DeliveryAddressCard extends StatelessWidget {
  const DeliveryAddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          // Delivering At
          ListTile(
            onTap: () => openAddressSheet(context),
            leading: Icon(Icons.location_pin, color: Colors.green, size: 20.sp),
            title: Text("Delivering At",
                style: TextStyles.captionL.copyWith(
                    color: AppColors.darkGrey500)),
            subtitle: Obx(() {
                return Text(
                  controller.currentPosition == null
                      ? "Fetching location..."
                      : "${controller.currentPosition?.latitude}, ${controller.currentPosition?.longitude}",
                  style: TextStyles.captionM.copyWith(
                    color: AppColors.darkGrey300,
                  ),
                );
              }),
              trailing: Icon(Icons.arrow_forward_ios,
                size: 16.sp, color: AppColors.darkGrey300),
          ),
          Divider(height: 1.h, color: Colors.grey.shade300),
          // Contact
          ListTile(
            onTap: () => openContactSheet(context),
            leading: Icon(Icons.call, color: AppColors.darkGrey300, size: 20.sp),
            title: Text("Contact Details",
                style: TextStyles.captionL.copyWith(
                    color: AppColors.darkGrey500)),
            subtitle: Text("Harshita, +91-7631056337",
                style: TextStyles.captionM.copyWith(
                    color: AppColors.darkGrey300)),
            trailing: Icon(Icons.arrow_forward_ios,
                size: 16.sp, color: AppColors.darkGrey300),
          ),
        ],
      ),
    );
  }
}
