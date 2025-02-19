import 'package:audience_atlas/utils/import.dart';

class NavigationController extends GetxController {
  RxInt pageNo = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changePage(int index) {
    pageNo.value = index;
  }
}
