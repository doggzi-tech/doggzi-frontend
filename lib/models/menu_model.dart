import 'dart:convert';

/// Model representing a food product for a pet delivery app.
class MenuModel {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final num pricePerGram;
  final String species;
  final num proteinPerGram;
  final num fatPercent;
  final num caloriesPerGram;
  final String dietType;
  final bool freshlyCooked;
  final String imageUrl;
  String s3Url = '';

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.pricePerGram,
    required this.species,
    required this.proteinPerGram,
    required this.fatPercent,
    required this.caloriesPerGram,
    required this.dietType,
    required this.freshlyCooked,
    required this.imageUrl,
  });

  /// Creates a ProductModel from a JSON map.
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['_id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      pricePerGram: json['price_per_gram'] as num,
      species: json['species'] as String,
      proteinPerGram: json['protein_per_gram'] as num,
      fatPercent: json['fat_percent'] as num,
      caloriesPerGram: json['calories_per_gram'] as num,
      dietType: json['diet_type'] as String,
      freshlyCooked: json['freshly_cooked'] as bool,
      imageUrl: json['image_url'] as String,
    );
  }

  /// Converts the ProductModel instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price_per_gram': pricePerGram,
      'species': species,
      'protein_per_gram': proteinPerGram,
      'fat_percent': fatPercent,
      'calories_per_gram': caloriesPerGram,
      'diet_type': dietType,
      'freshly_cooked': freshlyCooked,
      'image_url': imageUrl,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
