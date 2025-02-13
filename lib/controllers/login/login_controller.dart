import 'package:audience_atlas/utils/import.dart';

class LoginController extends GetxController {
  BuildContext ctx = Get.context!;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  /// **Form Validation**
  String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter email';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Please enter password';
    return null;
  }

  /// **User Login**
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return; // Stop if validation fails

    isLoading.value = true;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Store login state
        AppVariables.box.write(StorageKeys.isLoggedIn, true);
        AppVariables.box.write(StorageKeys.aEmail, userCredential.user!.email);

        var user = await findUser(userCredential: userCredential);
        if (user == null) {
          Get.showSnackbar(
            GetSnackBar(
              duration: Duration(seconds: 3),
              message: 'unexpected error occurred. Please try again',
            ),
          );
          return;
        } else if (user == false) {
          Get.showSnackbar(
            GetSnackBar(
              duration: Duration(seconds: 3),
              message: 'User not found. Sign up to create an account',
            ),
          );
          return;
        } else {
          log(user['user']['_id']);
          AppVariables.box.write(StorageKeys.aId, user['user']['_id']);
          AppVariables.box.write(StorageKeys.aName, user['user']['name']);
          AppVariables.box.write(StorageKeys.aImage, user['user']['image']);
          AppVariables.box
              .write(StorageKeys.subList, user['user']['subscriptions'] ?? []);

          // Navigate to home
          Get.offAllNamed(Routes.navigation);
        }
      }
    } on FirebaseAuthException catch (e) {
      log("Login error: ${e.message}");
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 3),
        message: e.message ?? "Login failed",
      ));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  findUser({required UserCredential userCredential}) async {
    var response = await ApiService.getApi(
      Apis.getUserByEmail(email: userCredential.user!.email.toString()),
      ctx,
    );

    log(response.toString());

    if (response == null) {
      return null;
    } else if (response['message'] == "User found") {
      return response;
    } else {
      return false;
    }
  }
}
