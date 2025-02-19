import 'package:audience_atlas/controllers/splash/splash_controller.dart';
import 'package:audience_atlas/utils/import.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.iconColor,
        body: Center(
          child: Text(
            'Audience Atlas',
            style: TextStyle(fontSize: 24, color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
