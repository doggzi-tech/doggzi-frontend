// map_pick_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/map_pick_controller.dart';
import '../../theme/text_style.dart';
import '../../theme/colors.dart';
import '../../controllers/address_controller.dart';

class MapPickPage extends StatelessWidget {
  MapPickPage({super.key});

  // Put controller (lazy instantiate)
  final MapPickController c = Get.put(MapPickController());
  final AddressController _addressController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Ensure ScreenUtil is initialized higher up (MaterialApp -> ScreenUtilInit)
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              initialCameraPosition: c.initialCamera.value,
              onMapCreated: c.onMapCreated,
              onCameraMove: c.onCameraMove,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              // optionally update when camera stops (onCameraIdle) for extra safety
              onCameraIdle: () {
                // nothing needed: we debounced in onCameraMove
              },
            ),
          ),

          // Center marker (pure UI)
          Center(
            child: Icon(Icons.location_on, size: 48.h, color: Colors.redAccent),
          ),

          // Top search row
          Positioned(
            top: 48.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: c.searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: c.onSearchSubmitted,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search For Area, Locality...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: c.moveToCurrentLocation,
                    tooltip: 'Go to current location',
                  ),
                ),
              ],
            ),
          ),

          // Bottom address card (shows only if candidate exists)
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 28.h,
            child: Obx(() {
              final a = c.candidate.value;
              if (a == null) {
                return const SizedBox.shrink();
              }

              return Card(
                color: AppColors.lightGrey100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Will Be Delivered Here',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        a.address,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          onPressed: c.proceed,
                          child: Text(
                            'Proceed',
                            style: TextStyles.bodyXL
                                .copyWith(color: AppColors.lightGrey100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
