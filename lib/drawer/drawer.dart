import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../db/kagga_db_helper.dart';
import '../utils/app_rating.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import '../utils/share_app.dart';
import '../services/notification_service.dart';

class KaggaListDrawer extends StatefulWidget {
  const KaggaListDrawer({super.key});

  @override
  State<KaggaListDrawer> createState() => _KaggaListDrawerState();
}

class _KaggaListDrawerState extends State<KaggaListDrawer> {
  final _notificationService = NotificationService();
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationState();
  }

  Future<void> _loadNotificationState() async {
    try {
      final enabled = await _notificationService.isEnabled();
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          _notificationsEnabled = enabled;
        });
      }
    } catch (e) {
      debugPrint('Error loading notification state: $e');
    }
  }

  Future<void> _onNotificationToggle(bool value) async {
    try {
      setState(() {
        // Show loading state
        _notificationsEnabled = value;
      });

      await _notificationService.toggleNotifications(value);

      // Reload the actual state after toggle
      await _loadNotificationState();
    } catch (e) {
      debugPrint('Error toggling notifications: $e');
      // Ensure we reload the state even if there's an error
      await _loadNotificationState();
    }
  }

  Widget _buildVersionInfo() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        return FutureBuilder<int>(
          future: getDatabaseVersion(),
          builder: (context, dbSnapshot) {
            if (snapshot.hasData && dbSnapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ಆವೃತ್ತಿ ${snapshot.data!.version}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Db: ${dbSnapshot.data}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('ಕುರಿತು'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutScreen(title: 'ಕುರಿತು'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('ಸಂಪರ್ಕಿಸಿ'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactScreen(title: 'ಸಂಪರ್ಕಿಸಿ'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('ದಿನಕ್ಕೊಂದು ಕಗ್ಗ ನೋಟಿಫಿಕೇಶನ್'),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: _onNotificationToggle,
                  activeColor: Colors.orange,
                ),
              ),
              ListTile(
                title: Text('ರೇಟ್ ಮಾಡಿ'),
                onTap: () {
                  Navigator.pop(context);
                  AppRating.launchStoreUrl(context);
                },
              ),
              ListTile(
                title: Text('ಗೆಳೆಯರಿಗೆ ಪರಿಚಯಿಸಿ'),
                onTap: () {
                  Navigator.pop(context);
                  ShareApp.share(context);
                },
              ),
            ],
          ),
          _buildVersionInfo(),
        ],
      ),
    );
  }
}
