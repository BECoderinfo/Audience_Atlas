import 'package:atlas_admin/controllers/publishers/publisher_profile_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class PublisherProfile extends StatelessWidget {
  const PublisherProfile({super.key});

  @override
  Widget build(BuildContext context) {
    String publisherId = Get.arguments['publisherId'];
    ScrollController scrollController = ScrollController();

    PublisherProfileController controller =
        Get.put(PublisherProfileController(publisherId: publisherId));

    // Pagination logic
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMoreVideos();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
            (controller.role == 'Publisher') ? 'Profile' : 'Publisher Profile'),
        actions: [
          if (controller.role == 'Publisher')
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () {
                controller.showLogoutDialog();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Obx(
                    () => (controller.publisher.value == null)
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlrZqTCInyg6RfYC7Ape20o-EWP1EN_A8fOA&s',
                            ),
                          )
                        : CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              '${Apis.serverAddress}/${controller.publisher.value!.image}',
                            ),
                          ),
                  ),
                  const Gap(16),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (controller.publisher.value == null)
                              ? 'Publisher Name'
                              : controller.publisher.value!.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(4),
                        const Text('@id'),
                        const Gap(2),
                        Text(
                          (controller.publisher.value == null)
                              ? '100 subscribers ~ 5 videos'
                              : '${controller.publisher.value!.subscribers} subscribers ~ ${controller.publisher.value!.totalVideos} videos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                ],
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.greyColor.withValues(alpha: 0.3),
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.manageVideo,
                            arguments: {'publisherId': publisherId});
                      },
                      child: const Text(
                        'Manage videos',
                        style: TextStyle(color: AppColors.blackColor),
                      ),
                    ),
                  ),
                  if (controller.role == "Publisher") const Gap(16),
                  if (controller.role == "Publisher")
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            AppColors.greyColor.withValues(alpha: 0.3),
                      ),
                      tooltip: 'Edit Profile',
                      onPressed: () {
                        Get.toNamed(Routes.updatePublisher, arguments: {
                          'publisherId': publisherId,
                          'role': controller.role,
                          'name': controller.publisher.value!.name,
                          'image':
                              '${Apis.serverAddress}/${controller.publisher.value!.image}',
                          'email': controller.publisher.value!.email
                        });
                      },
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.blackColor),
                    ),
                ],
              ),
              const Gap(16),
              Text(
                'Videos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              Expanded(
                child: Obx(
                  () => (controller.loadingVideo.value)
                      ? ShimmerLoading(
                          isLoading: controller.loadingVideo.value,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                VideoTile(
                                  title: 'Video Title',
                                  description: 'Video Description',
                                  image: 'https://picsum.photos/200',
                                  videoUrl: 'https://example.com/video',
                                ),
                                VideoTile(
                                  title: 'Video Title',
                                  description: 'Video Description',
                                  image: 'https://picsum.photos/200',
                                  videoUrl: 'https://example.com/video',
                                ),
                              ],
                            ),
                          ),
                        )
                      : controller.videos.isEmpty
                          ? const Center(child: Text('No videos found'))
                          : ListView.builder(
                              itemCount: controller.videos.length +
                                  (controller.isLoadingMore.value ? 1 : 0),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == controller.videos.length) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return GestureDetector(
                                  onTap: () {
                                    log(controller.videos[index].video);
                                    Get.toNamed(Routes.viewVideo, arguments: {
                                      'video':
                                          "${Apis.serverAddress}/${controller.videos[index].video}"
                                    });
                                  },
                                  child: VideoTile(
                                    title: controller.videos[index].title,
                                    description: "",
                                    image:
                                        '${Apis.serverAddress}/${controller.videos[index].thumbnail}',
                                    videoUrl: controller.videos[index].video,
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (controller.role == 'Publisher')
          ? IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.greyColor.withValues(alpha: 0.3),
              ),
              tooltip: "Add Video",
              onPressed: () {
                Get.toNamed(Routes.publishVideo,
                    arguments: {'publisherId': publisherId});
              },
              icon: const Icon(Icons.add, color: AppColors.blackColor),
            )
          : Container(),
    );
  }
}

class VideoTile extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String videoUrl;

  const VideoTile({
    super.key,
    required this.title,
    required this.description,
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
              decoration: (image == "")
                  ? BoxDecoration(
                      color: AppColors.iconColor,
                      borderRadius: BorderRadius.circular(12),
                    )
                  : BoxDecoration(
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
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          const Icon(
            Icons.more_vert,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
