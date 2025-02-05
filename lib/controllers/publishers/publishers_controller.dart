import 'package:audience_atlas/modals/publisher_modal/publisher_modal.dart';
import 'package:audience_atlas/utils/import.dart';

class PublishersController extends GetxController {
  BuildContext ctx = Get.context!;
  var isLoading = false.obs;

  RxList<PublisherModal> publishers = <PublisherModal>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      publishers.clear();
      // Call your API here
      var res = await ApiService.getApi(Apis.getPublishers, ctx);

      if (res != null) {
        res.forEach(
          (element) => publishers.add(
            PublisherModal.fromJson(element),
          ),
        );
      }

      // Simulate some progress
      // Example progress
      update(); // Update UI after fetching data
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void subscribe() {
    try {
      // Call your API here
      var res = ApiService.postApi(Apis.subscribeUnsubscribe, ctx, body: {});
    } catch (e) {
      // Handle error
      log('Error subscribing: $e');
    }
  }
}
