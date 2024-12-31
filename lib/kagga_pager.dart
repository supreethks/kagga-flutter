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
  _KaggaPagerState createState() => _KaggaPagerState();
}

class _KaggaPagerState extends State<KaggaPager> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('ಕಗ್ಗ ${widget.kaggaIds[currentIndex]}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Handle favorite button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share button press
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.kaggaIds.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
            print("Current index is $currentIndex");
          });
        },
        itemBuilder: (context, index) {
          return KaggaDetailsScreen(kaggaId: widget.kaggaIds[index]);
        },
      ),
    );
  }
}
