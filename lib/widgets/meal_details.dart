import 'package:doggzi/controllers/food_menu_controller.dart';
import 'package:doggzi/controllers/quantity_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/widgets/bulge_lines.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/menu_model.dart';

void showMenuItemDetails(String itemId) async {
  final menuController = Get.find<FoodMenuController>();

  if (menuController.isDetailsSheetOpen.value) return;
  menuController.isDetailsSheetOpen.value = true;

  // Try to get the item from local cache
  final cachedItem = menuController.allMenuItems
      .firstWhereOrNull((e) => e.id == itemId);

  if (cachedItem != null) {
    menuController.selectedMenuItem.value = cachedItem;

    Get.bottomSheet(
      MenuItemDetailsSheet(data: cachedItem.toJson()),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((_) {
      menuController.selectedMenuItem.value = null;
      menuController.isDetailsSheetOpen.value = false;
    });

    return;
  }

  // If not found in cache, fetch from API
  final dio = Dio();

  try {
    final response =
        await dio.get('https://backend.doggzi.com/api/v1/menu/$itemId');

    if (response.statusCode == 200) {
      final data = Map<String, dynamic>.from(response.data);
      final item = MenuModel.fromJson(data);

      menuController.selectedMenuItem.value = item;

      Get.bottomSheet(
        MenuItemDetailsSheet(data: data),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ).then((_) {
        menuController.selectedMenuItem.value = null;
      });
    } else {
      Get.snackbar("Error", "Failed to fetch item details");
    }
  } catch (e) {
    Get.snackbar("Error", "Something went wrong: $e");
  }
}

class MenuItemDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  final quantityController = Get.put(QuantityController());

  MenuItemDetailsSheet({super.key, required this.data});

  Widget _tag(String label, Color backgroundColor,
      {Widget? icon, bool iconLeft = false}) {
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
          Text(label,
              style:
                  TextStyles.actionS.copyWith(color: AppColors.lightGrey100)),
          if (icon != null && !iconLeft) ...[SizedBox(width: 6.w), icon],
        ],
      ),
    );
  }

  Widget _infoTag({
    required Widget icon,
    required String text,
  }) {
    return Container(
      width: 106.w,
      height: 34.h,
      //padding: EdgeInsets.fromLTRB(6.w, 10.h, 5.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.darkGrey200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 4.w), // gap
          Text(
            text,
            style: TextStyles.captionM.copyWith(color: AppColors.darkGrey300),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isFresh = data['freshly_cooked'] == true;
    return SizedBox(
      height: 772.h,
      width: 402.w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Image
                  if (data['s3_url'] == null)
                    Text(
                      "Could not load image. Retry later!",
                      style: TextStyle(
                          color: AppColors.orange500, fontSize: 16.sp),
                    )
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.network(
                        data['s3_url'],
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  SizedBox(height: 16.h),

                  // Name and Quantity
                  Row(
                    children: [
                      // Name
                      Text(
                        data['name'] ?? 'Unknown',
                        style: TextStyles.h3,
                      ),

                      const Spacer(),

                      // Quantity Container
                      Container(
                        width: 117.25.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: AppColors.orange200,
                          border: Border.all(
                            color: AppColors.orange500,
                            width: 0.88.w,
                          ),
                          borderRadius: BorderRadius.circular(8.75.r),
                        ),
                        child: Center(
                          child: Text(
                            "Quantity: ${data['quantity'] ?? 'N/A'} Gm",
                            style: TextStyles.actionS.copyWith(
                              color: AppColors.orange500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Column(
                    children: [
                      SizedBox(
                        width: 366.w,
                        height: 315
                            .h, // Set a fixed height for the scrollable content
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _infoTag(
                                    icon: Icon(Icons.star,
                                        size: 24.sp, color: Colors.orange),
                                    text: "4.8",
                                  ),
                                  const Spacer(),
                                  _infoTag(
                                    icon: Icon(Icons.delivery_dining,
                                        size: 19.sp, color: Colors.blue),
                                    text: "45 Min",
                                  ),
                                  const Spacer(),
                                  _infoTag(
                                    icon: Image.asset(
                                      data['diet_type'] == "vegetarian"
                                          ? 'assets/images/veg.png'
                                          : 'assets/images/non_veg.png',
                                      width: 19.w,
                                      height: 19.h,
                                    ),
                                    text: data['diet_type'] == "vegetarian"
                                        ? "Veg"
                                        : "Non Veg",
                                  ),
                                ],
                              ),

                              SizedBox(height: 16.h),

                              // Quantity row
                              Row(children: [
                                Container(
                                    height: 72.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(36.52.r),
                                      color: Colors
                                          .transparent, // or set a background if needed
                                    ),
                                    child: Row(
                                      children: [
                                        ZoomTapAnimation(
                                          onTap: () =>
                                              Get.find<QuantityController>()
                                                  .decrement(),
                                          child: Icon(Icons.remove_circle,
                                              size: 65.sp,
                                              color: AppColors.orange400),
                                        ),
                                        SizedBox(width: 12.17.w),
                                        Obx(() {
                                          final qty =
                                              Get.find<QuantityController>()
                                                  .quantity
                                                  .value;
                                          return Container(
                                            width: 72.w,
                                            height: 72.w,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.darkGrey100,
                                            ),
                                            child: Center(
                                              child: Text(
                                                qty.toString(),
                                                style: TextStyles.actionL,
                                              ),
                                            ),
                                          );
                                        }),
                                        SizedBox(width: 12.17.w),
                                        ZoomTapAnimation(
                                          onTap: () =>
                                              Get.find<QuantityController>()
                                                  .increment(),
                                          child: Icon(Icons.add_circle,
                                              size: 65.sp,
                                              color: AppColors.orange400),
                                        ),
                                      ],
                                    )),
                                const Spacer(),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Top line (bulge downward)
                                    CustomPaint(
                                      size: Size(60.w, 8.h),
                                      painter: BulgedLinePainter(
                                          color: AppColors.orange400),
                                    ),
                                    SizedBox(height: 4.h),

                                    // Price text
                                    Text(
                                      "₹${(data['price'] ?? 0).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 4.h),

                                    // Bottom line (bulge upward — flipped)
                                    Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationX(3.14159),
                                      child: CustomPaint(
                                        size: Size(60.w, 8.h),
                                        painter: BulgedLinePainter(
                                            color: AppColors.orange400),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),

                              SizedBox(height: 16.h),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Description",
                                    style: TextStyles.bodyL),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                data['description'] ??
                                    "No description available",
                                style: TextStyles.bodyM.copyWith(
                                  color: AppColors.darkGrey300,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Nutritional elements",
                                  style: TextStyles.bodyL,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              //below is only placeholder for now as no logic in backend defined

                              // Nutritional Elements Container
                              Container(
                                width: double.infinity,
                                height: 64.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFFF6D3E), // start
                                      Color(0xFFFF7F52), // mid
                                      Color(0xFFFF6D3E), // end
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Protein
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Protein",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "24g",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Fat
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Fat",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "11%",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Calories
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Calories",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "320 Kcal",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Add to Cart and Icon
                  Row(
                    children: [
                      Expanded(
                        child: ZoomTapAnimation(
                          onTap: () {
                            //final qty = Get.find<QuantityController>().quantity.value;
                            // Use qty in Add to Cart logic
                            //Get.find<QuantityController>().reset();

                            print("Add to Cart clicked");
                          },
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
                                    color: Colors.white, fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ZoomTapAnimation(
                        onTap: (){
                          Get.toNamed(AppRoutes.cart);
                        },
                        child: Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.darkGrey500,
                          ),
                          child: const Icon(Icons.shopping_bag_outlined,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 180.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                children: [
                  isFresh
                      ? _tag(
                          "Freshly Cooked",
                          AppColors.green300,
                          icon: SvgPicture.asset(
                            'assets/images/fresh.svg',
                            width: 16.sp,
                            height: 16.sp,
                            color: AppColors.lightGrey100,
                          ),
                        )
                      : _tag(
                          "Packaged",
                          AppColors.darkGrey300,
                          icon: Icon(
                            Icons.storage,
                            size: 16.sp,
                            color: AppColors.lightGrey100,
                          ),
                        ),
                  const Spacer(),
                  Container(
                    color: AppColors.lightGrey100,
                    child: SizedBox(
                      width: 27.w,
                      height: 27.h,
                      child: Image.asset(
                        data['diet_type'] == "vegetarian"
                            ? 'assets/images/veg.png'
                            : 'assets/images/non_veg.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (data['species'] != null)
                    _tag(
                      "Food For ${data['species'].toString().capitalizeFirst}",
                      AppColors.brown,
                      icon: Image.asset(
                        'assets/images/dog.png',
                        width: 16.sp,
                        height: 16.sp,
                        color: AppColors.lightGrey100,
                        fit: BoxFit.contain,
                      ),
                      iconLeft: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
