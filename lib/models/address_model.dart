import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddressModel {
  String? id;
  String userId;
  String receiverName;
  String receiverPhone;
  String flat;
  String area;
  String city;
  String state;
  String postalCode;
  String country;
  String? landmark;
  double lat;
  double lng;
  String label; // Home / Work / Other
  String? instructions;
  bool isDefault;

  AddressModel({
    this.id,
    required this.userId,
    required this.receiverName,
    required this.receiverPhone,
    required this.flat,
    required this.area,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.landmark,
    required this.lat,
    required this.lng,
    this.label = 'Home',
    this.instructions,
    this.isDefault = false,
  });
}
