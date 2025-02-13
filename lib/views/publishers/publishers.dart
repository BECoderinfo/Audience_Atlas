import 'package:audience_atlas/controllers/publishers/publishers_controller.dart';
import 'package:audience_atlas/utils/import.dart';

class Publishers extends StatelessWidget {
  const Publishers({super.key});

  @override
  Widget build(BuildContext context) {
    PublishersController controller = Get.put(PublishersController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Publishers',
        ),
        backgroundColor: AppColors.iconColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchData();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return ShimmerLoading(
                isLoading: controller.isLoading.value,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Example video cards
                      ChannelCard(
                        channelName: 'Flutter Devs',
                        channelLogoUrl:
                            'https://avatar.iran.liara.run/public/boy?username=Ash',
                        // Replace with real logo URL
                        subscriberCount: '1.2M',
                        onSubscribe: () {
                          // Handle subscription logic
                          log('Subscribed to Flutter Devs');
                        },
                      ),
                      const SizedBox(height: 10),
                      ChannelCard(
                        channelName: 'Dart Academy',
                        channelLogoUrl:
                            'https://avatar.iran.liara.run/public/boy?username=Ash',
                        // Replace with real logo URL
                        subscriberCount: '850K',
                        onSubscribe: () {
                          // Handle subscription logic
                          log('Subscribed to Dart Academy');
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: controller.publishers.length,
              itemBuilder: (context, index) {
                final publisher = controller.publishers[index];

                return ChannelCard(
                  channelName: publisher.name,
                  channelLogoUrl: "${Apis.serverAddress}${publisher.image}",
                  // Replace with real logo URL
                  subscriberCount: publisher.subscribers.toString(),
                  onTap: () {
                    Get.toNamed(Routes.publisherDetails, arguments: publisher);
                  },
                  isSubscribed: AppVariables.box
                      .read(StorageKeys.subList)
                      .contains(publisher.id),

                  onSubscribe: () {
                    controller.subscribe(publisherId: publisher.id);
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class ChannelCard extends StatelessWidget {
  final String channelName;
  final String channelLogoUrl; // URL or asset path for the logo
  final String subscriberCount;
  final bool isSubscribed;
  final VoidCallback? onTap;
  final VoidCallback? onSubscribe;

  const ChannelCard({
    super.key,
    required this.channelName,
    required this.channelLogoUrl,
    required this.subscriberCount,
    this.isSubscribed = false,
    this.onSubscribe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Channel Logo
              Expanded(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.iconColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(channelLogoUrl), fit: BoxFit.cover),
                  ),
                ),
              ),

              // Channel Name & Subscriber Count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channelName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$subscriberCount subscribers',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (onSubscribe != null)
                      (!isSubscribed)
                          ? ElevatedButton(
                              onPressed: onSubscribe,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.iconColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Subscribe',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: onSubscribe,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greyColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'UnSubscribe',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
