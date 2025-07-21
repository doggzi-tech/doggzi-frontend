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
      };
}

class PetCreate {
  final String name;
  final String species;
  final String breed;
  final int ageMonths;
  final double weightKg;
  final String gender;
  final String bodyCondition;
  final String physicalActivity;

  PetCreate({
    required this.name,
    required this.species,
    required this.breed,
    required this.ageMonths,
    required this.weightKg,
    required this.gender,
    required this.bodyCondition,
    required this.physicalActivity,
  });

  factory PetCreate.fromJson(Map<String, dynamic> json) {
    return PetCreate(
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      ageMonths: json['age_months'] as int,
      weightKg: (json['weight_kg'] as num).toDouble(),
      gender: json['gender'] as String,
      bodyCondition: json['body_condition'] as String,
      physicalActivity: json['physical_activity'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'species': species,
        'breed': breed,
        'age_months': ageMonths,
        'weight_kg': weightKg,
        'gender': gender,
        'body_condition': bodyCondition,
        'physical_activity': physicalActivity,
      };
}

class PetUpdate {
  final String? name;
  final int? ageMonths;
  final double? weightKg;
  final String? bodyCondition;
  final String? physicalActivity;

  PetUpdate({
    this.name,
    this.ageMonths,
    this.weightKg,
    this.bodyCondition,
    this.physicalActivity,
  });

  factory PetUpdate.fromJson(Map<String, dynamic> json) {
    return PetUpdate(
      name: json['name'] as String?,
      ageMonths: json['age_months'] as int?,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      bodyCondition: json['body_condition'] as String?,
      physicalActivity: json['physical_activity'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (ageMonths != null) map['age_months'] = ageMonths;
    if (weightKg != null) map['weight_kg'] = weightKg;
    if (bodyCondition != null) map['body_condition'] = bodyCondition;
    if (physicalActivity != null) map['physical_activity'] = physicalActivity;
    return map;
  }
}
