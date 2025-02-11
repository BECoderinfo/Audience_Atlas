import 'package:atlas_admin/utils/import.dart';

class LoginController extends GetxController {
  BuildContext ctx = Get.context!;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;

  void login() async {
    try {
      isLoading = true.obs;
      update();

      if (formKey.currentState!.validate()) {
        var res = await ApiService.postApi(Apis.adminLogin, ctx, body: {
          'email': emailController.text,
          'password': passwordController.text
        });

        if (res != null) {
          if (res['role'] == "admin") {
            AppVariables.box.write(StorageKeys.role, "Admin");
            AppVariables.box.write(StorageKeys.isLoggedIn, true);
            AppVariables.box.write(StorageKeys.aId, res['user']['_id']);
            Get.offAllNamed(Routes.dashboard);
          } else {
            AppVariables.box.write(StorageKeys.role, "Publisher");
            AppVariables.box.write(StorageKeys.isLoggedIn, true);
            AppVariables.box.write(StorageKeys.aId, res['user']['_id']);
            Get.offAllNamed(Routes.publisherProfile,
                arguments: {'publisherId': res['user']['_id']});
          }
        }
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to login: $e");
    } finally {
      isLoading = false.obs;
      update();
    }
  }
}
