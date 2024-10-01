import 'package:longevity_gourmet/models/recipe_step.dart';
import 'package:longevity_gourmet/models/ingredient.dart';

class RecipeDetail {
  final int recipeId;
  final String title;
  final String description;
  final String imageUrl;
  final List<RecipeStep> steps;
  final List<Ingredient> ingredients;

  RecipeDetail({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.steps,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      recipeId: json['recipe_id'],
      title: json['title'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      steps: (json['steps'] as List<dynamic>)
          .map((step) => RecipeStep.fromJson(step))
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((ing) => Ingredient.fromJson(ing))
          .toList(),
    );
  }
}
