import '../utils/import.dart';

class ApiService {
  static Future<dynamic> getApi(
    String url,
    BuildContext ctx, {
    Map<String, String>? headers,
  }) async {
    return _handleRequest(
      () => AppVariables.connect.get(url, headers: headers),
      ctx,
    );
  }

  static Future<dynamic> multipartApi(
    String url,
    BuildContext ctx, {
    String imageParamName = '',
    required List<String> imagePath,
    required Map<String, dynamic> body,
    String method = 'POST',
  }) async {
    try {
      var formData = FormData(body);

      if (imageParamName.isNotEmpty && imagePath.isNotEmpty) {
        for (var path in imagePath) {
          final file =
              MultipartFile(File(path), filename: path.split('/').last);
          formData.files.add(MapEntry(imageParamName, file));
        }
      }

      Response response = method == 'POST'
          ? await AppVariables.connect.post(url, formData)
          : await AppVariables.connect.put(url, formData);

      return _processResponse(response, ctx);
    } catch (e) {
      return _handleError(e, ctx);
    }
  }

  static Future<dynamic> videoApi(
    String url,
    BuildContext ctx, {
    String thumbnailParamName = '',
    String videoParamName = '',
    required List<String> imagePath,
    required List<String> videoPath,
    required Map<String, dynamic> body,
    String method = 'POST',
  }) async {
    try {
      var formData = FormData(body);

      if (thumbnailParamName.isNotEmpty && imagePath.isNotEmpty) {
        for (var path in imagePath) {
          final file =
              MultipartFile(File(path), filename: path.split('/').last);
          formData.files.add(MapEntry(thumbnailParamName, file));
        }
      }

      if (videoParamName.isNotEmpty && videoPath.isNotEmpty) {
        for (var path in videoPath) {
          final file =
              MultipartFile(File(path), filename: path.split('/').last);
          formData.files.add(MapEntry(videoParamName, file));
        }
      }

      Response response = method == 'POST'
          ? await AppVariables.connect.post(url, formData)
          : await AppVariables.connect.put(url, formData);

      return _processResponse(response, ctx);
    } catch (e) {
      return _handleError(e, ctx);
    }
  }

  static Future<dynamic> putApi(
    String url,
    BuildContext ctx, {
    Map<String, dynamic>? body,
  }) async {
    return _handleRequest(
      () => AppVariables.connect
          .put(url, jsonEncode(body ?? {}), headers: Apis.headersValue),
      ctx,
    );
  }

  static Future<dynamic> deleteApi(
    String url,
    BuildContext ctx, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    headers = headers ?? {}
      ..addAll(Apis.headersValue);

    return _handleRequest(
      () =>
          AppVariables.connect.delete(url, headers: headers, query: body ?? {}),
      ctx,
    );
  }

  // static Future<dynamic> deleteApiBody(
  //     String url,
  //     BuildContext ctx, {
  //       Map<String, dynamic>? body,
  //     }) async {
  //   return _handleRequest(
  //         () async {
  //       final response = await HttpClient().deleteUrl(Uri.parse(url))
  //         ..headers.addAll(Apis.headersValue)
  //         ..write(json.encode(body ?? {}));
  //
  //       return Response(
  //         body: json.decode(await response.close().transform(utf8.decoder).join()),
  //         statusCode: response.statusCode,
  //       );
  //     },
  //     ctx,
  //   );
  // }

  static Future<dynamic> postApi(
    String url,
    BuildContext ctx, {
    dynamic body,
  }) async {
    return _handleRequest(
      () => AppVariables.connect
          .post(url, jsonEncode(body ?? {}), headers: Apis.headersValue),
      ctx,
    );
  }

  /// Handles API requests with error handling
  static Future<dynamic> _handleRequest(
      Future<Response> Function() request, BuildContext ctx) async {
    try {
      final response = await request().timeout(Apis.timeoutDuration);
      return _processResponse(response, ctx);
    } catch (e) {
      return _handleError(e, ctx);
    }
  }

  /// Processes HTTP response
  static dynamic _processResponse(Response response, BuildContext ctx) {
    print(
        "Response :: ${response.statusCode} :: ${response.body} :: ${response.request?.url}");

    switch (response.statusCode) {
      case 200:
      case 201:
        return response.body;
      case 400:
        _showErrorToast(ctx, response.body['message']);
        throw BadRequestException('Bad request: ${response.body}');
      case 401:
      case 404:
        _showErrorToast(ctx, 'Error: ${response.statusCode}');
        return null;
      case 403:
        throw UnauthorisedException('Unauthorized: ${response.body}');
      case 500:
        _showErrorToast(ctx, response.body['message']);
        return null;
      default:
        _showErrorToast(ctx, 'Unexpected error: ${response.statusCode}');
        return null;
    }
  }

  /// Handles socket and timeout exceptions
  static dynamic _handleError(dynamic error, BuildContext ctx) {
    if (error is SocketException) {
      return _handleSocketException(ctx);
    } else if (error is TimeoutException) {
      _showErrorToast(ctx, "Request timed out. Please try again.");
    } else {
      _showErrorToast(ctx, "Unexpected error: $error");
    }
    return null;
  }

  /// Handles socket exception specifically
  static dynamic _handleSocketException(BuildContext ctx) async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      _showErrorToast(ctx, "Something went wrong. Please try again.");
    } else {
      _showErrorToast(ctx, "No internet connection.");
    }
    return null;
  }

  /// Displays error toast
  static void _showErrorToast(BuildContext ctx, String? message) {
    ShowToast.showFailedGfToast(
      ctx: ctx,
      msg: message ?? "Something went wrong. Please try again.",
    );
  }
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);
}

class UnauthorisedException implements Exception {
  final String message;

  UnauthorisedException(this.message);
}
