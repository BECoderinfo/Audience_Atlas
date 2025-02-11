// import file here

// main import
export 'package:flutter/material.dart';
export 'dart:io' show File, SocketException, InternetAddress, HttpClient;
export 'dart:async' show TimeoutException, Timer, Completer;
export 'dart:convert' show jsonEncode, jsonDecode, utf8, json;
export 'package:flutter/services.dart'
    show SystemNavigator, MethodChannel, PlatformException, rootBundle;
export 'dart:developer' show log;
export 'dart:typed_data' show Uint8List;

// pub import
export 'package:get/get.dart';

// export 'package:local_auth/local_auth.dart';
export 'package:gap/gap.dart';
export 'package:get_storage/get_storage.dart';

// export 'package:firebase_auth/firebase_auth.dart';
// export 'package:google_sign_in/google_sign_in.dart';

// utils import
export 'package:atlas_admin/utils/theme.dart';
export 'package:atlas_admin/utils/app_colors.dart';
export 'package:atlas_admin/utils/app_variables.dart';
export 'package:atlas_admin/utils/storage_keys.dart';
export 'package:atlas_admin/utils/apis.dart';
export 'package:atlas_admin/utils/show_toast.dart';

// router import
export 'package:atlas_admin/routes/app_pages.dart';
export 'package:atlas_admin/routes/app_routes.dart';

// view import
export 'package:atlas_admin/views/dash/dashboard.dart';
export 'package:atlas_admin/views/profile/profile.dart';
export 'package:atlas_admin/views/publishers/publishers.dart';
export 'package:atlas_admin/views/splash/splash.dart';
export 'package:atlas_admin/views/login/login.dart';

// widget import
export 'package:atlas_admin/widgets/shimmerLoding.dart';

// service import
export 'package:atlas_admin/services/api_service.dart';
