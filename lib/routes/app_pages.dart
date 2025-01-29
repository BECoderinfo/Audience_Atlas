import 'package:audience_atlas/utils/import.dart';
import 'package:audience_atlas/views/bio/bio.dart';

class AppPages {
  AppPages._();

  static final initialRoute =
      ((AppVariables.box.read(StorageKeys.isBiometric) ?? false) == true)
          ? Routes.biometric
          : Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.biometric,
      page: () => BiometricAuthScreen(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: Routes.intro,
      page: () => const Intro(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const Signup(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const Login(),
    ),
    GetPage(
      name: Routes.navigation,
      page: () => const Navigation(),
    ),
  ];
}
