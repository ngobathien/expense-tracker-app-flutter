class CategoryStatsModel {
  final String categoryId;
  final String categoryName;
  final double total;

  CategoryStatsModel({
    required this.categoryId,
    required this.categoryName,
    required this.total,
  });

  factory CategoryStatsModel.fromJson(Map<String, dynamic> json) {
    return CategoryStatsModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
