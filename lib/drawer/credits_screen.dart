import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsScreen extends StatelessWidget {
  final String title;
  const CreditsScreen({super.key, required this.title});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mankutimmana Kagga Section
              InkWell(
                onTap: () => _launchUrl('http://www.gipa-bng.org/php/cus.php'),
                child: Text(
                  'ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ, ಡಿವಿಜಿ | Mankutimmana Kagga by DVG',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'ಕೃತಿ ಸ್ವಾಮ್ಯ: ಗೋಖಲೆ ಸಾರ್ವಜನಿಕ ವಿಚಾರ | Copyright: Gokhale Institute of Public Affairs',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // English Translation Section
              Text(
                'ಇಂಗ್ಲೀಷ್ ಭಾಷಾಂತರ | English Translation',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'ಕೃತಿ ಸ್ವಾಮ್ಯ: ಪ್ರಶಾಂತ್ ಕೋಟ | Copyright: Prashant Kota',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Kannada Summary Section
              InkWell(
                onTap: () =>
                    _launchUrl('https://kaggarasadhaare.wordpress.com'),
                child: Text(
                  'ಕನ್ನಡ ತಾತ್ಪರ್ಯ, ವ್ಯಾಖ್ಯಾನ | Kannada summary, commentary',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'ಕೃತಿ ಸ್ವಾಮ್ಯ: ರವಿ ತಿರುಮಲೈ | Copyright: Ravi Tirumalai',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
