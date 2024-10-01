// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:longevity_gourmet/widgets/recipe_card.dart';
import 'package:longevity_gourmet/models/recipe.dart';
import 'package:longevity_gourmet/services/database_service.dart';
import 'package:longevity_gourmet/screens/favorites/favorites_screen.dart';
import 'package:longevity_gourmet/screens/settings/settings_screen.dart';
import 'package:longevity_gourmet/screens/allergens/allergens_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreenContent(),
    const FavoritesScreen(),
    const AllergensScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Longevity Gourmet'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Аллергены',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  List<Recipe> _recipes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  void _fetchRecipes() async {
    List<Recipe> recipes = await DatabaseService().getRecipes(_searchQuery);
    setState(() {
      _recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              _searchQuery = value;
              _fetchRecipes();
            },
            decoration: InputDecoration(
              hintText: 'Поиск рецептов',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _recipes.isEmpty
                ? const Center(child: Text('Нет рецептов'))
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipe: _recipes[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
