import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/services/address_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';
import 'auth_controller.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final addressService = AddressService();
  final AddressModel defaultAddress = AddressModel(
    address: '',
    id: '',
    additionalAddressInformation: '',
    label: AddressType.home,
    lat: 0.0,
    lng: 0.0,
    receiverName: '',
    receiverPhone: '',
  );

  final Rxn<AddressModel> selected = Rxn<AddressModel>();

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      final List<AddressModel> loadedAddresses =
          await addressService.getAddresses();
      addresses.assignAll(loadedAddresses);
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

  void saveAddress(AddressModel a) {}
}
