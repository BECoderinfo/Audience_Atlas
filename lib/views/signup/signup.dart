import 'package:audience_atlas/controllers/signup/signup_controller.dart';
import 'package:audience_atlas/utils/import.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.put(SignupController());

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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.iconColor,
                          ),
                        ),
                      ),
                      const Gap(30),
                      TextFormField(
                        controller: controller.userNameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Name',
                        ),
                        validator: (value) =>
                            controller.validateUsername(value!),
                      ),
                      const Gap(20),
                      TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Email',
                        ),
                        validator: (value) => controller.validateEmail(value!),
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
                            validator: (value) =>
                                controller.validatePassword(value!),
                          )),
                      const Gap(20),
                      Obx(() => TextFormField(
                            controller: controller.confirmPasswordController,
                            obscureText:
                                !controller.isConfirmPasswordVisible.value,
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                    controller.isConfirmPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                onPressed: () {
                                  controller.isConfirmPasswordVisible.toggle();
                                },
                              ),
                            ),
                            validator: (value) =>
                                controller.validateConfirmPassword(value!),
                          )),
                      const Gap(30),
                      Obx(() => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.iconColor,
                              minimumSize: const Size(double.infinity, 54),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.signUp(),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Sign Up'),
                          )),
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
