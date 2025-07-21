import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/services/image_service.dart';
import 'package:get/get.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';

class FoodMenuController extends GetxController {
  final MenuService _menuService = MenuService();
  final RxList<MenuModel> _menuItems = <MenuModel>[].obs;
  final RxList<MenuModel> allMenuItems = <MenuModel>[].obs;
  final RxBool _isLoading = false.obs;

  List<MenuModel> get menuItems => _menuItems;

  bool get isLoading => _isLoading.value;

  RxString selectedFoodType = 'All'.obs;
  RxString selectedPetType = 'Dog'.obs;

  final ImageService imageService = ImageService();

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    _isLoading.value = true;
    try {
      final items = await _menuService.getMenuItems();
      allMenuItems.assignAll(items);

      // Apply current filters after fetching
      _applyFilters();
    } catch (e) {
      customSnackBar.show(
        message: "Failed to fetch menu items $e",
        type: SnackBarType.error,
      );
      print("Failed to fetch menu items: $e");
    } finally {
      _isLoading.value = false;
    }
  }

  void selectFoodType(String type) {
    selectedFoodType.value = type;
    _applyFilters();
  }

  void selectPetType(String type) {
    selectedPetType.value = type;
    _applyFilters();
  }

  void _applyFilters() {
    List<MenuModel> filtered = List<MenuModel>.from(allMenuItems);

    // Filter by pet type
    if (selectedPetType.value == 'Dog') {
      filtered = filtered.where((item) => item.species == 'dog').toList();
    } else if (selectedPetType.value == 'Cat') {
      filtered = filtered.where((item) => item.species == 'cat').toList();
    }

    // Filter by food type
    if (selectedFoodType.value != 'All') {
      final finalType =
          selectedFoodType.value == "Veg" ? 'vegetarian' : 'non_vegetarian';
      filtered = filtered.where((item) => item.dietType == finalType).toList();
    }

    _menuItems.assignAll(filtered);
  }
}
