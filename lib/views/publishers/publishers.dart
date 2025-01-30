import 'package:atlas_admin/controllers/publishers/publishers_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class Publishers extends StatelessWidget {
  const Publishers({super.key});

  @override
  Widget build(BuildContext context) {
    PublishersController controller = Get.put(PublishersController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Publishers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return PublisherTile(
              publisherName: 'Publisher $index',
              totalSubscribers: '100',
              publisherImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlrZqTCInyg6RfYC7Ape20o-EWP1EN_A8fOA&s',
              onTap: () {
                Get.toNamed(Routes.publisherProfile);
              },
            );
          },
        ),
      ),
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
