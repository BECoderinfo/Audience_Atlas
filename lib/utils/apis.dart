class Apis {
  static const Duration timeoutDuration = Duration(minutes: 5);
  static const Map<String, String> headersValue = {
    'Content-Type': 'application/json'
  };
  static const String serverAddress = "https://audieanceatlas.onrender.com";

  /// Authentication endpoints
  static const String createUser = "$serverAddress/user/create";
  static const String login = "$serverAddress/user/login";

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

  static String subscribeUnsubscribe({required String publisherId}) =>
      "$serverAddress/publisher/addSubscriber/$publisherId";

  static String updateProfile({required String userId}) =>
      "$serverAddress/user/update/$userId";
}
