// quantity_controller.dart
import 'package:get/get.dart';

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
