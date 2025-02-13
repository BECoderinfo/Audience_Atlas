import 'package:audience_atlas/modals/video_modal/video_modal.dart';
import 'package:audience_atlas/utils/import.dart';

class PublisherDController extends GetxController {
  RxString status = 'Subscribe'.obs;
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

      // ✅ Ensure `subList` is always a List<String>
      List<String> subList =
          (AppVariables.box.read(StorageKeys.subList) as List<dynamic>?)
                  ?.cast<String>() ??
              [];

      status.value =
          subList.contains(publisherId) ? 'Unsubscribe' : 'Subscribe';

      videos.clear();
      page = 1;
      var res = await ApiService.getApi(
          Apis.getVideos(publisher: publisherId), Get.context!);

      if (res != null && res['videos'] != null) {
        List<VideoModal> newVideos = res['videos']
            .map<VideoModal>((e) => VideoModal.fromJson(e))
            .toList();
        videos.assignAll(newVideos);
        filteredVideos.assignAll(videos);
      }
    } catch (e) {
      log('Error fetching data: $e');
      Get.snackbar('Error', 'Failed to load videos');
    } finally {
      isLoading.value = false;
    }
  }

  void subscribe() async {
    try {
      var res = await ApiService.putApi(
        Apis.subscribeUnsubscribe(publisherId: publisherId),
        Get.context!,
        body: {"userId": AppVariables.box.read(StorageKeys.aId)},
      );

      if (res != null) {
        List<String> subList =
            (AppVariables.box.read(StorageKeys.subList) as List<dynamic>?)
                    ?.cast<String>() ??
                [];

        if (subList.contains(publisherId)) {
          subList.remove(publisherId);
          status.value = 'Subscribe';
        } else {
          subList.add(publisherId);
          status.value = 'Unsubscribe';
        }

        AppVariables.box.write(StorageKeys.subList, subList);
        update(); // ✅ Only one update call needed
      }
    } catch (e) {
      log('Error subscribing: $e');
      Get.snackbar('Error', 'Subscription failed');
    }
  }

  Future<void> loadMoreVideos() async {
    if (isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      page++;

      var res = await ApiService.getApi(
        Apis.getVideos(publisher: publisherId, page: page),
        Get.context!,
      );

      if (res != null && res['videos'] != null) {
        List<VideoModal> newVideos = res['videos']
            .map<VideoModal>((e) => VideoModal.fromJson(e))
            .toList();

        // ✅ Remove duplicates before adding new videos
        videos.addAll(
            newVideos.where((video) => !videos.any((v) => v.id == video.id)));

        // ✅ Update filtered list
        filteredVideos.assignAll(videos);
      }
    } catch (e) {
      log('Error loading more videos: $e');
      Get.snackbar('Error', 'Could not load more videos');
    } finally {
      isLoadingMore.value = false;
    }
  }
}
