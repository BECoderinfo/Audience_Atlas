import 'package:atlas_admin/controllers/publishers/update_publisher_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class UpdatePublisher extends StatelessWidget {
  const UpdatePublisher({super.key});

  @override
  Widget build(BuildContext context) {
    UpdatePublisherController controller = Get.put(UpdatePublisherController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (controller.role == 'Publisher')
              ? "Update Profile"
              : "Update Publisher Profile",
        ),
        actions: [
          (controller.isLoading.value)
              ? CircularProgressIndicator()
              : IconButton(
                  onPressed: () {
                    controller.updatePublisher(
                        publisherId: controller.publisherId);
                  },
                  icon: Icon(
                    Icons.save,
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.blackColor),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6),
                child: Obx(
                  () => CircleAvatar(
                    radius: 50,
                    backgroundImage: (controller.image.value.startsWith('http'))
                        ? NetworkImage(
                            controller.image.value,
                          )
                        : FileImage(
                            File(controller.image.value),
                          ),
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controller.changeImage();
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Form(
                key: controller.formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    TextFormField(
                      controller: controller.nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.emailController,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
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
