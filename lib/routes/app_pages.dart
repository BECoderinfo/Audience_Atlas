import 'package:atlas_admin/utils/import.dart';
import 'package:atlas_admin/views/publishers/publisher_profile.dart';

class AppPages {
  AppPages._();

  static final initialRoute = Routes.dashboard;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const Dashboard(),
    ),
    GetPage(
      name: Routes.publishers,
      page: () => const Publishers(),
    ),
    GetPage(
      name: Routes.publisherProfile,
      page: () => const PublisherProfile(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const AdminProfilePage(),
    ),
  ];
}
