import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/favorites.dart';
import '../screens/profile.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  // --- STATE HAS BEEN LIFTED UP TO HERE ---
  final List<Country> _favoriteCountries = [];

  void _toggleFavorite(Country country) {
    setState(() {
      if (_favoriteCountries.contains(country)) {
        _favoriteCountries.remove(country);
      } else {
        _favoriteCountries.add(country);
      }
    });
  }

  bool _isFavorite(Country country) {
    return _favoriteCountries.contains(country);
  }
  // -----------------------------------------

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We now build the pages list here, passing the state down
    final List<Widget> pages = [
      HomePage(
        favoriteCountries: _favoriteCountries, // Pass the list
        onToggleFavorite: _toggleFavorite,     // Pass the function
        isFavorite: _isFavorite,               // Pass the function
      ),
      FavoritesScreen(favoriteCountries: _favoriteCountries), // Pass the SAME list
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}