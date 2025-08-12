// map_pick_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/map_pick_controller.dart';
import '../../theme/text_style.dart';
import '../../theme/colors.dart';
import '../../controllers/address_controller.dart';
import '../../models/address_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';

class MapPickPage extends StatelessWidget {
  MapPickPage({super.key});

  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();
  final Rx<AddressType> selectedLabel = AddressType.home.obs;
  final RxBool isDefault = false.obs;
  final MapPickController c = Get.put(MapPickController());
  final AddressController _addressController = Get.find();
  final FocusNode _searchFocusNode = FocusNode();
  final RxBool _isSearchFocused = false.obs;
  final RxBool _showAddressForm = false.obs;

  @override
  Widget build(BuildContext context) {
    // Listen to keyboard visibility
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Full-screen map (Zomato style)
          Positioned.fill(
            child: Obx(
              () => GoogleMap(
                initialCameraPosition: c.initialCamera.value,
                onMapCreated: c.onMapCreated,
                onCameraMove: c.onCameraMove,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
                compassEnabled: false,
                onTap: (_) {
                  // Dismiss keyboard and search focus like Zomato
                  _searchFocusNode.unfocus();
                  _isSearchFocused.value = false;
                },
              ),
            ),
          ),

          // Top search bar (Zomato style - always visible)
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: c.searchController,
                      focusNode: _searchFocusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: c.onSearchSubmitted,
                      onTap: () => _isSearchFocused.value = true,
                      decoration: InputDecoration(
                        hintText: 'Search area, street name...',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.my_location, color: Colors.deepOrange),
                    onPressed: c.moveToCurrentLocation,
                  ),
                ],
              ),
            ),
          ),

          // Center pin (Zomato style)
          Obx(() => !_isSearchFocused.value
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 40.h,
                        color: Colors.deepOrange,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Move map to select location',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),

          // Bottom sheet with address info (Zomato style - collapses on keyboard)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              final isKeyboardOpen = keyboardHeight > 0;

              if (c.candidate.value == null ||
                  isKeyboardOpen ||
                  _isSearchFocused.value) {
                return const SizedBox.shrink();
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Address display
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.deepOrange,
                                size: 20.h,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deliver to',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      c.candidate.value!.address,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Confirm location button (Zomato style - single action)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                _showAddressForm.value = true;
                              },
                              child: Text(
                                'Confirm Location',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 16.h),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          // Address details form (Zomato approach - separate overlay)
          Obx(() => _showAddressForm.value
              ? _buildAddressForm(context)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    // Pre-fill with existing data
    receiverNameController.text =
        _addressController.defaultAddress.value.receiverName;
    receiverPhoneController.text =
        _addressController.defaultAddress.value.receiverPhone;

    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _showAddressForm.value = false,
                  ),
                  Text(
                    'Complete Address',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current location display
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.deepOrange, size: 20.h),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                c.candidate.value?.address ?? '',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Form fields
                      Text(
                        'FLAT / HOUSE DETAILS',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: additionalInfoController,
                        hintText: 'House/Flat/Floor No.',
                        keyboardType: TextInputType.text,
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        'CONTACT DETAILS',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: receiverNameController,
                        hintText: 'Receiver Name',
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: receiverPhoneController,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),

                      SizedBox(height: 24.h),

                      Text(
                        'SAVE AS',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _buildLabelChip('Home', Icons.home_outlined,
                              AddressType.home, selectedLabel),
                          SizedBox(width: 8.w),
                          _buildLabelChip('Work', Icons.work_outline,
                              AddressType.work, selectedLabel),
                          SizedBox(width: 8.w),
                          _buildLabelChip('Other', Icons.location_on_outlined,
                              AddressType.other, selectedLabel),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      Obx(() => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Set as default address',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            value: isDefault.value,
                            onChanged: (val) => isDefault.value = val ?? false,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.deepOrange,
                          )),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom save button
            Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    // Validate
                    if (receiverNameController.text.trim().isEmpty ||
                        receiverPhoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Please fill in all required details'),
                          backgroundColor: Colors.red[600],
                        ),
                      );
                      return;
                    }

                    // Save address
                    final updated = c.candidate.value!.copyWith(
                      receiverName: receiverNameController.text.trim(),
                      receiverPhone: receiverPhoneController.text.trim(),
                      additionalAddressInformation:
                          additionalInfoController.text.trim(),
                      label: selectedLabel.value,
                      isDefault: isDefault.value,
                    );

                    c.candidate.value = updated;
                    _addressController.saveAddress(updated);
                  },
                  child: Text(
                    'Save Address',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelChip(String label, IconData icon, AddressType type,
      Rx<AddressType> selectedLabel) {
    return Obx(() => GestureDetector(
          onTap: () => selectedLabel.value = type,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: selectedLabel.value == type
                  ? Colors.deepOrange.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: selectedLabel.value == type
                    ? Colors.deepOrange
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16.h,
                  color: selectedLabel.value == type
                      ? Colors.deepOrange
                      : Colors.grey[600],
                ),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: selectedLabel.value == type
                        ? Colors.deepOrange
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
