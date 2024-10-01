class Allergen {
  final int id;
  final String name;
  final String description;

  Allergen({required this.id, required this.name, required this.description});

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      id: json['allergen_id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
