import 'package:atlas_admin/utils/import.dart';
import 'package:atlas_admin/views/publishers/create_publisher.dart';
import 'package:atlas_admin/views/publishers/manage_video.dart';
import 'package:atlas_admin/views/publishers/publish_video.dart';
import 'package:atlas_admin/views/publishers/publisher_profile.dart';
import 'package:atlas_admin/views/publishers/update_publisher.dart';
import 'package:atlas_admin/views/publishers/video_player.dart';

class AppPages {
  AppPages._();

  static final initialRoute = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
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
    GetPage(
      name: Routes.updatePublisher,
      page: () => const UpdatePublisher(),
    ),
    GetPage(
      name: Routes.manageVideo,
      page: () => const ManageVideo(),
    ),
    GetPage(
      name: Routes.publishVideo,
      page: () => PublishVideo(),
    ),
    GetPage(
      name: Routes.viewVideo,
      page: () => const VideoPage(),
    ),
    GetPage(
      name: Routes.createPublisher,
      page: () => const CreatePublisher(),
    ),
  ];
}
