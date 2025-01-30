import 'package:atlas_admin/controllers/profile/profile_controller.dart';
import 'package:atlas_admin/utils/import.dart';
import 'package:atlas_admin/views/profile/edit_profile.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminProfileController controller = Get.put(AdminProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Obx(
                () => CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.profileImage.value.isNotEmpty
                      ? NetworkImage(controller.profileImage.value)
                      : const NetworkImage(
                              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp')
                          as ImageProvider,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              controller.name.value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(controller.email.value,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),

            const SizedBox(height: 30),

            // Edit Profile Button
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              onPressed: () {
                Get.to(() => const EditAdminProfilePage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
