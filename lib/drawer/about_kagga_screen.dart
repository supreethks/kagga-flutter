import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutKaggaScreen extends StatelessWidget {
  final String title;
  const AboutKaggaScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(text: 'ಕನ್ನಡ'),
              Tab(text: 'English'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            WebViewWidget(
              controller: WebViewController()
                ..loadRequest(Uri.parse(
                    'https://kn.wikipedia.org/wiki/%E0%B2%AE%E0%B2%82%E0%B2%95%E0%B3%81%E0%B2%A4%E0%B2%BF%E0%B2%AE%E0%B3%8D%E0%B2%AE%E0%B2%A8_%E0%B2%95%E0%B2%97%E0%B3%8D%E0%B2%97'))
                ..setJavaScriptMode(JavaScriptMode.disabled),
            ),
            WebViewWidget(
              controller: WebViewController()
                ..loadRequest(Uri.parse(
                    'https://en.wikipedia.org/wiki/Mankuthimmana_Kagga'))
                ..setJavaScriptMode(JavaScriptMode.disabled),
            ),
          ],
        ),
      ),
    );
  }
}
