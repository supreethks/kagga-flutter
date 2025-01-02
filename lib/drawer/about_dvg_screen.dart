import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutDvgScreen extends StatelessWidget {
  final String title;
  const AboutDvgScreen({super.key, required this.title});

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
                    'https://kn.wikipedia.org/wiki/%E0%B2%A1%E0%B2%BF.%E0%B2%B5%E0%B2%BF.%E0%B2%97%E0%B3%81%E0%B2%82%E0%B2%A1%E0%B2%AA%E0%B3%8D%E0%B2%AA'))
                ..setJavaScriptMode(JavaScriptMode.disabled),
            ),
            WebViewWidget(
              controller: WebViewController()
                ..loadRequest(
                    Uri.parse('https://en.wikipedia.org/wiki/D._V._Gundappa'))
                ..setJavaScriptMode(JavaScriptMode.disabled),
            ),
          ],
        ),
      ),
    );
  }
}
