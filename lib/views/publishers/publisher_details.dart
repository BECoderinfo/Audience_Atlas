import 'package:audience_atlas/controllers/publishers/publisher_d_controller.dart';
import 'package:audience_atlas/modals/publisher_modal/publisher_modal.dart';
import 'package:audience_atlas/utils/import.dart';

class PublisherD extends StatelessWidget {
  const PublisherD({super.key});

  @override
  Widget build(BuildContext context) {
    PublisherModal publisher = Get.arguments;
    PublisherDController controller =
        Get.put(PublisherDController(publisherId: publisher.id));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publisher Profile'),
        backgroundColor: AppColors.iconColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    '${Apis.serverAddress}${publisher.image}',
                  ),
                ),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publisher.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    const Text('@id'),
                    const Gap(2),
                    Text(
                      '${publisher.subscribers} subscribers ~ ${publisher.totalVideos} videos',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
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
                    onPressed: () {},
                    child: const Text(
                      'Subscribe',
                      style: TextStyle(color: AppColors.blackColor),
                    ),
                  ),
                ),
                const Gap(16),
                Tooltip(
                  message: 'Edit Profile',
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.greyColor.withValues(alpha: 0.3),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined,
                        color: AppColors.blackColor),
                  ),
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const ShimmerLoading(
                    isLoading: true,
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
                  );
                }
                return ListView.builder(
                  itemCount: controller.videos.length,
                  itemBuilder: (context, index) {
                    final video = controller.videos[index];
                    return VideoTile(
                      title: video.title,
                      description: 'Video Description',
                      image: '${Apis.serverAddress}${video.thumbnail}',
                      videoUrl: '${Apis.serverAddress}${video.video}',
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String videoUrl;
  final VoidCallback? onTap;

  const VideoTile({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.videoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap ??
            () {
              Get.toNamed(Routes.video, arguments: {"video": videoUrl});
            },
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
      ),
    );
  }
}
