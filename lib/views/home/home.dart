import 'package:audience_atlas/controllers/home/home_controller.dart';
import 'package:audience_atlas/utils/import.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
        ],
        title: const Text('Audience Atlas'),
        backgroundColor: AppColors.iconColor, // Adjust as per your theme
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchData();
        },
        child: Obx(
          () => ShimmerLoading(
            isLoading: controller.isLoading.value,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Example video cards
                  VideoCard(
                    thumbnailUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFD5pb-D2HNw_pVOsGbdiuHLwzuEiPADe73g&s',
                    title: 'Understanding Dart Streams',
                    publisherName: 'Dart Experts',
                    publisherImageUrl:
                        'https://avatar.iran.liara.run/public/boy?username=Ash',
                  ),
                  VideoCard(
                    thumbnailUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoFRQjM-wM_nXMA03AGDXgJK3VeX7vtD3ctA&s',
                    // Example thumbnail
                    title: 'Flutter Basics: Getting Started',
                    publisherName: 'Flutter Devs',
                    publisherImageUrl:
                        'https://avatar.iran.liara.run/public/boy?username=Ash', // Example profile
                  ),
                  VideoCard(
                    thumbnailUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCmgkix4DEJoToCFKP-g8ztCYa9bIuxAC3pA&s',
                    title: 'Understanding Dart Streams',
                    publisherName: 'Dart Experts',
                    publisherImageUrl:
                        'https://avatar.iran.liara.run/public/boy?username=Ash',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String publisherName;
  final String publisherImageUrl;

  const VideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.publisherName,
    required this.publisherImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              thumbnailUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          // Row with Publisher Image and Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Publisher Image
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(publisherImageUrl),
              ),
              const SizedBox(width: 10.0),
              // Title and Publisher Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    // Publisher Name
                    Text(
                      publisherName,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
