import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'kagga_details_screen.dart';

class KaggaPager extends StatefulWidget {
  final List<int> kaggaIds;
  final int initialIndex;

  const KaggaPager({
    super.key,
    required this.kaggaIds,
    this.initialIndex = 0,
  });

  @override
  KaggaPagerState createState() => KaggaPagerState();
}

class KaggaPagerState extends State<KaggaPager> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('ಕಗ್ಗ ${widget.kaggaIds[currentIndex]}'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            child: SafeArea(
              child: buildPageView(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('ಕಗ್ಗ ${widget.kaggaIds[currentIndex]}'),
            ),
            body: buildPageView(),
          );
  }

  Widget buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.kaggaIds.length,
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return KaggaDetailsScreen(kaggaId: widget.kaggaIds[index]);
      },
    );
  }
}
