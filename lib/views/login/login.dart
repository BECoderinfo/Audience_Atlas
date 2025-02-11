import 'package:atlas_admin/controllers/login/login_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              const Gap(30),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.iconColor,
                  ),
                ),
              ),
              const Gap(30),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (controller.emailController.text.isEmpty) {
                    return "please enter email";
                  } else if (!GetUtils.isEmail(
                      controller.emailController.text)) {
                    return "please enter valid email";
                  }
                  return null;
                },
              ),
              const Gap(20),
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        controller.isPasswordVisible.toggle();
                      },
                    ),
                  ),
                  validator: (value) {
                    if (controller.passwordController.text.isEmpty) {
                      return "please enter password";
                    } else if (controller.passwordController.text.length < 6) {
                      return "please enter valid password";
                    }
                    return null;
                  },
                ),
              ),
              const Gap(30),
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.iconColor,
                    minimumSize: const Size(double.infinity, 54),
                  ),
                  onPressed: () {
                    controller.login();
                  },
                  child: (controller.isLoading.value)
                      ? CircularProgressIndicator()
                      : Text(
                          'Login',
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
