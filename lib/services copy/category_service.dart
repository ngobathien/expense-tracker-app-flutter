import 'dart:convert';

import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1/categories';

  // ================= GET ALL =================
  static Future<List<dynamic>> getCategories({
    required String accessToken,
    String? type,
  }) async {
    final uri = Uri.parse(type != null ? '$baseUrl?type=$type' : baseUrl);

    final res = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) return data;
    throw Exception(data['message']);
  }

  // ================= CREATE =================
  static Future<Map<String, dynamic>> createCategory({
    required String accessToken,
    required String name,
    required String type,
  }) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'name': name, 'type': type}),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 201) return data;
    throw Exception(data['message']);
  }

  // ================= UPDATE =================
  static Future<Map<String, dynamic>> updateCategory({
    required String accessToken,
    required String id,
    required String name,
    required String type,
  }) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'name': name, 'type': type}),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) return data;
    throw Exception(data['message']);
  }

  // ================= DELETE =================
  static Future<void> deleteCategory({
    required String accessToken,
    required String id,
  }) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message']);
    }
  }
}
