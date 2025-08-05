import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/models/pet_model.dart';
import 'package:get/get.dart';

import '../services/pet_service.dart';

class PetController extends GetxController {
  RxList<PetModel> pets = <PetModel>[].obs;
  RxBool isLoading = true.obs;
  RxString error = ''.obs;
  final PetService petService = PetService();

  @override
  void onInit() {
    super.onInit();
    fetchPets();
  }

  Future<void> fetchPets() async {
    isLoading.value = true;
    error.value = '';
    try {
      pets.value = await petService.listPets();
    } catch (e) {
      customSnackBar.show(message: "Failed to fetch pets: ${e.toString()}");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
