import 'package:atlas_admin/utils/import.dart';
import 'package:file_picker/file_picker.dart';

class PublishVideoController extends GetxController {
  BuildContext ctx = Get.context!;

  RxBool isLoading = false.obs;
  RxString selectedVideoPath = ''.obs; // Stores local file path
  RxString selectedVideoUrl = ''.obs; // Stores network URL
  RxString thumbnailPath = ''.obs; // Stores local file path
  RxString thumbnailUrl = ''.obs; // Stores network URL

  TextEditingController videoTitleController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    String? videoId = Get.arguments?['videoId'];
    if (videoId != null) {
      loadExistingVideo(videoId);
    }
  }

  /// Picks a video from the device
  Future<void> pickVideo() async {
    try {
      isLoading.value = true;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      if (result != null && result.files.isNotEmpty) {
        selectedVideoPath.value = result.files.single.path!;
        selectedVideoUrl.value = ''; // Clear network video when selecting new
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick a video: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Picks a thumbnail (image)
  Future<void> pickThumbnail() async {
    try {
      isLoading.value = true;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        thumbnailPath.value = result.files.single.path!;
        thumbnailUrl.value = ''; // Clear network thumbnail when selecting new
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick a thumbnail: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Upload video logic
  Future<void> uploadVideo() async {
    if (videoTitleController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a video title.");
      return;
    }

    try {
      isLoading.value = true;
      var res = await ApiService.videoApi(Apis.publishVideo, ctx,
          thumbnailParamName: 'thumbnail',
          method: 'POST',
          videoParamName: 'video',
          imagePath: [
            thumbnailPath.value
          ],
          videoPath: [
            selectedVideoPath.value
          ],
          body: {
            'title': videoTitleController.text,
            'publisher': AppVariables.box.read(StorageKeys.aId),
          });

      if (res == null) {
        Get.snackbar("Error", "Failed to upload video");
        return;
      }
      Get.snackbar("Success", "Video uploaded successfully!");
      Get.offAllNamed(Routes.publisherProfile,
          arguments: {'publisherId': AppVariables.box.read(StorageKeys.aId)});
    } catch (e) {
      Get.snackbar("Error", "Failed to upload video");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update video logic
  Future<void> updateVideo(String videoId) async {
    try {
      isLoading.value = true;

      // Prepare the request body
      Map<String, dynamic> body = {'title': videoTitleController.text};

      // Prepare file paths (only include changed files)
      List<String> imagePath = [];
      List<String> videoPath = [];

      if (thumbnailPath.value.isNotEmpty) {
        imagePath.add(thumbnailPath.value); // User selected a new thumbnail
      }

      if (selectedVideoPath.value.isNotEmpty) {
        videoPath.add(selectedVideoPath.value); // User selected a new video
      }

      if (imagePath.isEmpty && videoPath.isEmpty) {
        var res = await ApiService.putApi(
            Apis.updateVideo(videoId: videoId), ctx,
            body: body);
        if (res == null) {
          Get.snackbar("Error", "Failed to update video");
          return;
        }
        Get.snackbar("Success", "Video updated successfully!");
        Get.offAllNamed(Routes.publisherProfile, arguments: {
          'publisherId': AppVariables.box.read(StorageKeys.aId),
        });
      } else {
        // Make API call
        var res = await ApiService.videoApi(
          Apis.updateVideo(videoId: videoId),
          ctx,
          thumbnailParamName: 'thumbnail',
          method: 'PUT',
          videoParamName: 'video',
          imagePath: imagePath,
          videoPath: videoPath,
          body: body,
        );

        if (res == null) {
          Get.snackbar("Error", "Failed to update video");
          return;
        }

        Get.snackbar("Success", "Video updated successfully!");
        Get.offAllNamed(Routes.publisherProfile, arguments: {
          'publisherId': AppVariables.box.read(StorageKeys.aId),
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update video");
    } finally {
      isLoading.value = false;
    }
  }

  /// Load existing video details (for editing)
  void loadExistingVideo(String? videoId) {
    if (videoId != null) {
      videoTitleController.text = Get.arguments['title'] ?? '';
      selectedVideoUrl.value =
          Get.arguments['videoUrl'] ?? ''; // Use URL for preview
      thumbnailUrl.value =
          Get.arguments['thumbnailUrl'] ?? ''; // Use URL for preview
    }
  }
}
