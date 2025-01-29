import 'dart:developer';

import 'package:audience_atlas/utils/import.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isBioOn = false.obs;

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> authenticate() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        isBioOn.value = false;
        Get.showSnackbar(GetSnackBar(
            // animationDuration: Duration(milliseconds: 300),
            duration: Duration(seconds: 3),
            message:
                'Biometric authentication is not available or device is not supported'));
        return;
      }
      isLoading.value = true;
      final bool authenticated = await _localAuth.authenticate(
        localizedReason:
            (!isBioOn.value) ? 'Enable Biometric' : 'Disable Biometric',
      );
      isLoading.value = false;
      if (authenticated) {
        isBioOn.value = !isBioOn.value;
        AppVariables.box.write(StorageKeys.isBiometric, isBioOn.value);
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isBioOn.value = AppVariables.box.read(StorageKeys.isBiometric) ?? false;
  }

  void updateBio() {
    authenticate();
  }

  void logout() async {
    try {
      await GoogleSignIn().signOut(); // Sign out from Google
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase

      // Clear stored data
      AppVariables.box.remove(StorageKeys.isLoggedIn);
      AppVariables.box.remove(StorageKeys.aId);
      AppVariables.box.remove(StorageKeys.aName);
      AppVariables.box.remove(StorageKeys.aEmail);
      AppVariables.box.remove(StorageKeys.aImage);
      AppVariables.box.remove(StorageKeys.aPhone);

      Get.offAllNamed(Routes.intro); // Navigate back to the login page
    } catch (e) {
      log("Error signing out: $e");
      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 3),
          message: 'Sign out failed: $e',
        ),
      );
    }
  }
}
