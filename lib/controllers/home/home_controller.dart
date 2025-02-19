import 'package:audience_atlas/modals/video_modal/video_modal.dart';
import 'package:audience_atlas/utils/import.dart';
import 'dart:async';

class HomeController extends GetxController {
  BuildContext ctx = Get.context!;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isSearching = false.obs;
  RxList<VideoModal> videos = <VideoModal>[].obs;
  RxList<VideoModal> filteredVideos = <VideoModal>[].obs;
  int page = 1;
  Timer? _debounce;

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

      var res = await ApiService.getApi(
          Apis.getVideos(page: page, random: false), ctx);
      if (res != null && res['videos'] != null) {
        List<VideoModal> newVideos = res['videos']
            .map<VideoModal>((e) => VideoModal.fromJson(e))
            .toList();

        videos.assignAll(newVideos);
        filteredVideos.assignAll(newVideos);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load videos');
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
          Apis.getVideos(page: page, random: true), ctx);
      if (res != null && res['videos'] != null) {
        List<VideoModal> newVideos = res['videos']
            .map<VideoModal>((e) => VideoModal.fromJson(e))
            .toList();

        // ✅ Prevent duplicates
        newVideos
            .removeWhere((newVideo) => videos.any((v) => v.id == newVideo.id));

        videos.addAll(newVideos);
        filteredVideos.assignAll(videos);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more videos');
      print('Error loading more videos: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void searchVideos(String query) {
    try {
      isSearching.value = true;
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (query.isEmpty) {
          filteredVideos.assignAll(videos);
        } else {
          filteredVideos.assignAll(
            videos
                .where((video) =>
                video.title.toLowerCase().contains(query.toLowerCase()))
                .toList(),
          );
        }
      });
    } catch (e) {
      print('Error searching videos: $e');
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    filteredVideos.assignAll(videos);
  }
}
