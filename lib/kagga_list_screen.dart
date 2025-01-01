import 'package:flutter/material.dart';
import 'package:kagga/kagga_pager.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class KaggaListScreen extends StatelessWidget {
  const KaggaListScreen(
      {super.key, required this.title, required this.kaggaList});

  final String title;
  final List<Map<String, dynamic>> kaggaList;
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ'),
      ),
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
