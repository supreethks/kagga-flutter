import 'package:flutter/material.dart';
import 'package:kagga/kagga_pager.dart';
import 'package:kagga/drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kagga/db/kagga_db_helper.dart';

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
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];

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
    if (_searchQuery.isNotEmpty) return _searchResults;
    if (!showOnlyFavorites) return widget.kaggaList;
    return widget.kaggaList
        .where((kagga) => favorites.contains(kagga['kagga_id']))
        .toList();
  }

  Future<void> _handleSearch(String value) async {
    final trimmedQuery = value.trim();
    if (trimmedQuery.length >= 3) {
      // Clear previous results
      setState(() {
        _searchQuery = trimmedQuery;
        _searchResults = [];
      });

      // Listen to progressive results
      await for (final results in searchKaggaProgressive(
        trimmedQuery,
        favorites: showOnlyFavorites ? favorites : null,
      )) {
        setState(() {
          _searchResults = results;
        });
      }
    } else if (trimmedQuery.isEmpty) {
      setState(() {
        _searchQuery = '';
        _searchResults = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Colors.orange,
                    selectionColor: Colors.orange,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search eg: baduku',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: _handleSearch,
                ),
              )
            : Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                  _searchResults = [];
                }
              });
            },
          ),
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: displayList.isEmpty
            ? Center(
                key: const ValueKey('empty'),
                child: Text(
                  _searchQuery.isNotEmpty
                      ? '🔍\nNo results found'
                      : '❤️\nNo favorites yet',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                key: ValueKey(displayList.length),
                padding: const EdgeInsets.all(8.0),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final kagga = displayList[index];
                  final isFavorite = favorites.contains(kagga['kagga_id']);

                  return AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KaggaPager(
                                  kaggaIds: kaggaIds,
                                  initialIndex: index,
                                ),
                              ),
                            ).then((_) {
                              _loadFavorites();
                              if (_searchQuery.isNotEmpty) {
                                _handleSearch(_searchQuery);
                              }
                            });
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
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
