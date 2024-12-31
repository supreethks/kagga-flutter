import 'package:flutter/material.dart';
import 'kagga_db_helper.dart'; // Import your database helper

class KaggaDetailsScreen extends StatefulWidget {
  final int kaggaId;

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

  Future<Map<String, Object?>> fetchKaggaDetails(int kaggaId) async {
    // Fetch details from the database using kaggaId
    print("Kagga id is $kaggaId");
    return await getKaggaDetails(kaggaId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }

  Widget buildKaggaText(Map<String, String> details) {
    return Text(
      details['kagga_kn']!,
      style: TextStyle(fontSize: contentTextSize),
    );
  }

  Widget buildTranslationSection(Map<String, String> details) {
    if (details['kagga_eng'] != null &&
        details['kagga_eng'] != 'null' &&
        details['kagga_eng']!.isNotEmpty) {
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
    if (details['kagga_meaning_kn'] != null &&
        details['kagga_meaning_kn'] != 'null' &&
        details['kagga_meaning_kn']!.isNotEmpty) {
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
    if (details['kagga_tatparya_kn'] != null &&
        details['kagga_tatparya_kn'] != 'null' &&
        details['kagga_tatparya_kn']!.isNotEmpty) {
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
    if (details['kagga_vyakhyana_kn'] != null &&
        details['kagga_vyakhyana_kn'] != 'null' &&
        details['kagga_vyakhyana_kn']!.isNotEmpty) {
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
                    TextStyle(fontSize: contentTextSize, color: Colors.orange),
              ),
              const SizedBox(width: 8),
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
    if (details['kagga_latn'] != null &&
        details['kagga_latn'] != 'null' &&
        details['kagga_latn']!.isNotEmpty) {
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
            details['kagga_latn']!,
            style: TextStyle(fontSize: contentTextSize, color: Colors.grey),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
