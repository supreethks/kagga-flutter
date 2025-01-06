import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  final String title;
  const ContactScreen({super.key, required this.title});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $urlString: $e');
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final String email = 'karnamsupreeth@gmail.com';
    final String emailUrl = 'mailto:$email';

    try {
      await launchUrl(Uri.parse(emailUrl),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch email client'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'This application is developed and maintained by Supreeth.K.S. He is a mobile application developer, blogger, film enthusiast and a bibliophile.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'You can reach out to him on '),
                    TextSpan(
                      text: 'twitter',
                      style: const TextStyle(
                        color: Colors.orange,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchUrl('https://x.com/uniquesupri'),
                    ),
                    const TextSpan(text: ' or by '),
                    TextSpan(
                      text: 'email',
                      style: const TextStyle(
                        color: Colors.orange,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchEmail(context),
                    ),
                    const TextSpan(
                        text: ' (karnamsupreeth [at] gmail [dot] com).'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
