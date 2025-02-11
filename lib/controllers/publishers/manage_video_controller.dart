import 'package:atlas_admin/modals/video_modal.dart';
import 'package:atlas_admin/utils/import.dart';

class ManageVideoController extends GetxController {
  BuildContext ctx = Get.context!;
  String role = AppVariables.box.read(StorageKeys.role) ?? "Publisher";
  final String publisherId;
  RxBool isLoading = false.obs;
  RxBool loadingVideo = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<VideoModal> videos = <VideoModal>[].obs;
  RxList<VideoModal> filteredVideos = <VideoModal>[].obs;
  int page = 1;

  ManageVideoController({required this.publisherId});

  @override
  onInit() {
    super.onInit();
    getPublisherVideos();
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

  Future<void> deleteVideo(String videoId) async {
    try {
      loadingVideo.value = true;
      var res =
          await ApiService.deleteApi(Apis.deleteVideo(videoId: videoId), ctx);
      if (res != null) {
        Get.snackbar("Success", "Video deleted successfully!");
        getPublisherVideos();
      }
    } catch (e) {
      print('Error deleting video: $e');
    } finally {
      loadingVideo.value = false;
    }
  }

  void editVideo(String videoId) {
    String title = videos.firstWhere((element) => element.id == videoId).title;
    String videoPath =
        videos.firstWhere((element) => element.id == videoId).video;
    String thumbnailPath =
        videos.firstWhere((element) => element.id == videoId).thumbnail;

    Get.back();

    Get.toNamed(Routes.publishVideo, arguments: {
      'videoId': videoId,
      'title': title,
      'videoPath': '${Apis.serverAddress}/$videoPath',
      'thumbnailPath': '${Apis.serverAddress}/$thumbnailPath'
    });
  }
}
