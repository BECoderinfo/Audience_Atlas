import 'dart:developer';

import 'package:audience_atlas/utils/import.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController extends GetxController {
  BuildContext context = Get.context!;

  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isPasswordVisible = false.obs; // 👈 Show/Hide Password
  RxBool isConfirmPasswordVisible = false.obs; // 👈 Show/Hide Confirm Password

  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  String? validateUsername(String value) {
    if (value.isEmpty) return 'Please enter username';
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter email';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Please enter password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) return 'Please confirm password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  /// **User Sign-Up**
  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return; // Stop if validation fails

    isLoading.value = true;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        var res = await signupApi(userCredential: userCredential);

        if (res != null) {
          Get.offAllNamed(Routes.login);
        }
      }
    } catch (error) {
      log("Sign-up error: $error");
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 3),
        message: error.toString(),
      ));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  signupApi({required UserCredential userCredential}) async {
    log(userCredential.user!.displayName.toString());
    var response = await ApiService.postApi(
      Apis.createUser,
      context,
      body: {
        'name': userNameController.text,
        'email': userCredential.user!.email,
        'password': userCredential.user!.uid,
      },
    );

    return response;
  }
}
