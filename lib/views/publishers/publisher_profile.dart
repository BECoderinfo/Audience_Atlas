import 'package:atlas_admin/utils/import.dart';

class PublisherProfile extends StatelessWidget {
  const PublisherProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publisher Profile'),
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
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlrZqTCInyg6RfYC7Ape20o-EWP1EN_A8fOA&s',
                  ),
                ),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Publisher Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    const Text('@id'),
                    const Gap(2),
                    const Text(
                      '100 subscribers ~ 5 videos',
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
                      'Manage videos',
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
    );
  }
}
