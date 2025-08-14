import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/services/image_service.dart';
import 'package:doggzi/widgets/meal_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';

class FoodMenuController extends GetxController {
  final MenuService _menuService = MenuService();
  final RxList<MenuModel> allMenuItems = <MenuModel>[].obs;
  final RxList<MenuModel> dogMeals = <MenuModel>[].obs;
  final RxList<MenuModel> catMeals = <MenuModel>[].obs;
  final RxList<MenuModel> dogTreats = <MenuModel>[].obs;
  Rx<DietType> selectedFoodType = DietType.all.obs;
  Rx<Species> selectedPetType = Species.dog.obs;
  Rx<FoodType> selectedFoodCategory = FoodType.all.obs;
  Rx<int> itemQuantity = 1.obs;
  final ImageService imageService = ImageService();
  RxBool isLoading = false.obs;

  final RxBool isDetailsSheetOpen = false.obs;

  Future<FoodMenuController> init() async {
    await fetchAllMenuItems();
    return this;
  }

  Future<void> fetchAllMenuItems() async {
    isLoading.value = true;
    try {
      final items = await _menuService.getAllMenuItems();
      allMenuItems.assignAll(items.completeMenu);
      if (dogMeals.isEmpty && catMeals.isEmpty && dogTreats.isEmpty) {
        dogMeals.assignAll(items.dogMeals);
        catMeals.assignAll(items.catMeals);
        dogTreats.assignAll(items.dogTreats);
      }
    } catch (e) {
      customSnackBar.show(
        message: "Failed to fetch menu items $e",
        type: SnackBarType.error,
      );
      print("Failed to fetch menu items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMenuItems() async {
    isLoading.value = true;
    try {
      final items = await _menuService.getMenuItems(
        selectedFoodType.value,
        selectedPetType.value,
        selectedFoodCategory.value,
      );
      allMenuItems.assignAll(items);
    } catch (e) {
      customSnackBar.show(
        message: "Failed to fetch menu items $e",
        type: SnackBarType.error,
      );
      print("Failed to fetch menu items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectFoodType(DietType type) {
    selectedFoodType.value = type;
    fetchMenuItems();
  }

  void selectPetType(Species type) {
    selectedPetType.value = type;
    fetchMenuItems();
  }

  void selectFoodCategory(FoodType type) {
    selectedFoodCategory.value = type;
    fetchMenuItems();
  }

  void showMenuItemDetails(MenuModel item) {
    Get.bottomSheet(
      MenuItemDetailsSheet(menu: item),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((_) {
      itemQuantity.value = 1;
      isDetailsSheetOpen.value = false;
    });
  }

  void resetFilters() {
    selectedFoodType.value = DietType.all;
    selectedPetType.value = Species.dog;
    selectedFoodCategory.value = FoodType.all;
  }
}
