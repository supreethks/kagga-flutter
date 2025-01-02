import 'package:flutter/material.dart';
import 'package:kagga/kagga_db_helper.dart';
import 'package:kagga/kagga_pager.dart';
import 'drawer/about_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class KaggaListScreen extends StatelessWidget {
  const KaggaListScreen(
      {super.key, required this.title, required this.kaggaList});

  final String title;
  final List<Map<String, dynamic>> kaggaList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: KaggaListDrawer(),
      body: SafeArea(
        child: buildPageView(),
      ),
    );
  }

  Widget buildPageView() {
    return Scrollbar(
      interactive: true,
      thumbVisibility: false,
      child: ListView.separated(
        padding: EdgeInsets.all(8.0),
        itemCount: kaggaList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
        itemBuilder: (context, index) {
          final kagga = kaggaList[index];
          final kaggaIds = kaggaList
              .map<int>((kagga) => int.parse(kagga['kagga_id'] as String))
              .toList();
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KaggaPager(
                    kaggaIds: kaggaIds,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 0.7,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          kagga['kagga_id'],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        kagga['kagga_kn'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class KaggaListDrawer extends StatelessWidget {
  const KaggaListDrawer({super.key});

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
                title: Text('ಸಂಪರ್ಕಿಸಿ'),
                onTap: () {
                  // Handle the tap
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
                  // Handle the tap
                },
              ),
              ListTile(
                title: Text('ಗೆಳೆಯರಿಗೆ ಪರಿಚಯಿಸಿ'),
                onTap: () {
                  // Handle the tap
                },
              ),
            ],
          ),
          FutureBuilder<PackageInfo>(
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
          ),
        ],
      ),
    );
  }
}
