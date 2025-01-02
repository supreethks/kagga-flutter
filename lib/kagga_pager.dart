import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isFavorite = false;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    try {
      prefs = await SharedPreferences.getInstance();
      _loadFavoriteStatus();
    } catch (e) {
      debugPrint('Error initializing SharedPreferences: $e');
      // Handle the error gracefully - favorites will be temporarily unavailable
    }
  }

  void _loadFavoriteStatus() {
    if (prefs == null) return;

    try {
      final favorites = prefs!.getStringList('favorites') ?? [];
      setState(() {
        isFavorite =
            favorites.contains(widget.kaggaIds[currentIndex].toString());
      });
    } catch (e) {
      debugPrint('Error loading favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (prefs == null) return;

    try {
      final favorites = prefs!.getStringList('favorites') ?? [];
      final currentKaggaId = widget.kaggaIds[currentIndex].toString();

      setState(() {
        if (favorites.contains(currentKaggaId)) {
          favorites.remove(currentKaggaId);
          isFavorite = false;
        } else {
          favorites.add(currentKaggaId);
          isFavorite = true;
        }
      });

      await prefs!.setStringList('favorites', favorites);
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteButton = IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.orange : null,
      ),
      onPressed: _toggleFavorite,
    );

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
              trailing: favoriteButton,
            ),
            child: SafeArea(
              child: buildPageView(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('ಕಗ್ಗ ${widget.kaggaIds[currentIndex]}'),
              actions: [favoriteButton],
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
        _loadFavoriteStatus();
      },
      itemBuilder: (context, index) {
        return KaggaDetailsScreen(kaggaId: widget.kaggaIds[index]);
      },
    );
  }
}
