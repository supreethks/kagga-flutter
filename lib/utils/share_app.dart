import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

class ShareApp {
  static Future<void> share(BuildContext context) async {
    final String appName = 'ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ';
    final String androidUrl =
        'https://play.google.com/store/apps/details?id=com.halagebalapa.mankutimma';
    final String iosUrl = 'https://apps.apple.com/app/id6740048051';

    final String storeUrl = Platform.isAndroid ? androidUrl : iosUrl;
    final String message = 'Check out $appName app\n\n$storeUrl';

    try {
      await Share.share(
        message,
        subject: appName,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not share the app'),
          ),
        );
      }
    }
  }
}
