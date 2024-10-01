// lib/screens/favorites/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:longevity_gourmet/models/favorite_set.dart';
import 'package:longevity_gourmet/models/recipe.dart';
import 'package:longevity_gourmet/services/database_service.dart';
import 'package:longevity_gourmet/widgets/recipe_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteSet> _favoriteSets = [];
  int? _selectedSetId;
  List<Recipe> _recipes = [];

  final _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _fetchFavoriteSets();
  }

  void _fetchFavoriteSets() async {
    List<FavoriteSet> favoriteSets =
    await _databaseService.getFavoriteSets();
    setState(() {
      _favoriteSets = favoriteSets;
      if (_favoriteSets.isNotEmpty && _selectedSetId == null) {
        _selectedSetId = _favoriteSets.first.id;
        _fetchFavoriteSetRecipes(_selectedSetId!);
      }
    });
  }

  void _fetchFavoriteSetRecipes(int favoriteSetId) async {
    List<Recipe> recipes =
    await _databaseService.getFavoriteSetRecipes(favoriteSetId);
    setState(() {
      _recipes = recipes;
    });
  }

  void _createFavoriteSet() async {
    String? setName = await _showSetNameDialog('Создать новый набор');
    if (setName != null && setName.isNotEmpty) {
      await _databaseService.createFavoriteSet(setName);
      _fetchFavoriteSets();
    }
  }

  void _editFavoriteSet(FavoriteSet favoriteSet) async {
    String? setName =
    await _showSetNameDialog('Редактировать набор', favoriteSet.name);
    if (setName != null && setName.isNotEmpty) {
      favoriteSet.name = setName;
      await _databaseService.updateFavoriteSet(favoriteSet);
      _fetchFavoriteSets();
    }
  }

  void _deleteFavoriteSet(FavoriteSet favoriteSet) async {
    await _databaseService.deleteFavoriteSet(favoriteSet.id);
    if (favoriteSet.id == _selectedSetId) {
      _selectedSetId = null;
      _recipes = [];
    }
    _fetchFavoriteSets();
  }

  Future<String?> _showSetNameDialog(String title, [String? initialName]) {
    TextEditingController controller =
    TextEditingController(text: initialName);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Название набора'),
          ),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        );
      },
    );
  }

  void _onSetSelected(int setId) {
    setState(() {
      _selectedSetId = setId;
      _fetchFavoriteSetRecipes(setId);
    });
  }

  void _removeRecipeFromSet(int recipeId) async {
    if (_selectedSetId != null) {
      await _databaseService.removeRecipeFromFavoriteSet(
          _selectedSetId!, recipeId);
      _fetchFavoriteSetRecipes(_selectedSetId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои наборы избранного'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createFavoriteSet,
          ),
        ],
      ),
      body: Row(
        children: [
          // Favorite Sets List
          SizedBox(
            width: 200,
            child: ListView(
              children: _favoriteSets.map((favoriteSet) {
                bool isSelected = favoriteSet.id == _selectedSetId;
                return ListTile(
                  selected: isSelected,
                  title: Text(favoriteSet.name),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editFavoriteSet(favoriteSet);
                      } else if (value == 'delete') {
                        _deleteFavoriteSet(favoriteSet);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Редактировать'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Удалить'),
                      ),
                    ],
                  ),
                  onTap: () => _onSetSelected(favoriteSet.id),
                );
              }).toList(),
            ),
          ),
          // Recipes in Selected Set
          Expanded(
            child: _recipes.isEmpty
                ? const Center(child: Text('Нет рецептов в этом наборе'))
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = _recipes[index];
                return Stack(
                  children: [
                    RecipeCard(recipe: recipe),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () =>
                            _removeRecipeFromSet(recipe.recipeId),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
