enum AddressType {
  home,
  work,
  other,
}

class AddressModel {
  final String id;
  final String additionalAddressInformation;
  final String address;
  final AddressType label;
  final double lat;
  final double lng;
  final String receiverName;
  final String receiverPhone;
  final bool isDefault;

  AddressModel({
    required this.address,
    required this.id,
    required this.additionalAddressInformation,
    required this.label,
    required this.lat,
    required this.lng,
    required this.receiverName,
    required this.receiverPhone,
    this.isDefault = false,
  });

  /// Convert string to AddressType safely
  static AddressType _stringToAddressType(String? value) {
    switch (value?.toLowerCase()) {
      case 'home':
        return AddressType.home;
      case 'work':
        return AddressType.work;
      case 'other':
      default:
        return AddressType.other;
    }
  }

  /// Convert AddressType to string
  static String _addressTypeToString(AddressType type) {
    return type.toString().split('.').last;
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'] ?? '',
      id: json['id'] ?? '',
      additionalAddressInformation:
          json['additional_address_information'] ?? '',
      label: _stringToAddressType(json['label']),
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      receiverName: json['receiver_name'] ?? '',
      receiverPhone: json['receiver_phone'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'additional_address_information': additionalAddressInformation,
      'label': _addressTypeToString(label),
      'lat': lat,
      'lng': lng,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'is_default': isDefault,
    };
  }
}
