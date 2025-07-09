// GetX Controller
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  RxInt selectedIndex = 1.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
