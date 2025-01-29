import 'dart:developer';
import 'package:audience_atlas/utils/import.dart';

class LoginController extends GetxController {
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
        AppVariables.box.write(StorageKeys.aId, userCredential.user!.uid);
        AppVariables.box.write(StorageKeys.aEmail, userCredential.user!.email);

        Get.offAllNamed(Routes.navigation); // Navigate to home
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
}
