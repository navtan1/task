import 'package:get/get.dart';

class BottomBar extends GetxController {
  var bottomIndex = 0.obs;

  changeIndex(int index) {
    bottomIndex.value = index;
  }
}
