import 'package:atlas_admin/controllers/splash/splash_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController controller = Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.iconColor,
      body: Center(
        child: Text(
          'Atlas Admin',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
