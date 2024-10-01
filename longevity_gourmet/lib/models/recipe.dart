class Recipe {
  final int recipeId;
  final String title;
  final String description;
  final String imageUrl;

  Recipe({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['recipe_id'],
      title: json['title'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
    );
  }
}
