import 'package:atlas_admin/utils/import.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    3.delay().then(
      (value) {
        log("${AppVariables.box.read(StorageKeys.isLoggedIn)}");

        if (AppVariables.box.read(StorageKeys.isLoggedIn) ?? false) {
          if ((AppVariables.box.read(StorageKeys.role) ?? "Admin") == "Admin") {
            Get.offAllNamed(Routes.dashboard);
          } else {
            Get.offAllNamed(Routes.publisherProfile, arguments: {
              'publisherId': AppVariables.box.read(StorageKeys.aId)
            });
          }
        } else {
          Get.offNamed(Routes.login);
        }
      },
    );
  }
}
