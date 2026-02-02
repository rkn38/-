class CategoryModel {
  final String id;
  final String name;
  final String? nameEn;
  final String? description;
  final String? iconURL;
  final int booksCount;
  final int? order;

  CategoryModel({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    this.iconURL,
    this.booksCount = 0,
    this.order,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      description: json['description'] as String?,
      iconURL: json['iconURL'] as String?,
      booksCount: json['booksCount'] as int? ?? 0,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameEn': nameEn,
      'description': description,
      'iconURL': iconURL,
      'booksCount': booksCount,
      'order': order,
    };
  }
}
