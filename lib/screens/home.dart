import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'detail.dart';
import 'favorites.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late Future<List<Country>> countries;
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];
  List<Country> favoriteCountries = [];

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List<dynamic> jsonData = jsonDecode(respBody);
      final List<Country> list =
          jsonData.map((j) => Country.fromJson(j)).toList();

      allCountries = list;
      filteredCountries = list;
      return list;
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  void _searchCountry(String query) {
    setState(() {
      filteredCountries = allCountries
          .where((country) =>
              country.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleFavorite(Country country) {
    setState(() {
      if (favoriteCountries.contains(country)) {
        favoriteCountries.remove(country);
      } else {
        favoriteCountries.add(country);
      }
    });
  }

  bool _isFavorite(Country country) {
    return favoriteCountries.contains(country);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(context),
      FavoritesScreen(favoriteCountries: favoriteCountries),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                  onChanged: _searchCountry,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        isDarkMode ? Colors.black26 : Colors.grey.shade200,
                    hintText: "Search country...",
                    hintStyle: TextStyle(
                        color:
                            isDarkMode ? Colors.white54 : Colors.grey.shade600),
                    prefixIcon: Icon(Icons.search,
                        color: isDarkMode ? Colors.white : Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, i) {
                    final country = filteredCountries[i];
                    final isFav = _isFavorite(country);
                    return Card(
                      color: isDarkMode
                          ? const Color(0xFF1E1E1E)
                          : Colors.grey.shade100,
                      child: ListTile(
                        leading: country.flagsPng != null
                            ? Image.network(country.flagsPng!, width: 50)
                            : const SizedBox(width: 50),
                        title: Text(
                          country.name,
                          style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white : Colors.grey[900]),
                        ),
                        subtitle: Text(
                          country.region,
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[700]),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => _toggleFavorite(country),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(country: country),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<String>? languages;
  final List<String>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<String>? langs;
    if (json['languages'] != null) {
      langs = (json['languages'] as List)
          .map((l) => l['name'].toString())
          .toList();
    }

    List<String>? cur;
    if (json['currencies'] != null) {
      cur = (json['currencies'] as List)
          .map((c) => c['name'].toString())
          .toList();
    }

    return Country(
      name: json['name'] ?? 'N/A',
      region: json['region'] ?? 'N/A',
      population: json['population'] ?? 0,
      capital: json['capital'],
      flagsPng: json['flags'] != null ? json['flags']['png'] : null,
      languages: langs,
      currencies: cur,
    );
  }
}
