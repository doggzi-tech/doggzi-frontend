// lib/models/pet_model.dart

class PetModel {
  final String id;
  final String name;
  final String species;
  final String breed;
  final int ageMonths;
  final double weightKg;
  final String gender;
  final String bodyCondition;
  final String physicalActivity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAllergic;
  final bool isNeuteredOrSpayed;
  final String dietaryRestrictions;

  PetModel({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageMonths,
    required this.weightKg,
    required this.gender,
    required this.bodyCondition,
    required this.physicalActivity,
    required this.createdAt,
    required this.updatedAt,
    required this.isAllergic,
    required this.isNeuteredOrSpayed,
    required this.dietaryRestrictions,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      ageMonths: json['age_months'] as int,
      weightKg: (json['weight_kg'] as num).toDouble(),
      gender: json['gender'] as String,
      bodyCondition: json['body_condition'] as String,
      physicalActivity: json['physical_activity'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isAllergic: json['is_allergic'] as bool? ?? false,
      isNeuteredOrSpayed: json['is_neutered_or_spayed'] as bool? ?? false,
      dietaryRestrictions: json['dietary_restrictions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'breed': breed,
        'age_months': ageMonths,
        'weight_kg': weightKg,
        'gender': gender,
        'body_condition': bodyCondition,
        'physical_activity': physicalActivity,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_allergic': isAllergic,
        'is_neutered_or_spayed': isNeuteredOrSpayed,
        'dietary_restrictions': dietaryRestrictions,
      };
}

class PetCreate {
  final String name;
  final String species;
  final String breed;
  final String dateOfBirth;
  final double weightKg;
  final String gender;
  final String bodyCondition;
  final String physicalActivity;
  final bool? isAllergic;
  final bool? isNeuteredOrSpayed;
  final String? dietaryRestrictions;

  PetCreate({
    required this.name,
    required this.species,
    required this.breed,
    required this.dateOfBirth,
    required this.weightKg,
    required this.gender,
    required this.bodyCondition,
    required this.physicalActivity,
    this.isAllergic,
    this.isNeuteredOrSpayed,
    this.dietaryRestrictions,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['species'] = species;
    map['breed'] = breed;
    map['date_of_birth'] = dateOfBirth;
    map["weight_kg"] = weightKg;
    map["gender"] = gender;
    map["body_condition"] = bodyCondition;
    map["physical_activity"] = physicalActivity;
    if (isAllergic != null) map["is_allergic"] = isAllergic;
    if (isNeuteredOrSpayed != null) {
      map["is_neutered_or_spayed"] = isNeuteredOrSpayed;
    }
    if (dietaryRestrictions != null) {
      map["dietary_restrictions"] = dietaryRestrictions;
    }

    return map;
  }
}

class PetUpdate {
  final String? name;
  final String? dateOfBirth;
  final double? weightKg;
  final String? bodyCondition;
  final String? physicalActivity;
  final bool? isAllergic;
  final bool? isNeuteredOrSpayed;
  final String? dietaryRestrictions;

  PetUpdate({
    this.name,
    this.dateOfBirth,
    this.weightKg,
    this.bodyCondition,
    this.physicalActivity,
    this.isAllergic,
    this.isNeuteredOrSpayed,
    this.dietaryRestrictions,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (dateOfBirth != null) map['date_of_birth'] = dateOfBirth;
    if (isAllergic != null) map['is_allergic'] = isAllergic;
    if (isNeuteredOrSpayed != null) {
      map['is_neutered_or_spayed'] = isNeuteredOrSpayed;
    }
    if (weightKg != null) map['weight_kg'] = weightKg;
    if (bodyCondition != null) map['body_condition'] = bodyCondition;
    if (physicalActivity != null) map['physical_activity'] = physicalActivity;
    // Exclude null values

    return map;
  }
}
