import 'package:atlas_admin/utils/import.dart';

class AdminProfileController extends GetxController {
  var name = 'Admin Name'.obs;
  var email = 'admin@example.com'.obs;
  var profileImage = ''.obs; // URL of profile image

  void updateProfile(String newName, String newEmail, String newImage) {
    name.value = newName;
    email.value = newEmail;
    profileImage.value = newImage;
  }

  void logout() {
    AppVariables.box.remove(StorageKeys.isLoggedIn);
    Get.offAllNamed(Routes.login);
  }
}
