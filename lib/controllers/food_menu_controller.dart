import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/services/image_service.dart';
import 'package:get/get.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';

class FoodMenuController extends GetxController {
  final MenuService _menuService = MenuService();
  final RxList<MenuModel> _menuItems = <MenuModel>[].obs;
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
      _menuItems.assignAll(items);
      await Future.wait(_menuItems.map((item) async {
        item.s3Url = await imageService.getFileUrl(item.imageUrl);
      }));
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

  selectFoodType(String type) {
    selectedFoodType.value = type;
    // Optionally, you can filter the menu items based on the selected food type
    if (type == 'All') {
      fetchMenuItems(); // Fetch all items
    } else {
      final finalType = type == "Veg" ? 'vegetarian' : 'non_vegetarian';
      _menuItems.value =
          _menuItems.where((item) => item.dietType == finalType).toList();
    }
  }

  selectPetType(String type) {
    selectedPetType.value = type;
    // Optionally, you can filter the menu items based on the selected pet type
    if (type == 'Dog') {
      _menuItems.value =
          _menuItems.where((item) => item.species == 'dog').toList();
    } else if (type == 'Cat') {
      _menuItems.value =
          _menuItems.where((item) => item.species == 'cat').toList();
    }
  }
}
