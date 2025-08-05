import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/controllers/food_menu_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/models/menu_model.dart';
import 'package:doggzi/widgets/bulge_lines.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cache_image.dart';

class MenuItemDetailsSheet extends StatelessWidget {
  final MenuModel item;

  const MenuItemDetailsSheet({super.key, required this.item});

  // Get controller instance
  FoodMenuController get _menuController => Get.find<FoodMenuController>();

  CartController get cartController => Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 750.h,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 16.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildItemImage(),
                SizedBox(height: 16.h),
                _buildNameAndQuantity(),
                SizedBox(height: 12.h),
                _buildMainContent(),
                SizedBox(
                  height: 10.h,
                ),
                _buildAddToCartSection(),
              ],
            ),
          ),
          _buildOverlayTags(),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CachedImage(
          imageUrl: item.s3Url,
          width: 366.w,
          height: 300.h,
          fit: BoxFit.cover,
          cacheKey: item.imageUrl,
        ));
  }

  Widget _buildNameAndQuantity() {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.name,
            style: TextStyles.h3,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        SizedBox(width: 8.w),
        _buildQuantityContainer(),
      ],
    );
  }

  Widget _buildQuantityContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.orange100.withValues(alpha: 0.14),
        border: Border.all(
          color: AppColors.orange500,
          width: 0.88.w,
        ),
        borderRadius: BorderRadius.circular(8.75.r),
      ),
      child: Text(
        "Quantity: ${item.quantity} Gm",
        style: TextStyles.actionS.copyWith(
          color: AppColors.orange500,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SizedBox(
      width: 366.w,
      height: 315.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTags(),
            SizedBox(height: 16.h),
            _buildQuantityAndPriceRow(),
            SizedBox(height: 16.h),
            _buildDescription(),
            SizedBox(height: 16.h),
            _buildNutritionalElements(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoTag(
          icon: Icon(Icons.star, size: 24.sp, color: Colors.orange),
          text: "4.8",
        ),
        _buildInfoTag(
          icon: Icon(Icons.delivery_dining, size: 19.sp, color: Colors.blue),
          text: "45 Min",
        ),
        _buildInfoTag(
          icon: _buildDietTypeIcon(),
          text: item.dietType == "vegetarian" ? "Veg" : "Non Veg",
        ),
      ],
    );
  }

  Widget _buildDietTypeIcon() {
    return Image.asset(
      item.dietType == "vegetarian"
          ? 'assets/images/veg.png'
          : 'assets/images/non_veg.png',
      width: 19.w,
      height: 19.h,
      errorBuilder: (context, error, stackTrace) => Icon(
        item.dietType == "vegetarian" ? Icons.eco : Icons.restaurant,
        size: 19.sp,
        color: item.dietType == "vegetarian" ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildInfoTag({required Widget icon, required String text}) {
    return Container(
      width: 106.w,
      height: 34.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.darkGrey200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyles.captionM.copyWith(color: AppColors.darkGrey300),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityAndPriceRow() {
    return Row(
      children: [
        _buildQuantitySelector(),
        const Spacer(),
        _buildPriceSection(),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36.52.r),
      ),
      child: Row(
        children: [
          ZoomTapAnimation(
            onTap: () => _decrementQuantity(),
            child: Icon(
              Icons.remove_circle,
              size: 65.sp,
              color: AppColors.orange400,
            ),
          ),
          SizedBox(width: 12.17.w),
          Obx(() => _buildQuantityDisplay()),
          SizedBox(width: 12.17.w),
          ZoomTapAnimation(
            onTap: () => _incrementQuantity(),
            child: Icon(
              Icons.add_circle,
              size: 65.sp,
              color: AppColors.orange400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityDisplay() {
    return Container(
      width: 72.w,
      height: 72.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkGrey100,
      ),
      child: Center(
        child: Text(
          _menuController.itemQuantity.value.toString(),
          style: TextStyles.actionL,
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(60.w, 8.h),
          painter: BulgedLinePainter(color: AppColors.orange400),
        ),
        SizedBox(height: 4.h),
        Obx(() => Text(
              "₹${(_calculateTotalPrice()).toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            )),
        SizedBox(height: 4.h),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(3.14159),
          child: CustomPaint(
            size: Size(60.w, 8.h),
            painter: BulgedLinePainter(color: AppColors.orange400),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description", style: TextStyles.bodyL),
        SizedBox(height: 4.h),
        Text(
          item.description,
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey300,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalElements() {
    // Mock data - replace with actual nutritional data from MenuModel
    final nutritionalData = _getNutritionalData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nutritional elements", style: TextStyles.bodyL),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          height: 64.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFF6D3E),
                Color(0xFFFF7F52),
                Color(0xFFFF6D3E),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: nutritionalData.entries.map((entry) {
              return _buildNutritionalItem(entry.key, entry.value);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartSection() {
    return Row(
      children: [
        Expanded(
          child: ZoomTapAnimation(
            onTap: _handleAddToCart,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  "Add To Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        ZoomTapAnimation(
          onTap: () => Get.toNamed(AppRoutes.cart),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkGrey500,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayTags() {
    final bool isFresh = item.freshlyCooked == true;

    return Positioned(
      top: 280.h,
      left: 16.w,
      right: 16.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusTag(isFresh),
              _buildSpeciesTag(),
            ],
          ),
          _buildCenterDietIcon(),
        ],
      ),
    );
  }

  Widget _buildStatusTag(bool isFresh) {
    return _buildTag(
      isFresh ? "Freshly Cooked" : "Packaged",
      isFresh ? AppColors.green300 : AppColors.darkGrey300,
      icon: isFresh
          ? SvgPicture.asset(
              'assets/images/fresh.svg',
              width: 16.sp,
              height: 16.sp,
              color: AppColors.lightGrey100,
            )
          : Icon(
              Icons.storage,
              size: 16.sp,
              color: AppColors.lightGrey100,
            ),
    );
  }

  Widget _buildSpeciesTag() {
    return _buildTag(
      "Food For ${item.species.toString().capitalizeFirst}",
      AppColors.brown500,
      icon: SvgPicture.asset(
        item.species == "cat"
            ? "assets/images/cat_face.svg"
            : "assets/images/dog_face.svg",
        color: AppColors.lightGrey100,
        width: 18.sp,
      ),
      iconLeft: true,
    );
  }

  Widget _buildCenterDietIcon() {
    return Container(
      color: AppColors.lightGrey100,
      child: SizedBox(
        width: 27.w,
        height: 27.h,
        child: _buildDietTypeIcon(),
      ),
    );
  }

  Widget _buildTag(
    String label,
    Color backgroundColor, {
    Widget? icon,
    bool iconLeft = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: AppColors.lightGrey100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && iconLeft) ...[icon, SizedBox(width: 6.w)],
          Text(
            label,
            style: TextStyles.actionS.copyWith(color: AppColors.lightGrey100),
          ),
          if (icon != null && !iconLeft) ...[SizedBox(width: 6.w), icon],
        ],
      ),
    );
  }

  // Helper methods
  void _incrementQuantity() {
    if (_menuController.itemQuantity.value < 99) {
      _menuController.itemQuantity.value++;
    }
  }

  void _decrementQuantity() {
    if (_menuController.itemQuantity.value > 1) {
      _menuController.itemQuantity.value--;
    }
  }

  double _calculateTotalPrice() {
    return item.price.toDouble() * _menuController.itemQuantity.value;
  }

  void _handleAddToCart() async {
    final quantity = _menuController.itemQuantity.value;
    await cartController.addToCart(item.id, quantity);
    Get.offNamed(AppRoutes.cart);
  }

  Map<String, String> _getNutritionalData() {
    // TODO: Replace with actual data from MenuModel
    // This is placeholder data
    return {
      "Protein": "24g",
      "Fat": "11%",
      "Calories": "320 Kcal",
    };
  }
}
