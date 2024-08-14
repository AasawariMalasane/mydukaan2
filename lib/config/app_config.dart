import 'dart:io';

class AppConfig {
  static const String appName = 'My Dukaan2';
  static const String version = '1.0.0'; // Match this with your app version
  static const String vendorId = '664b1de93dad8bcb3a9b35f0';

  static const bool isProduction = true; // Set to true for production builds

  static String get baseUrl {
    return isProduction
        ? 'https://api.mydukaanapp.com'
        : 'https://staging-api.example.com';
  }

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      'version': version,
      'deviceType': Platform.isAndroid ? 'android' : 'ios',
    };
  }
}