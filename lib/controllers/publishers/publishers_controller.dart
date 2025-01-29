import 'package:audience_atlas/utils/import.dart';

class PublishersController extends GetxController {
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      // Call your API here
      // Example: final response = await http.get('your-api-url');

      // After fetching, update the data
      // For example:
      // dashboardItems = response.data['dashboardItems'];
      // announcements = response.data['announcements'];
      // recentActivities = response.data['recentActivities'];

      Future.delayed(Duration(seconds: 2), () {
        isLoading.value = false;
      });

      // Simulate some progress
      // Example progress
      update(); // Update UI after fetching data
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    }
  }
}
