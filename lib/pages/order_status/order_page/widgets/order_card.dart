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
  final OrderModel order;

  final RxInt rating=0.obs;

   OrderCard({super.key, required this.title, required this.order}){
     rating.value=order.rating??0;
   }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order Title
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),

            Divider(color: Colors.grey.shade300, thickness: 1.2),

            /// Order Items
            Column(
              children: order.items.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    children: [
                      /// Item Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
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
                      SizedBox(width: 10.w),

                      /// Veg / Non-Veg Icon
                      Image.asset(
                        item.menuItem?.dietType == "vegetarian"
                            ? 'assets/images/veg.png'
                            : 'assets/images/non_veg.png',
                        width: 20.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 5.w),

                      /// Item Name + Quantity
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${item.quantity}x ${item.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.8.sp,
                              ),
                            ),
                            Text(
                              ' ${item.menuItem?.quantity}g',
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      /// Price
                      Text(
                        "₹${item.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.6.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            Divider(color: Colors.grey.shade300, thickness: 1.2),

            title.contains('Delivered')?
            Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount Paid:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    "₹${order.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rate:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Obx(() => Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        rating.value = index + 1;
                       // order.rating=index+1;
                      },
                      child: Icon(
                        index < rating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 22.sp,
                      ),
                    );
                  }),
                )),
              ],
            ),

          ],):SizedBox(height: 8.h),



            /// Reorder Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement reorder functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 10.h,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Reorder",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
