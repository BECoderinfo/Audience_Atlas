class Apis {
  static const Duration timeoutDuration = Duration(minutes: 5);
  static const Map<String, String> headersValue = {
    'Content-Type': 'application/json'
  };
  static const String serverAddress = "https://audieanceatlas.onrender.com";

  /// Authentication endpoints
  static const String createUser = "$serverAddress/publisher/create";
  static const String adminLogin = "$serverAddress/publisher/login";

  static const String getDashboardData =
      "$serverAddress/publisher/dashboard/get";

  static String getUserByEmail({required String email}) =>
      "$serverAddress/user/getByEmail/$email";

  /// Video endpoints
  static String getVideos(
      {int page = 1,
      int limit = 10,
      String? search,
      String? publisher,
      bool random = false}) {
    String url = "$serverAddress/video/get?page=$page&limit=$limit";
    if (search != null && search.isNotEmpty) url += "&search=$search";
    if (publisher != null && publisher.isNotEmpty) {
      url += "&publisher=$publisher";
    }
    if (random) url += "&random=true";
    return url;
  }

  /// Publisher endpoints
  static String getPublishers = "$serverAddress/publisher";

  static String getPublisherById({required String publisherId}) =>
      "$serverAddress/publisher/$publisherId";

  static String subscribeUnsubscribe({required String publisherId}) =>
      "$serverAddress/publisher/addSubscriber/$publisherId";

  static String updateProfile({required String userId}) =>
      "$serverAddress/user/update/$userId";

  static String publishVideo = "$serverAddress/video/publish";

  static String updateVideo({required String videoId}) =>
      "$serverAddress/video/update/$videoId";

  static String deleteVideo({required String videoId}) =>
      "$serverAddress/video/delete/$videoId";

  static String updatePublisher({required String publisherId}) =>
      "$serverAddress/publisher/update/$publisherId";
}
