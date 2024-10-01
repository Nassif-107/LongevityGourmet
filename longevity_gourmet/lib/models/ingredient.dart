class Ingredient {
  final int ingredientId;
  final String name;
  final String description;
  final String imageUrl;
  final double quantity;
  final String unit;

  Ingredient({
    required this.ingredientId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredientId: json['ingredient_id'],
      name: json['name'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}
