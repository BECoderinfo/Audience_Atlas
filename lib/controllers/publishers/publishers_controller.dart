import 'package:atlas_admin/modals/publisher_modal.dart';
import 'package:atlas_admin/utils/import.dart';

class PublishersController extends GetxController {
  BuildContext ctx = Get.context!;
  RxBool isLoading = false.obs;

  RxList<PublisherModal> publishers = <PublisherModal>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPublishers();
  }

  void getPublishers() async {
    try {
      isLoading.value = true;

      var res = await ApiService.getApi(Apis.getPublishers, ctx);
      if (res != null) {
        log(res.toString());

        res.forEach((element) {
          publishers.add(PublisherModal.fromJson(element));
        });
      }
      update();
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to fetch publishers: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
