import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  List<CategoryModel> categories = [];

  bool isLoading = false;
  String? error;

  String selectedType = 'expense';

  List<CategoryModel> get filteredCategories =>
      categories.where((e) => e.type == selectedType).toList();

  void setSelectedType(String type) {
    selectedType = type;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _setLoading(true);

    try {
      final data = await CategoryService.getCategories();

      categories = data
          .map<CategoryModel>((json) => CategoryModel.fromJson(json))
          .toList();

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> addCategory(CategoryModel category) async {
    _setLoading(true);

    try {
      final data = await CategoryService.createCategory(category);

      categories.add(CategoryModel.fromJson(data));

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    _setLoading(true);

    try {
      final data = await CategoryService.updateCategory(category);

      final index = categories.indexWhere((e) => e.id == category.id);
      if (index != -1) {
        categories[index] = CategoryModel.fromJson(data);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      await CategoryService.deleteCategory(id: id);

      categories.removeWhere((e) => e.id == id);
      notifyListeners();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    error = null;
    notifyListeners();
  }

  void _setError(String err) {
    error = err;
    isLoading = false;
    notifyListeners();
  }
}
