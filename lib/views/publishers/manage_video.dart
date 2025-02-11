import 'package:atlas_admin/controllers/publishers/manage_video_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class ManageVideo extends StatelessWidget {
  const ManageVideo({super.key});

  @override
  Widget build(BuildContext context) {
    String publisherId = Get.arguments['publisherId'];
    ManageVideoController controller =
        Get.put(ManageVideoController(publisherId: publisherId));

    ScrollController scrollController = ScrollController();

    // Pagination logic
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMoreVideos();
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.publishVideo,
                  arguments: {'publisherId': publisherId});
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Videos',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const Gap(16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getPublisherVideos();
                },
                child: Obx(
                  () {
                    if (controller.loadingVideo.value) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: 6,
                        // Show 6 shimmer items for placeholder effect
                        itemBuilder: (context, index) {
                          return ShimmerLoading(
                            isLoading: true,
                            child: VideoTile(
                              title: "Tital",
                              image: "https://picsum.photos/200",
                              videoUrl: "",
                              videoId: '',
                              controller: controller,
                            ),
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: controller.videos.length +
                          (controller.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.videos.length) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final video = controller.videos[index];
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.viewVideo, arguments: {
                              'video':
                                  "${Apis.serverAddress}/${controller.videos[index].video}"
                            });
                          },
                          child: VideoTile(
                            title: video.title,
                            // description: video.description,
                            image: "${Apis.serverAddress}/${video.thumbnail}",
                            videoUrl: "${Apis.serverAddress}/${video.video}",
                            videoId: video.id,
                            controller: controller,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  final ManageVideoController controller;
  final String videoId;
  final String title;

  // final String description;
  final String image;
  final String videoUrl;

  const VideoTile({
    super.key,
    required this.title,
    required this.videoId,
    required this.controller,
    // required this.description,
    required this.image,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.iconColor,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover),
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                // Text(
                //   description,
                //   style: TextStyle(
                //     fontSize: 14,
                //   ),
                // ),
              ],
            ),
          ),
          const Gap(10),
          GestureDetector(
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (context) => VideoBottomSheet(
                  videoId: videoId,
                  controller: controller,
                ),
              );
            },
            child: const Icon(
              Icons.more_vert,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoBottomSheet extends StatelessWidget {
  final String videoId;
  final ManageVideoController controller;

  const VideoBottomSheet(
      {super.key, required this.videoId, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              // Add share functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              controller.editVideo(videoId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              controller.deleteVideo(videoId);
              Get.back();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel'),
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
