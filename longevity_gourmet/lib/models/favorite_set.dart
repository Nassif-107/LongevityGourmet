class FavoriteSet {
  final int id;
  String name;

  FavoriteSet({required this.id, required this.name});

  factory FavoriteSet.fromJson(Map<String, dynamic> json) {
    return FavoriteSet(
      id: json['set_id'],
      name: json['name'],
    );
  }
}
