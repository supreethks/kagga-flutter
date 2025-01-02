import 'package:flutter/material.dart';

class KannadaSummaryScreen extends StatelessWidget {
  final String title;
  const KannadaSummaryScreen({super.key, required this.title});

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
              Image.asset(
                'assets/images/kagga_rasadhare.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                'ಡಿವಿಜಿಯವರ ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ ಕೃತಿಯ ಮುಕ್ತಕಗಳಿಗೆ ತಿಳಿಗನ್ನಡದ ಅರ್ಥ, ತಾತ್ಪರ್ಯ ಹಾಗೂ ಮುಕ್ತಕಗಳ ವ್ಯಾಖ್ಯಾನವನ್ನು ರವಿ ತಿರುಮಲೈರವರ "ಕಗ್ಗ ರಸಧಾರೆ" ಕೃತಿ ಸರಣಿಯಿಂದ ಅನುಮತಿ ಪಡೆದು ಬಳಸಿಕೊಳ್ಳಲಾಗಿದೆ.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'The simple kannada meaning, summary and commentary on the verses of D.V.G\'s Mankutimmana Kagga have been reproduced with permission from the "Kagga Rasadhaare" series of books published by Ravi Tirumalai.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
