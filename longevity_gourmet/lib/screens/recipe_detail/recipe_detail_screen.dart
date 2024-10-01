// lib/screens/recipe_detail/recipe_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:longevity_gourmet/models/recipe_detail.dart';
import 'package:longevity_gourmet/services/database_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<RecipeDetail> _recipeDetailFuture;

  @override
  void initState() {
    super.initState();
    _recipeDetailFuture =
        DatabaseService().getRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепт'),
      ),
      body: FutureBuilder<RecipeDetail>(
        future: _recipeDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            RecipeDetail recipe = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    recipe.imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      recipe.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      recipe.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Ингредиенты',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = recipe.ingredients[index];
                      return ListTile(
                        title: Text(
                            '${ingredient.name} - ${ingredient.quantity} ${ingredient.unit}'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Шаги приготовления',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.steps.length,
                    itemBuilder: (context, index) {
                      final step = recipe.steps[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${step.stepNumber}'),
                        ),
                        title: Text(step.instructionText),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки рецепта'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
