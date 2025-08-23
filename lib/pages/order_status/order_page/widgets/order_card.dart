
import 'package:doggzi/pages/order_status/order_page/widgets/order_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controllers/cart_controller.dart';
import '../../../../models/order_model.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/cache_image.dart';


class OrderCard extends GetView<CartController> {
  final String title;
  final List<OrderModel> order;

  const OrderCard({required this.title,required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>OrderDetailsPage(orders: order));
      },
      child: Container(
        margin: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),

          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 5.h, left: 10.w),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
              ),
            ),
            Divider(height: 18.h, color: Colors.grey.shade300, thickness: 1,),
            Container(
              child: Column(
                children: [
                  ...order.expand((order) =>
                      order.items.map((item) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 13.w, vertical: 7.h),
                          child: Row(
                            children: [
                              ClipRRect(
                                child: SizedBox(
                                  width: 44.w,
                                  height: 44.w,
                                  child: CachedImage(
                                    imageUrl: item.menuItem!.s3Url,
                                    cacheKey: item.menuItem!.imageUrl,
                                    width: 150.w,
                                    height: 110.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              Image.asset(
                                item.menuItem?.dietType == "vegetarian"
                                    ? 'assets/images/veg.png'
                                    : 'assets/images/non_veg.png',
                                width: 20.w,
                                height: 20.h,
                              ),
                              SizedBox(width: 5.w,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item.quantity}x ${item.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.8.sp),
                                    ),
                                    Text(
                                      ' ${item.menuItem?.quantity}g',
                                      style: TextStyle(
                                          fontSize: 11.5.sp,
                                          color: Colors.grey.shade500),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "₹${item.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.6.sp,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      })),
                  Divider(
                      height: 18.h, color: Colors.grey.shade300, thickness: 1),
                  title.contains('Delivered')?
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 19.w, vertical: 6.h),
                    child: Row(
                      children: [
                        Text(
                          'Rate',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.sp),
                        ),
                        SizedBox(width: 11.w),
                        ...List.generate(
                          5,
                              (i) =>
                              Icon(Icons.star_border,
                                  size: 18.w, color: Colors.grey.shade400),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement reorder logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange300,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.r)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 23.w, vertical: 1.5.h),
                            elevation: 0,
                          ),
                          child: Text(
                            "Reorder",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.8.sp),
                          ),
                        )
                      ],
                    ),
                  ):SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}