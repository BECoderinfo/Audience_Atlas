import 'package:audience_atlas/controllers/intro/intro_controller.dart';
import 'package:audience_atlas/utils/import.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    final int count = Get.arguments ?? 0;
    IntroController controller = Get.put(IntroController());
    return Scaffold(
      body: Container(
        color: AppColors.whiteColor,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.iconColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(170),
                    bottomRight: Radius.circular(170),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Gap(10),
                    Text(
                      'Audience Atlas',
                      style:
                          TextStyle(fontSize: 24, color: AppColors.blackColor),
                    ),
                    Gap(10),
                    Text(
                      'Find your audience and connect with them like never before.',
                      style:
                          TextStyle(fontSize: 16, color: AppColors.blackColor),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Obx(
                      () => Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: controller.index.value != 0
                                  ? AppColors.greyColor
                                  : AppColors.iconColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: controller.index.value != 1
                                  ? AppColors.greyColor
                                  : AppColors.iconColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: controller.index.value != 2
                                  ? AppColors.greyColor
                                  : AppColors.iconColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Obx(
                        () => controller.index.value == 2
                            ? Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.register);
                                    },
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.iconColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Login with Email',
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      // Text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 2,
                                      // Subtle shadow
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      minimumSize: const Size(double.infinity,
                                          54), // Full-width button
                                    ),
                                    onPressed: () {
                                      controller.googleSignIn();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/crypto%2Fsearch%20(2).png?alt=media&token=24a918f7-3564-4290-b7e4-08ff54b3c94c",
                                          width: 20,
                                        ),
                                        const SizedBox(width: 20),
                                        const Text(
                                          'Sign in with Google',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.index.value =
                                          controller.index.value + 1;
                                    },
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
