import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/services/image_service.dart';
import 'package:doggzi/widgets/meal_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';

class FoodMenuController extends GetxController {

  final QuantityController quantityController = QuantityController();


  final MenuService _menuService = MenuService();
  final RxList<MenuModel> allMenuItems = <MenuModel>[].obs;
  final RxList<MenuModel> homeMenuItems = <MenuModel>[].obs;

  final Rxn<MenuModel> selectedMenuItem = Rxn<MenuModel>();

  Rx<DietType> selectedFoodType = DietType.all.obs;
  Rx<Species> selectedPetType = Species.all.obs;

  final ImageService imageService = ImageService();
  RxBool isLoading = false.obs;

  final RxBool isDetailsSheetOpen = false.obs;



  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    isLoading.value = true;
    try {
      final items = await _menuService.getMenuItems(
        selectedFoodType.value,
        selectedPetType.value,
      );
      homeMenuItems.assignAll(items);
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
}

void showMenuItemDetails(MenuModel item) {
  final menuController = Get.find<FoodMenuController>();

  if (menuController.isDetailsSheetOpen.value) return;
  menuController.isDetailsSheetOpen.value = true;

  menuController.selectedMenuItem.value = item;

  Get.bottomSheet(
    MenuItemDetailsSheet(item: item),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  ).then((_) {
    menuController.selectedMenuItem.value = null;
    menuController.isDetailsSheetOpen.value = false;
    Get.find<FoodMenuController>().quantityController.reset(); 
  });
}

class QuantityController extends GetxController {
  var quantity = 1.obs;

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void reset() {
    quantity.value = 1;
  }
}