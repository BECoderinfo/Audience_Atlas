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
export 'package:local_auth/local_auth.dart';
export 'package:gap/gap.dart';
export 'package:get_storage/get_storage.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:google_sign_in/google_sign_in.dart';
export 'package:cached_network_image/cached_network_image.dart';

// utils import
export 'package:audience_atlas/utils/theme.dart';
export 'package:audience_atlas/utils/app_colors.dart';
export 'package:audience_atlas/utils/app_variables.dart';
export 'package:audience_atlas/utils/storage_keys.dart';
export 'package:audience_atlas/utils/apis.dart';
export 'package:audience_atlas/utils/show_toast.dart';

// router import
export 'package:audience_atlas/routes/app_pages.dart';
export 'package:audience_atlas/routes/app_routes.dart';

// view import
export 'package:audience_atlas/views/splash/splash.dart';
export 'package:audience_atlas/views/intro/intro.dart';
export 'package:audience_atlas/views/signup/signup.dart';
export 'package:audience_atlas/views/login/login.dart';
export 'package:audience_atlas/views/navigation/navigation.dart';
export 'package:audience_atlas/views/video/video.dart';

// widget import
export 'package:audience_atlas/widgets/shimmerLoding.dart';

// services import
export 'package:audience_atlas/services/api_service.dart';
