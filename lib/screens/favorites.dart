import 'package:flutter/material.dart';
import 'home.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Country> favoriteCountries;

  const FavoritesScreen({super.key, required this.favoriteCountries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Countries'),
      ),
      body: favoriteCountries.isEmpty
          ? Center(
              child: Text(
                "Belum ada negara favorit",
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
            )
          : ListView.builder(
              itemCount: favoriteCountries.length,
              itemBuilder: (context, index) {
                final country = favoriteCountries[index];
                return Card(
                  color: theme.cardColor,
                  child: ListTile(
                    leading: country.flagsPng != null
                        ? Image.network(country.flagsPng!, width: 50)
                        : const SizedBox(width: 50),
                    title: Text(country.name),
                    subtitle: Text(country.region),
                    trailing:
                        const Icon(Icons.star, color: Colors.amber, size: 26),
                  ),
                );
              },
            ),
    );
  }
}
