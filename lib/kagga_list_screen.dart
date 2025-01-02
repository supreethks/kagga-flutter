import 'package:flutter/material.dart';
import 'package:kagga/kagga_pager.dart';
import 'package:kagga/drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KaggaListScreen extends StatefulWidget {
  const KaggaListScreen({
    super.key,
    required this.title,
    required this.kaggaList,
  });

  final String title;
  final List<Map<String, dynamic>> kaggaList;

  @override
  State<KaggaListScreen> createState() => _KaggaListScreenState();
}

class _KaggaListScreenState extends State<KaggaListScreen> {
  Set<String> favorites = {};
  bool showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList('favorites') ?? [];
      setState(() {
        favorites = favoritesList.toSet();
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  List<Map<String, dynamic>> get filteredKaggaList {
    if (!showOnlyFavorites) return widget.kaggaList;
    return widget.kaggaList
        .where((kagga) => favorites.contains(kagga['kagga_id']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Switch(
              value: showOnlyFavorites,
              onChanged: (value) {
                setState(() {
                  showOnlyFavorites = value;
                });
              },
              activeColor: Colors.orange,
              activeThumbImage:
                  const AssetImage('assets/images/favorite_thumb.png'),
              inactiveThumbColor: Colors.grey,
              inactiveThumbImage:
                  const AssetImage('assets/images/favorite_thumb.png'),
            ),
          ),
        ],
      ),
      drawer: KaggaListDrawer(),
      body: SafeArea(
        child: buildPageView(),
      ),
    );
  }

  Widget buildPageView() {
    final displayList = filteredKaggaList;
    final kaggaIds = displayList
        .map<int>((kagga) => int.parse(kagga['kagga_id'] as String))
        .toList();

    return Scrollbar(
      interactive: true,
      thumbVisibility: false,
      child: displayList.isEmpty
          ? const Center(
              child: Text(
                '❤️\nNo favorites yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: displayList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final kagga = displayList[index];
                final isFavorite = favorites.contains(kagga['kagga_id']);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KaggaPager(
                          kaggaIds: kaggaIds,
                          initialIndex: index,
                        ),
                      ),
                    ).then((_) => _loadFavorites());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.7,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            child: Column(
                              children: [
                                Text(
                                  kagga['kagga_id'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                if (isFavorite)
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              kagga['kagga_kn'],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
