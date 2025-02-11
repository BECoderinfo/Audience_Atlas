import 'package:atlas_admin/controllers/publishers/publishers_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class Publishers extends StatelessWidget {
  const Publishers({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PublishersController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Publishers'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => (controller.isLoading.value)
                  ? ShimmerLoading(
                      isLoading: controller.isLoading.value,
                      child: ListView(
                        children: [
                          PublisherTile(
                            publisherName: 'Publisher',
                            totalSubscribers: '100',
                            publisherImage:
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlrZqTCInyg6RfYC7Ape20o-EWP1EN_A8fOA&s',
                            onTap: () {},
                          ),
                          PublisherTile(
                            publisherName: 'Publisher',
                            totalSubscribers: '100',
                            publisherImage:
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlrZqTCInyg6RfYC7Ape20o-EWP1EN_A8fOA&s',
                            onTap: () {},
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.publishers.length,
                      itemBuilder: (context, index) {
                        final publisher = controller.publishers[index];
                        return PublisherTile(
                          publisherName: publisher.name,
                          totalSubscribers: publisher.subscribers.toString(),
                          publisherImage:
                              '${Apis.serverAddress}/${publisher.image}',
                          onTap: () {
                            log(index.toString());
                            Get.toNamed(Routes.publisherProfile,
                                arguments: {'publisherId': publisher.id});
                          },
                        );
                      },
                    ),
            ),
          ),
          floatingActionButton: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.greyColor.withValues(alpha: 0.3),
            ),
            tooltip: "Add Video",
            onPressed: () {},
            icon: const Icon(Icons.add, color: AppColors.blackColor),
          ),
        );
      },
    );
  }
}

class PublisherTile extends StatelessWidget {
  final String publisherName;
  final String totalSubscribers;
  final String publisherImage;
  final VoidCallback? onTap;

  const PublisherTile({
    super.key,
    required this.publisherName,
    required this.totalSubscribers,
    required this.publisherImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(publisherName),
      trailing: Text('$totalSubscribers Subs'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(publisherImage),
      ),
      onTap: onTap,
    );
  }
}
