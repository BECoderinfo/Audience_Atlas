import 'package:atlas_admin/modals/video_modal.dart';
import 'package:atlas_admin/utils/import.dart';

import '../../modals/publisher_modal.dart';

class PublisherProfileController extends GetxController {
  BuildContext ctx = Get.context!;
  String role = AppVariables.box.read(StorageKeys.role) ?? "Publisher";
  final String publisherId;
  RxBool isLoading = false.obs;

  Rxn<PublisherModal> publisher = Rxn<PublisherModal>();

  RxBool loadingVideo = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<VideoModal> videos = <VideoModal>[].obs;
  RxList<VideoModal> filteredVideos = <VideoModal>[].obs;
  int page = 1;

  PublisherProfileController({required this.publisherId});

  @override
  void onInit() {
    super.onInit();
    getPublisher();
    getPublisherVideos();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshData() async {
    getPublisher();
    getPublisherVideos();
  }

  Future<void> getPublisher() async {
    try {
      isLoading.value = true;
      var res = await ApiService.getApi(
          Apis.getPublisherById(publisherId: publisherId), ctx);
      if (res != null) {
        publisher.value = PublisherModal.fromJson(res);
      }
    } catch (e) {
      print('Error fetching publisher: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPublisherVideos() async {
    try {
      loadingVideo.value = true;
      videos.clear();
      page = 1;
      var res = await ApiService.getApi(
          Apis.getVideos(page: page, publisher: publisherId), ctx);
      if (res != null && res['videos'] != null) {
        List<VideoModal> newVideos = res['videos']
            .map<VideoModal>((e) => VideoModal.fromJson(e))
            .toList();
        videos.addAll(newVideos);
        filteredVideos.assignAll(videos);
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      loadingVideo.value = false;
    }
  }

  Future<void> loadMoreVideos() async {
    if (isLoadingMore.value) return;
    try {
      isLoadingMore.value = true;
      page++;

      var res = await ApiService.getApi(
          Apis.getVideos(page: page, publisher: publisherId), ctx);

      if (res != null && res['videos'] != null) {
        List<VideoModal> newVideos = res['videos']
            .map<VideoModal>((e) => VideoModal.fromJson(e))
            .toList();

        // ✅ Remove duplicates before adding new videos
        for (var video in newVideos) {
          if (!videos.any((v) => v.id == video.id)) {
            videos.add(video);
          }
        }

        // ✅ Update filtered list
        filteredVideos.assignAll(videos);
      }
    } catch (e) {
      print('Error loading more videos: $e');
    } finally {
      isLoadingMore.value = false;
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
