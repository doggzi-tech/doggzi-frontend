import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final RxBool _isListening = false.obs;
  final RxString address = "".obs;

  Position? get currentPosition => _currentPosition.value;

  bool get isListening => _isListening.value;

  Stream<Position>? _positionStream;

  Future<LocationController> init() async {
    await _initLocationService();
    return this;
  }

  Future<void> _initLocationService() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    await getCurrentLocation();
    // startListening();
  }

  Future<bool> _handlePermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      customSnackBar.show(
        message:
            'Location permission is permanently denied. Please enable it in settings.',
        type: SnackBarType.error,
      );
      await openAppSettings();
      return false;
    } else {
      Get.snackbar('Permission Denied', 'Location permission is required.');
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition.value = position;
      getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Location Error', 'Failed to get location: $e');
    }
  }

  void startListening() {
    if (_isListening.value) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // minimum distance in meters before update
      ),
    );

    _positionStream!.listen((Position position) {
      _currentPosition.value = position;
    });

    _isListening.value = true;
  }

  void stopListening() {
    _positionStream = null;
    _isListening.value = false;
  }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address.value =
            '${place.street}, ${place.locality}, ${place.postalCode}';
      } else {
        print('No address found');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }
}