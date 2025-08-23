
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_routes.dart';
import '../../../../models/order_model.dart';
import '../../../../widgets/cache_image.dart';

class OrderDetailsPage extends StatelessWidget {
  final List<OrderModel> orders;
  OrderDetailsPage({required this.orders, Key? key}) : super(key: key);

  String _formatDate(DateTime dt) {
    final months = [
      "", "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    final days = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final dayName = days[dt.weekday];
    final monthName = months[dt.month];
    return "$dayName, ${dt.day.toString().padLeft(2, '0')} $monthName";
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No order details available')),
      );
    }

    final order = orders.first;
    final address = order.address;

    final allItems = orders.expand((o) => o.items).toList();

    final double itemTotal = allItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final double deliveryCharge = orders.fold(0.0, (sum, o) => sum + o.deliveryCharge);
    final double orderTotal = itemTotal + deliveryCharge;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ORDER DETAILS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivered on ${_formatDate(order.deliveryDate)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.sp),
                  ),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),
                  SizedBox(height: 6.h),
                  Text(
                    "${allItems.length} items in order",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),
                  SizedBox(height: 10.h),
                  ...allItems.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 37.w,
                            height: 37.w,
                            child: CachedImage(
                              imageUrl: item.menuItem?.s3Url ?? '',
                              cacheKey: item.menuItem?.imageUrl ?? '',
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
                          width: 19.w,
                          height: 19.h,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item.quantity}x ${item.name}",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                              ),
                              Text(
                                "${item.menuItem?.quantity}g",
                                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "₹${item.price.toStringAsFixed(2)}",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.2.sp),
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),

                  // Delivery details
                  Text(
                    'Delivery details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
                  ),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),
                  SizedBox(height: 9.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 18.sp, color: Colors.grey.shade700),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address?.receiverName ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                            ),
                            Text(
                              address?.address ?? '',
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              address?.receiverPhone != null ? "(+91) ${address?.receiverPhone}" : '',
                              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),

                  // Order summary
                  Text(
                    'Order Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
                  ),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),
                  SizedBox(height: 7.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item Total', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text("₹${itemTotal.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Charges', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text("₹${deliveryCharge.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Total', style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600)),
                      Text("₹${orderTotal.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: Colors.black)),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Mode', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text("COD", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Divider(height: 22.h, color: Colors.grey.shade300, thickness: 1.2),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              margin: EdgeInsets.all(14.w),
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                ),
                icon: Icon(Icons.refresh, color: Colors.white, size: 22.sp),
                label: Text('Order Again', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Get.toNamed(AppRoutes.menu);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
