import 'package:audience_atlas/utils/import.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    3.delay().then(
      (value) {
        if (AppVariables.box.read(StorageKeys.isLoggedIn) ?? false) {
          navigationBar();
        } else {
          navigateToIntro();
        }
      },
    );
  }

  void navigateToIntro() => Get.offNamed(Routes.intro);

  void navigateToLogin() => Get.offNamed(Routes.login);

  void navigationBar() => Get.offAllNamed(Routes.navigation);
}
