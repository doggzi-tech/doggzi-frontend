// GetX Controller
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  RxInt selectedIndex = 3.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
