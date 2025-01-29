import 'dart:io';

import 'package:audience_atlas/utils/import.dart';
import 'package:flutter/services.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false; // Tracks the authentication status

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (canCheckBiometrics || isDeviceSupported) {
        bool isAuthenticated = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(
            biometricOnly: false, // Allow PIN/password fallback
          ),
        );

        if (isAuthenticated) {
          setState(() {
            _isAuthenticated = true;
            Get.offAllNamed(Routes.navigation);
          });
        } else {
          _showFallbackDialog();
        }
      } else {
        _showNoAuthDialog();
      }
    } catch (e) {
      print('Error during authentication: $e');
      _showFallbackDialog();
    }
  }

  void _showFallbackDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevents closing dialog until user chooses an action
      builder: (context) => AlertDialog(
        title: Text('Authentication Failed'),
        content: Text('Authentication failed. Please try again or exit.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _checkAuthentication(); // Retry authentication
            },
            child: Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              _exitApp(); // Exit app
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showNoAuthDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevents closing dialog until user chooses an action
      builder: (context) => AlertDialog(
        title: Text('No Authentication Setup'),
        content: Text(
            'It seems like you have not set up any form of authentication on your device. Please go to settings to set it up.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _exitApp(); // Exit the app
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  // Exit the app gracefully, handling iOS and Android
  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop(); // Android-specific graceful exit
    } else {
      // iOS should not force exit. You might show a different screen or message
      print("iOS does not allow forced exit");
      exit(0); // Only use on Android or during debugging, avoid on iOS.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.iconColor,
      body: Center(
        child: _isAuthenticated
            ? Text(
                'Welcome to the App!',
                style: TextStyle(fontSize: 24, color: AppColors.whiteColor),
              )
            : Text(
                'Audience Atlas',
                style: TextStyle(fontSize: 24, color: AppColors.whiteColor),
              ),
      ),
    );
  }
}
