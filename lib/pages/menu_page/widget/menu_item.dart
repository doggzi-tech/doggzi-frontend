import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:doggzi/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/menu_model.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({super.key, required this.item});

  final MenuModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255.h,
      width: 170.w,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: CachedImage(
              imageUrl: item.s3Url,
              cacheKey: item.imageUrl,
              width: 150.w,
              height: 110.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 75.h,
            child: Column(
              children: [
                Container(
                  width: 168.w,
                  height: 160.h,
                  padding: EdgeInsets.only(
                    top: 5.h,
                    left: 5.w,
                    right: 5.w,
                    bottom: 5.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.darkGrey500.withValues(alpha: 0.06),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            item.dietType == "vegetarian"
                                ? 'assets/images/veg.png'
                                : 'assets/images/non_veg.png',
                            width: 20.w,
                            height: 20.h,
                          ),
                          Column(
                            children: [
                              item.species == "cat"
                                  ? SvgPicture.asset(
                                      'assets/images/cat_face.svg',
                                      width: 12.w,
                                      height: 12.h,
                                      color: AppColors.orange400,
                                    )
                                  : SvgPicture.asset(
                                      'assets/images/dog_face.svg',
                                      width: 20.w,
                                      height: 20.h,
                                      color: AppColors.orange400,
                                    ),
                              Text(
                                item.species == "cat" ? 'Cat' : 'Dog',
                                style: TextStyles.actionS.copyWith(
                                  color: AppColors.darkGrey500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  // Adds "..." at the end
                                  style: TextStyles.bodyS.copyWith(
                                    color: AppColors.orange500,
                                  ),
                                ),
                                Text(
                                  'Quantity : ${item.quantity}g',
                                  style: TextStyles.actionS.copyWith(
                                    color: AppColors.darkGrey400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Right side price with decorative lines
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Top decorative line
                              Container(
                                width: 40.w,
                                height: 1.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.withValues(alpha: 0.3),
                                      Colors.red.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // Price text
                              Text(
                                '\$${item.price.toStringAsFixed(0)}',
                                style: TextStyles.bodyL,
                              ),
                              SizedBox(height: 4.h),
                              // Bottom decorative line
                              Container(
                                width: 40.w,
                                height: 1.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.withValues(alpha: 0.7),
                                      Colors.red.withValues(alpha: 0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: AppColors.darkGrey300,
                      ),
                      for (final itemName in item.itemList)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(itemName, style: TextStyles.actionS),
                          ],
                        )
                    ],
                  ),
                ),
                item.freshlyCooked
                    ? Container(
                        height: 20.h,
                        width: 130.w,
                        decoration: BoxDecoration(
                          color: AppColors.green300,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25.r),
                            bottomLeft: Radius.circular(25.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/fresh.svg',
                              width: 14.w,
                              height: 14.h,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Freshly Cooked",
                              style: TextStyles.actionS.copyWith(
                                color: AppColors.lightGrey100,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
