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
    await fetchLocationOptimized();
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

  Future<void> fetchLocationOptimized() async {
    try {
      // 1. Get last known location first (instant if available)
      final lastKnown = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: false,
      );
      if (lastKnown != null) {
        // Check if cached location is fresh (less than 30 minutes old)
        final locationAge = DateTime.now().difference(lastKnown.timestamp);
        if (locationAge.inMinutes < 60) {
          print("Using cached location");
          _updatePosition(lastKnown);
        } else {
          print("Cached location is too old, fetching new location");
          final mediumAccuracyPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
          );
          _updatePosition(mediumAccuracyPosition);
          print("Got medium accuracy location");
        }
      }
      Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10), // Added timeout
      ).then((highAccuracyPosition) {
        _updatePosition(highAccuracyPosition);
        print("Updated with high accuracy location");
      }).catchError((e) {
        print("Failed to get high accuracy location: $e");
      });
    } catch (e) {
      print("Location fetch error: $e");
      // Only show an error if we failed to get any location at all
      if (_currentPosition.value == null) {
        Get.snackbar('Location Error', 'Failed to get location: $e');
      }
    }
  }

  void _updatePosition(Position position) {
    _currentPosition.value = position;
    getAddressFromLatLng(position.latitude, position.longitude);
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
      _updatePosition(position);
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
