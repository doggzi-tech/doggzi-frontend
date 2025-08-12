import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/pages/address_page/map_pick_page.dart';
import 'package:doggzi/services/address_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';
import 'auth_controller.dart';
import 'location_controller.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final _authController = Get.find<AuthController>();
  final addressService = AddressService();
  final locationController = Get.find<LocationController>();
  final Rx<AddressModel> defaultAddress = AddressModel(
    address: '',
    id: '',
    additionalAddressInformation: '',
    label: AddressType.home,
    lat: 0.0,
    lng: 0.0,
    receiverName: '',
    receiverPhone: '',
  ).obs;

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
    if (_authController.user != null) {
      defaultAddress.value = defaultAddress.value.copyWith(
        receiverName: _authController.user!.fullName,
        receiverPhone: _authController.user!.phoneNumber,
      );
    }
  }

  Future<void> loadAddresses() async {
    try {
      final List<AddressModel> loadedAddresses =
          await addressService.getAddresses();
      addresses.assignAll(loadedAddresses);

      if (loadedAddresses.isNotEmpty) {
        final Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        for (var address in loadedAddresses) {
          var distance = Geolocator.distanceBetween(currentPosition.latitude,
              currentPosition.longitude, address.lat, address.lng);
          if (distance <= 50) {
            defaultAddress.value = address;
            locationController.address.value = address.address;
            return;
          }
        }
      }
    } catch (e) {
      print('Error loading addresses: $e');
      customSnackBar.show(
          message: 'Failed to load addresses', type: SnackBarType.error);
    }
  }

  Future<AddressModel> getCurrentLocationAsAddress() async {
    final authController = Get.find<AuthController>();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    final p = placemarks.first;
    final model = AddressModel(
      address: "${p.name}, ${p.locality}, ${p.administrativeArea}",
      id: "",
      label: AddressType.home,
      additionalAddressInformation: '',
      lat: pos.latitude,
      lng: pos.longitude,
      receiverName: authController.user!.fullName,
      receiverPhone: authController.user!.phoneNumber,
    );

    return model;
  }

  Future<AddressModel?> geocodeAddressString(String q) async {
    final authController = Get.find<AuthController>();
    if (q.trim().isEmpty) return null;
    final locations = await locationFromAddress(q);
    if (locations.isEmpty) return null;
    final loc = locations.first;
    final placemarks =
        await placemarkFromCoordinates(loc.latitude, loc.longitude);
    final p = placemarks.first;
    return AddressModel(
      address: "${p.name}, ${p.locality}, ${p.administrativeArea}",
      id: "",
      label: AddressType.home,
      additionalAddressInformation: '',
      lat: loc.latitude,
      lng: loc.longitude,
      receiverName: authController.user!.fullName,
      receiverPhone: authController.user!.phoneNumber,
    );
  }

  Future<void> saveAddress(AddressModel a) async {
    try {
      final response = await addressService.addAddress(a);
      loadAddresses();
      defaultAddress.value = a;
      Get.back();
      Get.back();
    } catch (e) {
      print('Error saving address: $e');
      customSnackBar.show(
          message: 'Failed to save address', type: SnackBarType.error);
    }
  }
}
