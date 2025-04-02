import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var pageIndex = 0.obs;

  void changeIndex(int index) {
    pageIndex.value = index;
  }
}
