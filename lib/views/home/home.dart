import 'package:audience_atlas/controllers/home/home_controller.dart';
import 'package:audience_atlas/utils/import.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
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
              Get.to(() => SearchPage());
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
        title: const Text('Audience Atlas'),
        backgroundColor: AppColors.iconColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchData();
        },
        child: Padding(
          padding: EdgeInsets.zero,
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 6, // Show 6 shimmer items for placeholder effect
                  itemBuilder: (context, index) {
                    return ShimmerLoading(
                      isLoading: true,
                      child: VideoCard(
                        thumbnailUrl:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoFRQjM-wM_nXMA03AGDXgJK3VeX7vtD3ctA&s',
                        title: 'Flutter',
                        publisherName: 'Flutter Devs',
                        publisherImageUrl:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1pb-qVaXaLJyJJAWV6jsx1yHQ-0iZS_PzAg&s',
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  final video = controller.videos[index];
                  return VideoCard(
                    thumbnailUrl: '${Apis.serverAddress}${video.thumbnail}',
                    title: video.title,
                    publisherName: video.publisher.name,
                    publisherImageUrl:
                        '${Apis.serverAddress}${video.publisher.image}',
                    onTap: () {
                      Get.toNamed(Routes.video, arguments: {
                        'video': '${Apis.serverAddress}${video.video}'
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      controller.searchVideos(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Videos'),
        backgroundColor: AppColors.iconColor,
      ),
      body: Column(
        children: [
          // 🔍 Search Bar inside Body
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search videos...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(
                  () => controller.filteredVideos.length <
                          controller.videos.length
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            controller.clearSearch();
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // 📜 Search Results
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredVideos.isEmpty) {
                return const Center(
                  child: Text("No videos found",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.filteredVideos.length,
                itemBuilder: (context, index) {
                  final video = controller.filteredVideos[index];
                  return VideoCard(
                    thumbnailUrl: '${Apis.serverAddress}${video.thumbnail}',
                    title: video.title,
                    publisherName: video.publisher.name,
                    publisherImageUrl:
                        '${Apis.serverAddress}${video.publisher.image}',
                    onTap: () {
                      Get.toNamed(Routes.video, arguments: {
                        'video': '${Apis.serverAddress}${video.video}'
                      });
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String publisherName;
  final String publisherImageUrl;
  final VoidCallback? onTap;

  const VideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.publisherName,
    required this.publisherImageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) =>
                    Icon(Icons.broken_image, size: 50),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      CachedNetworkImageProvider(publisherImageUrl),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        publisherName,
                        style:
                            const TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
