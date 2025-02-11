import 'package:atlas_admin/controllers/publishers/publish_video_controller.dart';
import 'package:atlas_admin/utils/import.dart';
import 'package:video_player/video_player.dart';

class PublishVideo extends StatelessWidget {
  const PublishVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final String publisherId = Get.arguments?['publisherId'] ?? '';
    final String? videoId =
        Get.arguments?['videoId']; // If editing an existing video

    return GetBuilder<PublishVideoController>(
      init: PublishVideoController()..loadExistingVideo(videoId),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            videoId != null ? "Update Video" : "Publish Video",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Video Preview"),
                Stack(
                  children: [
                    Obx(
                      () => VideoPreview(
                        key: ValueKey(controller.selectedVideoPath.value),
                        controller.selectedVideoPath.value,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: controller.pickVideo,
                        child: const Icon(Icons.video_library,
                            color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle("Thumbnail Preview"),
                Stack(
                  children: [
                    Obx(() => ThumbnailPreview(controller.thumbnailPath.value)),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: controller.pickThumbnail,
                        child:
                            const Icon(Icons.image, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.videoTitleController,
                  decoration: InputDecoration(
                    labelText: "Video Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: controller.thumbnailPath.value.isNotEmpty
                          ? () {
                              if (videoId != null) {
                                controller.updateVideo(videoId);
                              } else {
                                controller.uploadVideo();
                              }
                            }
                          : null,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              videoId != null ? "Update Video" : "Upload Video",
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

class VideoPreview extends StatefulWidget {
  final String videoPath;

  const VideoPreview(this.videoPath, {super.key});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? _videoController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath.isNotEmpty) {
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void didUpdateWidget(covariant VideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath &&
        widget.videoPath.isNotEmpty) {
      _videoController?.dispose();
      _initializeVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.videoPath.isNotEmpty &&
            _videoController != null &&
            _videoController!.value.isInitialized
        ? Stack(
            children: [
              Hero(
                tag: "video_preview_${widget.videoPath}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              ),
              Positioned(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      isPlaying
                          ? _videoController!.play()
                          : _videoController!.pause();
                    });
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          )
        : _buildPlaceholder("No video selected");
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}

class ThumbnailPreview extends StatelessWidget {
  final String thumbnailPath;

  const ThumbnailPreview(this.thumbnailPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return thumbnailPath.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                Image.file(File(thumbnailPath), height: 200, fit: BoxFit.cover),
          )
        : _buildPlaceholder("No thumbnail selected");
  }
}

Widget _buildPlaceholder(String text) {
  return Container(
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey[300],
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
