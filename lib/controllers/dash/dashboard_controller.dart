import 'package:atlas_admin/services/api_service.dart';
import 'package:atlas_admin/utils/import.dart';

class DashboardController extends GetxController {
  BuildContext ctx = Get.context!;
  RxString totalVideo = '0'.obs;
  RxString totalPublisher = '0'.obs;
  RxString totalUser = '0'.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDashboardData();
  }

  void getDashboardData() async {
    try {
      isLoading.value = true;
      var res = await ApiService.getApi(Apis.getDashboardData, ctx);
      if (res != null) {
        totalVideo.value = res['totalVideos'].toString();
        totalPublisher.value = res['totalPublishers'].toString();
        totalUser.value = res['totalUsers'].toString();
      }
      update();
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to fetch dashboard data: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to log out?",
      middleTextStyle: const TextStyle(fontSize: 16),
      backgroundColor: Colors.white,
      radius: 8,
      barrierDismissible: false,
      // Prevents dismissing by tapping outside
      actions: [
        TextButton(
          onPressed: () => Get.back(), // Close dialog
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog first
            logoutUser(); // Call logout function
          },
          child: const Text("Logout"),
        ),
      ],
    );
  }

  /// Your logout function
  void logoutUser() {
    AppVariables.box.remove(StorageKeys.isLoggedIn);
    AppVariables.box.remove(StorageKeys.aId);
    AppVariables.box.remove(StorageKeys.role);
    Get.offAllNamed(
      Routes.login,
    );
  }
}
