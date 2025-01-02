import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../db/kagga_db_helper.dart';
import '../utils/app_rating.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import '../utils/share_app.dart';

class KaggaListDrawer extends StatelessWidget {
  const KaggaListDrawer({super.key});

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
                  value: true, // Set the initial value
                  onChanged: (bool value) {
                    // Handle the switch toggle
                  },
                  activeColor: Colors.orange,
                ),
              ),
              ListTile(
                title: Text('ರೇಟ್ ಮಾಡಿ'),
                onTap: () {
                  Navigator.pop(context); // Close drawer first
                  AppRating.launchStoreUrl(context);
                },
              ),
              ListTile(
                title: Text('ಗೆಳೆಯರಿಗೆ ಪರಿಚಯಿಸಿ'),
                onTap: () {
                  Navigator.pop(context); // Close drawer first
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
