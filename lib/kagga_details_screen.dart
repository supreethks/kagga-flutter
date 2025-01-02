import 'package:flutter/material.dart';
import 'db/kagga_db_helper.dart'; // Import your database helper
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class KaggaDetailsScreen extends StatefulWidget {
  final int kaggaId;

  const KaggaDetailsScreen({super.key, required this.kaggaId});

  @override
  KaggaDetailsScreenState createState() => KaggaDetailsScreenState();
}

class KaggaDetailsScreenState extends State<KaggaDetailsScreen> {
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
    return await getKaggaDetails(kaggaId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.titleSmall?.copyWith(
      fontSize: sectionTitleSize,
      color: Colors.orange,
    );
    final bodyStyle = textTheme.bodyLarge?.copyWith(
      fontSize: contentTextSize,
    );
    final transliterationStyle = textTheme.bodyLarge?.copyWith(
      fontSize: contentTextSize,
      color: Colors.grey,
    );

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
                        buildKaggaText(details, bodyStyle),
                        buildTranslationSection(details, titleStyle, bodyStyle),
                        buildMeaningSection(details, titleStyle, bodyStyle),
                        buildTatparyaSection(details, titleStyle, bodyStyle),
                        buildVyakhyanaSwitch(details, titleStyle, bodyStyle),
                        buildTransliterationSection(
                            details, titleStyle, transliterationStyle),
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

  Widget buildKaggaText(Map<String, String> details, TextStyle? style) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(details['kagga_kn']!, style: style),
      ],
    );
  }

  Widget buildTranslationSection(Map<String, String> details,
      TextStyle? titleStyle, TextStyle? bodyStyle) {
    if (details['kagga_eng'] != null &&
        details['kagga_eng'] != 'null' &&
        details['kagga_eng']!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Translation', style: titleStyle),
          const SizedBox(height: 8),
          Text(details['kagga_eng']!, style: bodyStyle),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildMeaningSection(Map<String, String> details, TextStyle? titleStyle,
      TextStyle? bodyStyle) {
    if (details['kagga_meaning_kn'] != null &&
        details['kagga_meaning_kn'] != 'null' &&
        details['kagga_meaning_kn']!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('ವಾಚ್ಯಾರ್ಥ', style: titleStyle),
          const SizedBox(height: 8),
          Text(details['kagga_meaning_kn']!, style: bodyStyle),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildTatparyaSection(Map<String, String> details,
      TextStyle? titleStyle, TextStyle? bodyStyle) {
    if (details['kagga_tatparya_kn'] != null &&
        details['kagga_tatparya_kn'] != 'null' &&
        details['kagga_tatparya_kn']!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('ಭಾವಾರ್ಥ', style: titleStyle),
          const SizedBox(height: 8),
          Text(details['kagga_tatparya_kn']!, style: bodyStyle),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildVyakhyanaSwitch(Map<String, String> details,
      TextStyle? titleStyle, TextStyle? bodyStyle) {
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
              Text('ವ್ಯಾಖ್ಯಾನ ತೋರಿಸು', style: titleStyle),
              const SizedBox(width: 8),
              PlatformSwitch(
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
            Text('ವ್ಯಾಖ್ಯಾನ', style: titleStyle),
            const SizedBox(height: 8),
            Text(details['kagga_vyakhyana_kn']!, style: bodyStyle),
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildTransliterationSection(Map<String, String> details,
      TextStyle? titleStyle, TextStyle? transliterationStyle) {
    if (details['kagga_latn'] != null &&
        details['kagga_latn'] != 'null' &&
        details['kagga_latn']!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Transliteration', style: titleStyle),
          const SizedBox(height: 8),
          Text(details['kagga_latn']!, style: transliterationStyle),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
