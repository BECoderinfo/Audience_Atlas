import 'package:audience_atlas/utils/import.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  BuildContext ctx = Get.context!;
  RxBool isLoading = false.obs;
  RxString image = '${AppVariables.box.read(StorageKeys.aImage)}'.obs;
  Rx<XFile?> imageFile = Rx<XFile?>(null);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nameController.text = AppVariables.box.read(StorageKeys.aName) ?? '';
    emailController.text = AppVariables.box.read(StorageKeys.aEmail) ?? '';
    image.startsWith('http')
        ? image.value = image.value
        : image.value = "${Apis.serverAddress}${image.value}";
  }

  /// ✅ Allows user to pick image from Gallery or Camera
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? selectedImage = await picker.pickImage(source: source);

      if (selectedImage != null) {
        imageFile.value = selectedImage;
        image.value = selectedImage.path; // ✅ Update the displayed image
      }
    } catch (e) {
      log('Error picking image: $e');
      Get.snackbar('Error', 'Failed to select image');
    }
  }

  updateProfile() async {
    try {
      isLoading.value = true;

      log('asdfghj');
      log('User ID: ${AppVariables.box.read(StorageKeys.aId)}');
      var res = await ApiService.multipartApi(
        Apis.updateProfile(userId: AppVariables.box.read(StorageKeys.aId)),
        ctx,
        body: {
          'name': nameController.text,
          'email': emailController.text,
        },
        imagePath: imageFile.value != null ? [imageFile.value!.path] : [],
        imageParamName: 'image',
        method: 'PUT',
      );

      if (res != null) {
        log('dsadad');

        AppVariables.box.write(StorageKeys.aName, nameController.text);
        AppVariables.box.write(StorageKeys.aEmail, emailController.text);
        if (imageFile.value != null) {
          AppVariables.box.write(StorageKeys.aImage, res['user']['image']);
        }
        Get.back();
      }
    } catch (e) {
      log('Error updating profile: $e');
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }
}
