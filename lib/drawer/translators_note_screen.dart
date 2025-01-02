import 'package:flutter/material.dart';

class TranslatorsNoteScreen extends StatelessWidget {
  final String title;
  const TranslatorsNoteScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'ಕನ್ನಡ'),
                Tab(text: 'ENGLISH'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Kannada content
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      """
ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ ಡಿ.ವಿ.ಗುಂಡಪ್ಪನವರ ಅದ್ವಿತೀಯ ಕೃತಿ. ಕನ್ನಡ ನಾಡಿನಲ್ಲಿ ಮನೆಮಾತಾಗಿರುವ ಕಗ್ಗ ಹಾಗೂ ಡಿವಿಜಿ ಕುರಿತು ಹೆಚ್ಚೇನು ಹೇಳುವ ಅಗತ್ಯವಿಲ್ಲ. ಹೀಗಾಗಿ ನೇರವಾಗಿ ನಾವು ಈ ಯೋಜನೆ ಕೈಗೆತ್ತಿಕೊಳ್ಳುವುದರ ಹಿಂದಿನ ನಮ್ಮ ಉದ್ದೇಶವನ್ನು ತಿಳಿಸಿಬಿಡುತ್ತೇವೆ.

ಕಗ್ಗದ ಯಾವುದೋ ಒಂದು ಸಾಲು ತಲೆಯಲ್ಲಿ ಹೊಕ್ಕಿರುತ್ತದೆ ಇಲ್ಲ ಯಾವುದೋ ಸಂದರ್ಭಕ್ಕೆ ತಕ್ಕನಾದ ಕಗ್ಗ ಅರೆಬರೆ ನೆನಪಿನಲ್ಲಿ ಸುಳಿಯುತ್ತದೆ. ಆಗ ಇಡೀ ಕಗ್ಗವನ್ನು ಹುಡುಕಿ ತೆಗೆದು ಓದಬೇಕು ಎಂಬ ಮನಸ್ಸಾಗುತ್ತದೆ. ಸದಾಕಾಲ ನಮ್ಮ ಕಿಸೆಯಲ್ಲೇ ಇರುವ ಮೊಬೈಲನ್ನು ತೆಗೆದು ಕ್ಷಣಮಾತ್ರದಲ್ಲಿ ಕಗ್ಗವನ್ನು ಹುಡುಕುವಂತಾದರೆ ಎಷ್ಟು ಚೆನ್ನ ಎಂಬ ಆಲೋಚನೆಯ ಹಿನ್ನೆಲೆಯಲ್ಲಿ ಈ ಯೋಜನೆ ಮೈತಳೆದಿದೆ.

ಈ ಯೋಜನೆಯ ಮೂಲಕ ನಾವು ಪ್ರತಿಯೊಂದು ಕಗ್ಗವನ್ನು ಓದಿ, ಅರ್ಥೈಸಿ, ಧ್ಯಾನಿಸುವ ಅವಕಾಶವೊಂದನ್ನು ಪಡೆದೆವು. ಈ ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿ ಮುದ್ರಣ ಮಾಧ್ಯಮದಲ್ಲಿದ್ದ ಕೃತಿಯನ್ನು ಯುನಿಕೋಡ್, ಟ್ರಾನ್ಸ್ ಲಿಟರೇಶನ್ ಹಾಗೂ ಇಂಗ್ಲೀಷ್ ಅವತರಣಿಕೆಯಲ್ಲಿ ನಿಮ್ಮ ಮುಂದಿಡುವ ಪ್ರಯತ್ನ ಮಾಡಿದ್ದೇವೆ.

ನಮ್ಮ ಯೋಜನೆಗೆ ಮೂಲವಾಗಿ ನಾವು ಡಿ. ಆರ್. ವೆಂಕಟರಾಮನ್ ರ "ಕಗ್ಗಕ್ಕೊಂದು ಕೈಪಿಡಿ" ಕೃತಿಯನ್ನು ಬಳಸುತ್ತಿದ್ದೇವೆ. ಅಗತ್ಯ ಬಿದ್ದಾಗ ಮೊನಿಯರ್ ವಿಲಿಯಂರ ಸಂಸ್ಕೃತ ನಿಘಂಟು ಹಾಗೂ ಕನ್ನಡ ಕಸ್ತೂರಿ ನಿಘಂಟುಗಳನ್ನು ಬಳಸಿದ್ದೇವೆ.

- ಪ್ರಶಾಂತ್ ಕೋಟ
""",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  // English content
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      """
Mankutimmana Kagga is an extraordinary work by DVG. The book and the author are beyond praise and accolades. So, we will directly jump into why we are taking this project up.

We have often felt that it would be very nice to recollect a verse when one thinks about it. Usually, we only remember the punch line or start line and become restless to know the entire verse. The thought of having a convenient access to all the verses of Kagga in the smartphones we have in our pockets motivated us to embark on this project.

We have taken up the opportunity to read, understand, contemplate on the verses one at a time. In the process, we will reproduce it in Unicode, transliteration and English translation (as we understand it).

We are using D.R. Venkataraman’s “Kaggakkondu Kaipidi” as a reference. Monier Williams Sanskrit dictionary and Kannada Kasturi dictionary are being used as and when need arises.

- Prashanth Kota
""",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
