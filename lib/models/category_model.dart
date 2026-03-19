class CategoryModel {
  final String? id;
  final String name;
  final String type;
  final String? userId;

  /// 🔥 thêm mới
  final String icon;
  final String color;

  CategoryModel({
    this.id,
    required this.name,
    required this.type,
    this.userId,
    required this.icon,
    required this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      userId: json['userId'],

      /// fallback để tránh crash nếu API chưa có
      icon: json['icon'] ?? 'category',
      color: json['color'] ?? '#2196F3',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'userId': userId,
      'icon': icon,
      'color': color,
    };
  }
}
