import 'package:atlas_admin/utils/import.dart';
import 'package:file_picker/file_picker.dart';

class UpdatePublisherController extends GetxController {
  BuildContext ctx = Get.context!;
  String role = AppVariables.box.read(StorageKeys.role) ?? "Publisher";

  RxBool isLoading = false.obs;
  Map arguments = Get.arguments;

  String publisherId = Get.arguments['publisherId'];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxString image =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlrZqTCInyg6RfYC7Ape20o-EWP1EN_A8fOA&s"
          .obs;

  @override
  void onInit() {
    super.onInit();
    image = (arguments['image'] != null)
        ? "${arguments['image']}".obs
        : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlrZqTCInyg6RfYC7Ape20o-EWP1EN_A8fOA&s"
            .obs;
    nameController.text = arguments['name'];
    emailController.text = arguments['email'];
  }

  Future<void> changeImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      image.value = file.path; // Update the observable image
    } else {
      Get.snackbar("Image Selection", "you did not select image",
          snackPosition: SnackPosition.values[0]);
    }
  }

  Future<void> updatePublisher({required String publisherId}) async {
    try {
      isLoading.value = true;

      if (arguments['image'] == image.value) {
        log('name');
        var res = await ApiService.putApi(
          Apis.updatePublisher(publisherId: publisherId),
          ctx,
          body: {"name": nameController.value.text},
        );

        if (res != null) {
          Get.snackbar('Updated', "Profile updated.");
          Get.offAllNamed(Routes.publisherProfile,
              arguments: {'publisherId': publisherId});
        }
      } else {
        log('hello');
        var res = await ApiService.multipartApi(
            Apis.updatePublisher(publisherId: publisherId), ctx,
            method: 'PUT',
            imageParamName: 'image',
            imagePath: [image.value],
            body: {'name': nameController.value.text});

        if (res != null) {
          Get.snackbar('Updated', "Profile updated.");
          Get.offAllNamed(Routes.publisherProfile,
              arguments: {'publisherId': publisherId});
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update publisher: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
