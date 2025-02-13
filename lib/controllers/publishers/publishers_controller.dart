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

  void subscribe({required String publisherId}) async {
    try {
      // Call your API here
      var res = await ApiService.putApi(
          Apis.subscribeUnsubscribe(publisherId: publisherId), ctx,
          body: {"userId": AppVariables.box.read(StorageKeys.aId)});

      if (res != null) {
        fetchData();
        var subList = AppVariables.box.read(StorageKeys.subList);

        if (subList == null) {
          subList = [publisherId];
        } else if (subList.contains(publisherId)) {
          subList.remove(publisherId);
        } else {
          subList.add(publisherId);
        }
        AppVariables.box.write(StorageKeys.subList, subList);
      }
      update();
    } catch (e) {
      // Handle error
      log('Error subscribing: $e');
    }
  }
}
