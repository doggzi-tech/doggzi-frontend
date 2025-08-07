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

class MenuItemDetailsSheet extends GetView<FoodMenuController> {
  MenuItemDetailsSheet({super.key, required this.menu});

  final cartController = Get.find<CartController>();
  final MenuModel menu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 750.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 670.h,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 320.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        CachedImage(
                          cacheKey: menu.imageUrl,
                          imageUrl: menu.s3Url,
                          width: double.infinity,
                          height: 300.h,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 40.w,
                          right: 40.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatusTag(menu.freshlyCooked),
                              _buildCenterDietIcon(),
                              _buildSpeciesTag(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        _buildNameAndQuantity(),
                        SizedBox(height: 12.h),
                        _buildMainContent(),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildAddToCartSection()),
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
      "Food For ${menu.species.toString().capitalizeFirst}",
      AppColors.brown500,
      icon: SvgPicture.asset(
        menu.species == "cat"
            ? "assets/images/cat_face.svg"
            : "assets/images/dog_face.svg",
        color: AppColors.lightGrey100,
        width: 18.sp,
      ),
      iconLeft: true,
    );
  }

  Widget _buildDietTypeIcon() {
    return Image.asset(
      menu.dietType == "vegetarian"
          ? 'assets/images/veg.png'
          : 'assets/images/non_veg.png',
      width: 19.w,
      height: 19.h,
      errorBuilder: (context, error, stackTrace) => Icon(
        menu.dietType == "vegetarian" ? Icons.eco : Icons.restaurant,
        size: 19.sp,
        color: menu.dietType == "vegetarian" ? Colors.green : Colors.red,
      ),
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

  Widget _buildNameAndQuantity() {
    return Row(
      children: [
        Expanded(
          child: Text(
            menu.name,
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
        "Quantity: ${menu.quantity} Gm",
        style: TextStyles.actionS.copyWith(
          color: AppColors.orange500,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
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
          text: menu.dietType == "vegetarian" ? "Veg" : "Non Veg",
        ),
      ],
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
              size: 50.sp,
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
              size: 50.sp,
              color: AppColors.orange400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityDisplay() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkGrey100,
      ),
      child: Center(
        child: Text(
          controller.itemQuantity.value.toString(),
          style: TextStyles.actionL,
        ),
      ),
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
          menu.description,
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey300,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalElements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nutritional elements", style: TextStyles.bodyL),
        SizedBox(height: 4.h),
        for (String item in menu.itemList) _buildNutritionalItem(item),
      ],
    );
  }

  Widget _buildNutritionalItem(String value) {
    return Text(value, style: TextStyles.bodyL);
  }

  void _incrementQuantity() {
    if (controller.itemQuantity.value < 99) {
      controller.itemQuantity.value++;
    }
  }

  void _decrementQuantity() {
    if (controller.itemQuantity.value > 1) {
      controller.itemQuantity.value--;
    }
  }

  double _calculateTotalPrice() {
    return menu.price.toDouble() * controller.itemQuantity.value;
  }

  void _handleAddToCart() async {
    final quantity = controller.itemQuantity.value;
    await cartController.addToCart(menu.id, quantity);
    Get.offNamed(AppRoutes.cart);
  }
}
