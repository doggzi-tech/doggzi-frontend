import 'package:doggzi/controllers/pet_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:get/get.dart';

import '../models/pet_model.dart';
import '../services/pet_service.dart';

class PetOnboardingController extends GetxController {
  Rx<PetCreate> petOnboarding = PetCreate(
    bodyCondition: '',
    breed: '',
    dateOfBirth: "",
    gender: '',
    name: '',
    physicalActivity: '',
    species: '',
    weightKg: 0.0,
    isNeuteredOrSpayed: false,
  ).obs;
  final petService = PetService();
  final petController = Get.find<PetController>();

  Future<void> completePetOnboarding() async {
    try {
      await petService.createPet(petOnboarding.value);
      petController.fetchPets();
      Get.offAllNamed(AppRoutes.mainPage);
    } catch (e) {
      print("$e");
      customSnackBar.show(message: "$e");
    }
  }
}
