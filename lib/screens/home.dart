import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  final List<Country> favoriteCountries;
  final Function(Country) onToggleFavorite;
  final bool Function(Country) isFavorite;

  const HomePage({
    super.key,
    required this.favoriteCountries,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];
  String? _selectedRegion; 
  final TextEditingController _searchController = TextEditingController();

 
  final List<String> _regions = ['All', 'Africa', 'Americas', 'Asia', 'Europe', 'Oceania'];

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCountries);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List<dynamic> jsonData = jsonDecode(respBody);
      final List<Country> list = jsonData
          .map((j) => Country.fromJson(j))
          .toList();

      if (mounted) {
        setState(() {
          allCountries = list;
          filteredCountries = list;
        });
      }
      return list;
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  void _filterCountries() {
    setState(() {
      filteredCountries = allCountries.where((country) {
        final matchesRegion = _selectedRegion == null || _selectedRegion == 'All' || country.region == _selectedRegion;
        final matchesSearch = country.name.toLowerCase().contains(_searchController.text.toLowerCase());
        return matchesRegion && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDarkMode ? Colors.black26 : Colors.grey.shade200,
                      hintText: "Search country...",
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white54 : Colors.grey.shade600,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkMode ? Colors.white : Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black26 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedRegion ?? 'All',
                    underline: const SizedBox(),
                    items: _regions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRegion = newValue;
                      });
                      _filterCountries();
                    },
                    hint: const Text('Sort by region'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: countries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    allCountries.isEmpty) {
                  return _buildSkeletonLoader(isDarkMode);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, i) {
                      final country = filteredCountries[i];
                      final isFav = widget.isFavorite(country);
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
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.grey[900],
                            ),
                          ),
                          subtitle: Text(
                            country.region,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[700],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () => widget.onToggleFavorite(country),
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader(bool isDarkMode) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
          child: ListTile(
            leading: Container(
              width: 50,
              height: 30,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            ),
            title: Container(
              height: 16,
              width: 150,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            ),
            subtitle: Container(
              height: 12,
              width: 100,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            ),
          ),
        );
      },
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}