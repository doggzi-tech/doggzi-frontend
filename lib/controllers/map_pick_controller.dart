// map_pick_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/address_model.dart';
import '../../controllers/address_controller.dart';
import 'package:geocoding/geocoding.dart';

class MapPickController extends GetxController {
  final AddressController addressController = Get.find();

  // Google map controller (cached)
  final Rxn<GoogleMapController> mapController = Rxn<GoogleMapController>();

  // Current center candidate address (reactive)
  final Rxn<AddressModel> candidate = Rxn<AddressModel>();

  // Initial camera (default to Pune), can be overridden via args in page
  final Rx<CameraPosition> initialCamera = CameraPosition(
    target: const LatLng(18.5204, 73.8567),
    zoom: 14,
  ).obs;

  // Search text controller (UI)
  final TextEditingController searchController = TextEditingController();

  // Debounce timer to avoid many reverse-geocode calls while camera moves
  Timer? _debounce;

  // store last latlng during camera move
  LatLng? _pendingLatLng;

  // flag to indicate reverse-geocode in progress
  final RxBool _isResolving = false.obs;

  bool get isResolving => _isResolving.value;

  @override
  void onInit() {
    super.onInit();
    moveToCurrentLocation();
  }

  /// Attach map controller when map is created
  void onMapCreated(GoogleMapController ctrl) {
    mapController.value = ctrl;
  }

  /// called when camera moves -> debounce the reverse geocode
  void onCameraMove(CameraPosition pos) {
    _pendingLatLng = pos.target;

    // cancel previous debounce
    _debounce?.cancel();

    // start new debounce
    _debounce = Timer(const Duration(milliseconds: 700), () {
      if (_pendingLatLng != null) {
        _resolveLatLngToAddress(_pendingLatLng!);
      }
    });
  }

  /// call reverse geocode once
  Future<void> _resolveLatLngToAddress(LatLng latlng) async {
    _isResolving.value = true;
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latlng.latitude, latlng.longitude);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final newAddress = AddressModel(
          address: "${p.name}, ${p.locality}, ${p.administrativeArea}",
          id: '',
          additionalAddressInformation: '',
          label: AddressType.home,
          lat: latlng.latitude,
          lng: latlng.longitude,
          receiverName: '',
          receiverPhone: '',
          isDefault: false,
        );
        candidate.value = newAddress;
      }
    } catch (e) {
      debugPrint('Reverse geocode failed: $e');
    } finally {
      _isResolving.value = false;
    }
  }

  /// Search query submitted by user
  Future<void> onSearchSubmitted(String q) async {
    final trimmed = q.trim();
    if (trimmed.isEmpty) return;

    try {
      final res = await addressController.geocodeAddressString(trimmed);
      if (res != null) {
        candidate.value = res;
        // animate map to new pos if controller ready
        final ctrl = mapController.value;
        if (ctrl != null) {
          await ctrl.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(res.lat, res.lng), zoom: 17),
          ));
        }
      } else {
        Get.snackbar('Not found', 'Could not find address');
      }
    } catch (e) {
      Get.snackbar('Search Error', e.toString());
    }
  }

  /// Move map to user's current location via AddressController helper
  Future<void> moveToCurrentLocation() async {
    try {
      final current = await addressController.getCurrentLocationAsAddress();
      candidate.value = current;
      final ctrl = mapController.value;
      if (ctrl != null) {
        await ctrl.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(current.lat, current.lng), 17));
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Proceed to address form with the candidate
  void proceed() {
    if (candidate.value == null) {
      Get.snackbar('No location', 'Pick a location first.');
      return;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
