import 'package:flutter/material.dart';
import 'about_kagga_screen.dart';
import 'about_dvg_screen.dart';
import 'translators_note_screen.dart';
import 'kannada_summary_screen.dart';
import 'credits_screen.dart';

class AboutScreen extends StatelessWidget {
  final String title;
  const AboutScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '"Mankutimanna Kagga" is a collection of verses written in Kannada by renowned poet D.V. Gundappa. This application is a humble effort to make available all of these verses with meaning of the verses in English. The translations of the meaning are done by Prashanth Kota. Application developed and maintained by Supreeth K S. Explore the following sections for more details.',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutKaggaScreen(title: 'ABOUT KAGGA'),
                    ),
                  );
                },
                child: Text('ABOUT KAGGA'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutDvgScreen(title: 'ABOUT D.V.GUNDAPPA'),
                    ),
                  );
                },
                child: Text('ABOUT D.V.GUNDAPPA'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TranslatorsNoteScreen(title: "TRANSLATOR'S NOTE"),
                    ),
                  );
                },
                child: Text("TRANSLATOR'S NOTE"),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          KannadaSummaryScreen(title: 'KANNADA SUMMARY'),
                    ),
                  );
                },
                child: Text('KANNADA SUMMARY'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreditsScreen(title: 'CREDITS'),
                    ),
                  );
                },
                child: Text('CREDITS'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
