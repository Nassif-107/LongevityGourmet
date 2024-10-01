import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:longevity_gourmet/models/recipe.dart';
import 'package:longevity_gourmet/models/allergen.dart';
import 'package:longevity_gourmet/models/favorite_set.dart';
import 'package:longevity_gourmet/models/recipe_detail.dart';

class DatabaseService {
  final String _baseUrl = 'http://192.168.0.15:3000';
  final int _userId = 2; // Replace with the actual user ID

  // Fetch recipes with optional search query and allergen filtering
  Future<List<Recipe>> getRecipes(String query) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/recipes?search=$query&userId=$_userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Fetch detailed recipe information
  Future<RecipeDetail> getRecipeDetail(int recipeId) async {
    final response = await http.get(Uri.parse('$_baseUrl/recipes/$recipeId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return RecipeDetail.fromJson(data);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  // Fetch all allergens
  Future<List<Allergen>> getAllAllergens() async {
    final response = await http.get(Uri.parse('$_baseUrl/allergens'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Allergen.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load allergens');
    }
  }

  // Fetch user's allergens
  Future<List<Allergen>> getUserAllergens() async {
    final response =
    await http.get(Uri.parse('$_baseUrl/user/$_userId/allergens'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Allergen.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user allergens');
    }
  }

  // Add an allergen to user's list
  Future<void> addUserAllergen(Allergen allergen) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/$_userId/allergens'),
      body: json.encode({'allergen_id': allergen.id}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add allergen');
    }
  }

  // Remove an allergen from user's list
  Future<void> removeUserAllergen(Allergen allergen) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/user/$_userId/allergens/${allergen.id}'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove allergen');
    }
  }

  // Fetch user's favorite sets
  Future<List<FavoriteSet>> getFavoriteSets() async {
    final response =
    await http.get(Uri.parse('$_baseUrl/user/$_userId/favoritesets'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FavoriteSet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorite sets');
    }
  }

  // Create a new favorite set
  Future<void> createFavoriteSet(String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/$_userId/favoritesets'),
      body: json.encode({'name': name}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create favorite set');
    }
  }

  // Update an existing favorite set
  Future<void> updateFavoriteSet(FavoriteSet favoriteSet) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/user/$_userId/favoritesets/${favoriteSet.id}'),
      body: json.encode({'name': favoriteSet.name}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update favorite set');
    }
  }

  // Delete a favorite set
  Future<void> deleteFavoriteSet(int favoriteSetId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/user/$_userId/favoritesets/$favoriteSetId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete favorite set');
    }
  }

  // Fetch recipes in a favorite set
  Future<List<Recipe>> getFavoriteSetRecipes(int favoriteSetId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/user/$_userId/favoritesets/$favoriteSetId/recipes'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorite set recipes');
    }
  }

  // Add a recipe to a favorite set
  Future<void> addRecipeToFavoriteSet(int favoriteSetId, int recipeId) async {
    final response = await http.post(
      Uri.parse(
          '$_baseUrl/user/$_userId/favoritesets/$favoriteSetId/recipes'),
      body: json.encode({'recipe_id': recipeId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add recipe to favorite set');
    }
  }

  // Remove a recipe from a favorite set
  Future<void> removeRecipeFromFavoriteSet(
      int favoriteSetId, int recipeId) async {
    final response = await http.delete(
      Uri.parse(
          '$_baseUrl/user/$_userId/favoritesets/$favoriteSetId/recipes/$recipeId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove recipe from favorite set');
    }
  }

// Additional methods can be added here...
}
