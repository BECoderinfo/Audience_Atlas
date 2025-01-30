import 'package:atlas_admin/controllers/profile/profile_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class EditAdminProfilePage extends StatelessWidget {
  const EditAdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminProfileController controller = Get.find();

    final TextEditingController nameController =
        TextEditingController(text: controller.name.value);
    final TextEditingController emailController =
        TextEditingController(text: controller.email.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                controller.updateProfile(
                  nameController.text,
                  emailController.text,
                  controller.profileImage.value,
                );
                Get.back();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
