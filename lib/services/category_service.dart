import 'package:expense_tracker_app/models/category_model.dart';
import 'package:expense_tracker_app/services/api_service.dart';

class CategoryService {
  static Future<List<dynamic>> getCategories() async {
    final data = await ApiService.request(
      endpoint: '/categories',
      method: 'GET',
    );
    return data;
  }

  /// ✅ CREATE dùng model
  static Future<Map<String, dynamic>> createCategory(
    CategoryModel category,
  ) async {
    final data = await ApiService.request(
      endpoint: '/categories',
      method: 'POST',
      body: category.toJson(), // 🔥 QUAN TRỌNG
    );

    return data;
  }

  /// ✅ UPDATE dùng model
  static Future<Map<String, dynamic>> updateCategory(
    CategoryModel category,
  ) async {
    final data = await ApiService.request(
      endpoint: '/categories/${category.id}',
      method: 'PATCH',
      body: category.toJson(), // 🔥 QUAN TRỌNG
    );

    return data;
  }

  static Future<void> deleteCategory({required String id}) async {
    await ApiService.request(endpoint: '/categories/$id', method: 'DELETE');
  }
}
