import 'dart:convert';

/// Model representing a food product for a pet delivery app.
enum DietType {
  all,
  vegetarian,
  non_vegetarian,
}

enum FoodType {
  all,
  meals,
  treats,
}

enum Species { all, dog, cat }

class MenuModel {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String species;
  final List<String> itemList;
  final String dietType;
  final FoodType foodType;
  final bool freshlyCooked;
  final String imageUrl;
  final String s3Url;

  MenuModel({
    required this.foodType,
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
      foodType: json['food_type'] == 'meals' ? FoodType.meals : FoodType.treats,
      id: json['_id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      species: json['species'] ?? Species.all,
      itemList: List<String>.from(json['item_list'] ?? []),
      dietType: json['diet_type'] as String,
      freshlyCooked: json['freshly_cooked'] as bool,
      imageUrl: json['image_url'] as String,
      s3Url: json['s3_url'] as String,
    );
  }
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
