import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_routes.dart';
import '../../../../models/order_model.dart';
import '../../../../widgets/cache_image.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  OrderDetailsPage({required this.order, Key? key}) : super(key: key);

  String _formatDate(DateTime dt) {
    final months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    final days = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final dayName = days[dt.weekday];
    final monthName = months[dt.month];
    return "$dayName, ${dt.day.toString().padLeft(2, '0')} $monthName";
  }

  double _getItemsTotal() {
    return order.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    if (order.items.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Center(child: Text('No order details available')),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // 90% of screen
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // HEADER (instead of AppBar)
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            alignment: Alignment.center,
            child: Text(
              'ORDER DETAILS',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Delivery Date
                  Text(
                    'Delivered on ${_formatDate(order.deliveryDate)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),

                  //Items Count
                  order.items.length==1?
                  Text(
                    "${order.items.length} item in order",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ):Text(
                    "${order.items.length} items in order",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),

                  // --- Items List ---
                  Column(
                    children: order.items.map((item) {
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
                            SizedBox(width: 10.w),
                            Image.asset(
                              item.menuItem?.dietType == "vegetarian"
                                  ? 'assets/images/veg.png'
                                  : 'assets/images/non_veg.png',
                              width: 20.w,
                              height: 20.h,
                            ),
                            SizedBox(width: 10.w),
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
                            SizedBox(width: 10.w),
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
                    }).toList(),
                  ),

                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),

                  //Delivery Details
                  Text(
                    'Delivery details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.sp),
                  ),
                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),
                  SizedBox(height: 9.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 18.sp, color: Colors.grey.shade700),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.address!.receiverName ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp),
                            ),
                            Text(
                              order.address?.address ?? '',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              order.address?.receiverPhone != null
                                  ? "(+91) ${order.address?.receiverPhone}"
                                  : '',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),

                  //Order Summary
                  Text(
                    'Order Summary',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.sp),
                  ),
                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),
                  SizedBox(height: 7.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item Total',
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      Text("₹${_getItemsTotal().toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Charges',
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      Text("₹${order.deliveryCharge.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax Included',
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      Text("₹${order.tax.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Total',
                          style: TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w600)),
                      Text("₹${order.totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: Colors.black)),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Mode',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      Text("NULL",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Divider(
                      height: 22.h,
                      color: Colors.grey.shade300,
                      thickness: 1.2),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            margin: EdgeInsets.all(14.w),
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
              ),
              icon: Icon(Icons.refresh, color: Colors.white, size: 22.sp),
              label: Text('Order Again',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Get.toNamed(AppRoutes.menu);
              },
            ),
          ),
        ],
      ),
    );
  }
}
