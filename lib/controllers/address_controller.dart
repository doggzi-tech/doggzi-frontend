import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;

  final Rxn<AddressModel> selected = Rxn<AddressModel>();

  final RxString searchQuery = ''.obs;

  // Dummy loader to simulate fetch from DB
  Future<void> loadAddresses() async {
    // In production: call backend -> load from DB
    addresses.assignAll([
      AddressModel(
        id: '1',
        userId: 'u1',
        receiverName: 'Harshita',
        receiverPhone: '+91-7631056337',
        flat: 'Flat No. 101',
        area: 'Lohegaon',
        city: 'Pune',
        state: 'Maharashtra',
        postalCode: '411001',
        country: 'India',
        lat: 18.560,
        lng: 73.914,
        label: 'Home',
      ),
    ]);
  }

  Future<AddressModel> getCurrentLocationAsAddress() async {
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
      userId: 'u1',
      receiverName: '',
      // UI will ask for receiver details later
      receiverPhone: '',
      flat: '${p.subThoroughfare ?? ''} ${p.thoroughfare ?? ''}'.trim(),
      area: p.subLocality ?? p.locality ?? '',
      city: p.locality ?? '',
      state: p.administrativeArea ?? '',
      postalCode: p.postalCode ?? '',
      country: p.country ?? '',
      lat: pos.latitude,
      lng: pos.longitude,
    );

    return model;
  }

  Future<AddressModel?> geocodeAddressString(String q) async {
    if (q.trim().isEmpty) return null;
    final locations = await locationFromAddress(q);
    if (locations.isEmpty) return null;
    final loc = locations.first;
    final placemarks =
        await placemarkFromCoordinates(loc.latitude, loc.longitude);
    final p = placemarks.first;
    return AddressModel(
      userId: 'u1',
      receiverName: '',
      receiverPhone: '',
      flat: '${p.subThoroughfare ?? ''} ${p.thoroughfare ?? ''}'.trim(),
      area: p.subLocality ?? p.locality ?? '',
      city: p.locality ?? '',
      state: p.administrativeArea ?? '',
      postalCode: p.postalCode ?? '',
      country: p.country ?? '',
      lat: loc.latitude,
      lng: loc.longitude,
    );
  }

  void saveAddress(AddressModel a) {
    // In production: call backend to create and return created id
    if (a.id == null) {
      a.id = DateTime.now().millisecondsSinceEpoch.toString();
      addresses.insert(0, a);
    } else {
      final idx = addresses.indexWhere((e) => e.id == a.id);
      if (idx != -1) addresses[idx] = a;
    }
    addresses.refresh();
  }

  void setDefault(String id) {
    for (var a in addresses) {
      a.isDefault = a.id == id;
    }
    addresses.refresh();
  }
}
