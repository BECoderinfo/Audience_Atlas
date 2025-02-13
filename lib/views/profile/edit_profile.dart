import 'package:audience_atlas/controllers/profile/edit_profile_controller.dart';
import 'package:audience_atlas/utils/import.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    EditProfileController controller = Get.put(EditProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: AppColors.iconColor,
        actions: [
          TextButton(
            onPressed: () {
              controller.updateProfile();
            },
            child: Text(
              'Save',
              style: TextStyle(color: AppColors.whiteColor),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
              () => CircleAvatar(
                radius: 50,
                backgroundImage: (controller.image.value.startsWith('http'))
                    ? NetworkImage(
                        controller.image.value,
                      )
                    : FileImage(
                        File(
                          controller.image.value,
                        ),
                      ),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: () {
                    controller.pickImage(source: ImageSource.gallery);
                  },
                ),
              ),
            ),
            Gap(20),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            Gap(16),
            TextField(
              controller: controller.emailController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
