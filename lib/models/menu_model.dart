import 'dart:convert';

/// Model representing a food product for a pet delivery app.
enum DietType {
  all,
  vegetarian,
  non_vegetarian,
}

enum Species { all, dog, cat }

class MenuModel {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final int price;
  final String species;
  final List<String> itemList;
  final String dietType;
  final bool freshlyCooked;
  final String imageUrl;
  final String s3Url;

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.species,
    required this.itemList,
    required this.dietType,
    required this.freshlyCooked,
    required this.imageUrl,
    required this.s3Url,
  });

  /// Creates a ProductModel from a JSON map.
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['_id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] ?? 0,
      price: json['price_per_gram'] ?? 0,
      species: json['species'] ?? Species.all,
      itemList: List<String>.from(json['item_list'] ?? []),
      dietType: json['diet_type'] as String,
      freshlyCooked: json['freshly_cooked'] as bool,
      imageUrl: json['image_url'] as String,
      s3Url: json['s3_url'] as String,
    );
  }

  /// Converts the ProductModel instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price_per_gram': price,
      'species': species,
      'item_list': itemList,
      'diet_type': dietType,
      'freshly_cooked': freshlyCooked,
      'image_url': imageUrl,
      's3_url': s3Url,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

class MenuModelList {
  final List<MenuModel> dogMeals;
  final List<MenuModel> catMeals;

  final List<MenuModel> dogTreats;
  final List<MenuModel> completeMenu;

  MenuModelList({
    required this.dogMeals,
    required this.catMeals,
    required this.dogTreats,
    required this.completeMenu,
  });

  factory MenuModelList.fromJson(Map<String, dynamic> json) {
    return MenuModelList(
      dogMeals: (json['dog_meals'] as List)
          .map((item) => MenuModel.fromJson(item))
          .toList(),
      catMeals: (json['cat_meals'] as List)
          .map((item) => MenuModel.fromJson(item))
          .toList(),
      dogTreats: (json['dog_treats'] as List)
          .map((item) => MenuModel.fromJson(item))
          .toList(),
      completeMenu: (json['all_menus'] as List)
          .map((item) => MenuModel.fromJson(item))
          .toList(),
    );
  }
}
