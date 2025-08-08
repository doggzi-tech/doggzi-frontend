import 'dart:async';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/address_controller.dart';
import '../../models/address_model.dart';
import '../../theme/text_style.dart';

class MapPickPage extends StatefulWidget {
  const MapPickPage({super.key});

  @override
  State<MapPickPage> createState() => _MapPickPageState();
}

class _MapPickPageState extends State<MapPickPage> {
  final AddressController c = Get.find();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initial =
      const CameraPosition(target: LatLng(18.5204, 73.8567), zoom: 14);
  AddressModel? candidate;
  final TextEditingController _searchCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['addressCandidate'] != null) {
      candidate = args['addressCandidate'] as AddressModel;
      _initial = CameraPosition(
          target: LatLng(candidate!.lat, candidate!.lng), zoom: 17);
    } else if (args != null && args['edit'] != null) {
      candidate = args['edit'] as AddressModel;
      _initial = CameraPosition(
          target: LatLng(candidate!.lat, candidate!.lng), zoom: 17);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: _initial,
          onMapCreated: (ctrl) {
            _controller.complete(ctrl);
          },
          onCameraIdle: () async {
            // optional: fetch address info for center
          },
          onCameraMove: (pos) {
            candidate ??= AddressModel(
              userId: 'u1',
              receiverName: '',
              receiverPhone: '',
              flat: '',
              area: '',
              city: '',
              state: '',
              postalCode: '',
              country: '',
              lat: pos.target.latitude,
              lng: pos.target.longitude,
            );
            candidate!.lat = pos.target.latitude;
            candidate!.lng = pos.target.longitude;
          },
        ),
        // Center marker
        Center(
            child:
                Icon(Icons.location_on, size: 48.h, color: Colors.redAccent)),
        Positioned(
          top: 48.h,
          left: 16.w,
          right: 16.w,
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _searchCtl,
                onSubmitted: (q) async {
                  final res = await c.geocodeAddressString(q);
                  if (res != null) {
                    final mapCtrl = await _controller.future;
                    mapCtrl.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(res.lat, res.lng), zoom: 17)));
                    setState(() {
                      candidate = res;
                    });
                  } else {
                    Get.snackbar('Not found', 'Could not find address');
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search For Area, Locality...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r)),
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () async {
                  try {
                    final current = await c.getCurrentLocationAsAddress();
                    final mapCtrl = await _controller.future;
                    mapCtrl.animateCamera(CameraUpdate.newLatLng(
                        LatLng(current.lat, current.lng)));
                    setState(() {
                      candidate = current;
                    });
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
              ),
            ),
          ]),
        ),
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 28.h,
          child: candidate == null
              ? Container()
              : Card(
                  color: AppColors.lightGrey100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Order Will Be Delivered Here',
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8.h),
                        Text(
                            '${candidate!.flat.isNotEmpty ? candidate!.flat + ', ' : ''}${candidate!.area}, ${candidate!.city}, ${candidate!.postalCode}',
                            style: TextStyle(fontSize: 13.sp)),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: EdgeInsets.symmetric(vertical: 12.h)),
                            onPressed: () {
                              // Proceed to form to fill receiver details / save
                              Get.toNamed(AppRoutes.addressFormPage,
                                  arguments: {'addressCandidate': candidate});
                            },
                            child: Text('Proceed',
                                style: TextStyles.bodyXL.copyWith(
                                  color: AppColors.lightGrey100,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ]),
    );
  }
}
