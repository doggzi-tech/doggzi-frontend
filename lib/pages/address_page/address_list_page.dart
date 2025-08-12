import 'package:doggzi/controllers/location_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../controllers/address_controller.dart';
import '../../models/address_model.dart';

class AddressListPage extends GetView<AddressController> {
  AddressListPage({super.key});

  final locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Saved Addresses"),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  _buildSearchBar(),
                  SizedBox(height: 12.h),
                  _buildActionButtons(),
                  SizedBox(height: 18.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Saved Address',
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.grey[700])),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(child: Obx(() {
                    if (controller.addresses.isEmpty) {
                      return Center(
                          child: Text('No saved addresses',
                              style: TextStyle(fontSize: 14.sp)));
                    }
                    return ListView.separated(
                      itemBuilder: (ctx, i) {
                        final a = controller.addresses[i];
                        return _addressTile(a);
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemCount: controller.addresses.length,
                    );
                  })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onSubmitted: (q) async {
        final res = await controller.geocodeAddressString(q);
        if (res != null) {
          Get.toNamed(AppRoutes.mapPickPage,
              arguments: {'addressCandidate': res});
        } else {
          Get.snackbar('Not found', 'Could not locate address');
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search For Area, Locality...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Card(
          color: AppColors.lightGrey100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Address'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Get.toNamed(AppRoutes.mapPickPage); // Map open in pick mode
            },
          ),
        ),
        SizedBox(height: 8.h),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          color: AppColors.lightGrey100,
          child: ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('Use Current Location'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              try {
                final candidate =
                    await controller.getCurrentLocationAsAddress();
                // pass to form
                Get.toNamed(AppRoutes.mapPickPage,
                    arguments: {'addressCandidate': candidate});
              } catch (e) {
                Get.snackbar('Location error', e.toString());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _addressTile(AddressModel a) {
    return ZoomTapAnimation(
      onTap: () {
        controller.defaultAddress.value = a;
        locationController.address.value = a.address;
        Get.back();
      },
      child: Card(
        color: AppColors.lightGrey100,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(a.label.name.capitalizeFirst!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  if (a.isDefault)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16.r)),
                      child: Text('Delivers To',
                          style: TextStyle(
                              color: Colors.green[800], fontSize: 12.sp)),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text('${a.address}, ${a.additionalAddressInformation}',
                  style: TextStyle(fontSize: 13.sp)),
              SizedBox(height: 6.h),
              Text('${a.receiverName}, ${a.receiverPhone}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12.sp)),
              // SizedBox(height: 8.h),
              // Row(
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         Get.toNamed(AppRoutes.mapPickPage, arguments: {'edit': a});
              //       },
              //       child: const Text('Edit'),
              //     ),
              //     const Spacer(),
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text('Set Default'),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
