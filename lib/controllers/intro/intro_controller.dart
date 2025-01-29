import 'dart:developer';

import 'package:audience_atlas/utils/import.dart';

class IntroController extends GetxController {
  RxInt index = 0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    index.value = (AppVariables.box.read(StorageKeys.opened) ?? false) ? 2 : 0;

    AppVariables.box.write(StorageKeys.opened, true);
  }

  googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        AppVariables.box.write(StorageKeys.isLoggedIn, true);
        AppVariables.box.write(StorageKeys.aId, userCredential.user!.uid);
        AppVariables.box
            .write(StorageKeys.aName, userCredential.user!.displayName);
        AppVariables.box.write(StorageKeys.aEmail, userCredential.user!.email);
        AppVariables.box
            .write(StorageKeys.aImage, userCredential.user!.photoURL);
        AppVariables.box
            .write(StorageKeys.aPhone, userCredential.user!.phoneNumber);

        Get.offAllNamed(Routes.navigation);
      } else {
        Get.showSnackbar(
          GetSnackBar(
            duration: Duration(seconds: 3),
            message: 'Something went wrong',
          ),
        );
      }
    } catch (e) {
      log(e.toString());
      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 3),
          message: 'Google Sign-In Failed: $e',
        ),
      );
    }
  }
}
