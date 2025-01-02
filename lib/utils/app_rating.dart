import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class AppRating {
  static Future<void> launchStoreUrl(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        // Android Play Store URL
        final Uri url = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.halagebalapa.mankutimma');
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (Platform.isIOS) {
        // iOS App Store URL
        final Uri url = Uri.parse(
            'https://apps.apple.com/app/id6740048051?action=write-review');
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open store page'),
          ),
        );
      }
    }
  }
}
