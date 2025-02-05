import 'package:audience_atlas/modals/video_modal/video_modal.dart';
import 'package:audience_atlas/utils/import.dart';

class PublisherDController extends GetxController {
  BuildContext ctx = Get.context!;
  final String publisherId;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<VideoModal> videos = <VideoModal>[].obs;
  RxList<VideoModal> filteredVideos = <VideoModal>[].obs;
  int page = 1;

  PublisherDController({required this.publisherId});

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      videos.clear();
      page = 1;
      var res =
          await ApiService.getApi(Apis.getVideos(publisher: publisherId), ctx);
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
      isLoading.value = false;
    }
  }

  Future<void> loadMoreVideos() async {
    if (isLoadingMore.value) return;
    try {
      isLoadingMore.value = true;
      page++;

      var res = await ApiService.getApi(
          Apis.getVideos(publisher: publisherId, page: page), ctx);

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
}
