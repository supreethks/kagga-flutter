import 'package:flutter/material.dart';
import 'kagga_db_helper.dart'; // Import your database helper

class KaggaDetailsScreen extends StatefulWidget {
  final String kaggaId;

  const KaggaDetailsScreen({super.key, required this.kaggaId});

  @override
  _KaggaDetailsScreenState createState() => _KaggaDetailsScreenState();
}

class _KaggaDetailsScreenState extends State<KaggaDetailsScreen> {
  late Future<Map<String, String>> kaggaDetails;
  bool isSwitchOn = false;

  final double sectionTitleSize = 14;
  final double contentTextSize = 16;

  @override
  void initState() {
    super.initState();
    kaggaDetails = fetchKaggaDetails(widget.kaggaId).then((value) {
      return value.map((key, value) => MapEntry(key, value.toString()));
    });
  }

  Future<Map<String, Object?>> fetchKaggaDetails(String kaggaId) async {
    // Fetch details from the database using kaggaId
    print("Kagga id is $kaggaId");
    return await getKaggaDetails(kaggaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ಕಗ್ಗ ${widget.kaggaId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Handle favorite button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share button press
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String>>(
        future: kaggaDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No details found.'));
          } else {
            final details = Map<String, String>.from(snapshot.data!);
            details.remove('kagga_tatparya_kn');
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildKaggaText(details),
                          buildTranslationSection(details),
                          buildMeaningSection(details),
                          buildTatparyaSection(details),
                          buildVyakhyanaSwitch(details),
                          buildTransliterationSection(details),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildKaggaText(Map<String, String> details) {
    return Text(
      details['kagga_kn']!,
      style: TextStyle(fontSize: contentTextSize),
    );
  }

  Widget buildTranslationSection(Map<String, String> details) {
    if (details['kagga_eng']?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Translation',
            style: TextStyle(fontSize: sectionTitleSize, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(
            details['kagga_eng']!,
            style: TextStyle(fontSize: contentTextSize),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildMeaningSection(Map<String, String> details) {
    if (details['kagga_meaning_kn']?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'ವಾಚ್ಯಾರ್ಥ',
            style: TextStyle(fontSize: sectionTitleSize, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(
            details['kagga_meaning_kn']!,
            style: TextStyle(fontSize: contentTextSize),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildTatparyaSection(Map<String, String> details) {
    if (details['kagga_tatparya_kn']?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'ಭಾವಾರ್ಥ',
            style: TextStyle(fontSize: sectionTitleSize, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(
            details['kagga_tatparya_kn']!,
            style: TextStyle(fontSize: contentTextSize),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildVyakhyanaSwitch(Map<String, String> details) {
    if (details['kagga_vyakhyana_kn']?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ವ್ಯಾಖ್ಯಾನ ತೋರಿಸು',
                style:
                    TextStyle(fontSize: sectionTitleSize, color: Colors.orange),
              ),
              Switch(
                value: isSwitchOn,
                onChanged: (bool value) {
                  setState(() {
                    isSwitchOn = value;
                  });
                },
                activeColor: Colors.orange,
              ),
            ],
          ),
          if (isSwitchOn) ...[
            const SizedBox(height: 16),
            Text(
              'ವ್ಯಾಖ್ಯಾನ',
              style:
                  TextStyle(fontSize: sectionTitleSize, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Text(
              details['kagga_vyakhyana_kn']!,
              style: TextStyle(fontSize: contentTextSize),
            ),
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildTransliterationSection(Map<String, String> details) {
    if (details['kagga_latn']?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Transliteration',
            style: TextStyle(fontSize: sectionTitleSize, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(
            details['kagga_latn'] ?? '',
            style: TextStyle(fontSize: contentTextSize, color: Colors.grey),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
