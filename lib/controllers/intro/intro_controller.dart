import 'dart:developer';

import 'package:audience_atlas/services/api_service.dart';
import 'package:audience_atlas/utils/import.dart';

class IntroController extends GetxController {
  final BuildContext context;
  RxInt index = 0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  IntroController({required this.context});

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

        var res = await findUser(userCredential: userCredential);

        if (res == null) {
          throw 'error connecting to server';
        }
        if (res) {
          var res = await loginApi(userCredential: userCredential);

          if (res != null) {
            AppVariables.box
                .write(StorageKeys.aId, res['user']['id'].toString());

            AppVariables.box
                .write(StorageKeys.subList, res['user']['subscriptions'] ?? []);
          }
        } else {
          var res = await signupApi(userCredential: userCredential);

          if (res != null) {
            AppVariables.box
                .write(StorageKeys.aId, res['user']['id'].toString());

            AppVariables.box.write(StorageKeys.subList, []);
          }
        }

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
      log('${e.toString()}--------sadasdfasd');
      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 3),
          message: 'Google Sign-In Failed: $e',
        ),
      );
    }
  }

  findUser({required UserCredential userCredential}) async {
    var response = await ApiService.getApi(
      Apis.getUserByEmail(email: userCredential.user!.email.toString()),
      context,
    );

    log(response['message'].toString());

    if (response == null) {
      return null;
    } else if (response['message'] == "User found") {
      return true;
    } else {
      return false;
    }
  }

  signupApi({required UserCredential userCredential}) async {
    var response = await ApiService.postApi(
      Apis.createUser,
      context,
      body: {
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'password': userCredential.user!.uid,
      },
    );

    return response;
  }

  loginApi({required UserCredential userCredential}) async {
    var response = await ApiService.postApi(
      Apis.login,
      context,
      body: {
        'email': userCredential.user!.email.toString(),
        'password': userCredential.user!.uid.toString(),
      },
    );

    return response;
  }
}
