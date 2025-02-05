import 'package:audience_atlas/controllers/login/login_controller.dart';
import 'package:audience_atlas/utils/import.dart';
import 'package:flutter/gestures.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_sharp),
              ),
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
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const Gap(20),
              Obx(() => TextFormField(
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
                  )),
              const Gap(30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.iconColor,
                  minimumSize: const Size(double.infinity, 54),
                ),
                onPressed: () {
                  Get.offAllNamed(Routes.navigation);
                  AppVariables.box.write(StorageKeys.isLoggedIn, true);
                },
                child: const Text('Login'),
              ),
              const Gap(20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(
                          color: AppColors.iconColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.back(),
                      ),
                    ],
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
