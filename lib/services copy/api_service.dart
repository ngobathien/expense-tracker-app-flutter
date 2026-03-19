import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000/api/v1";

  static Future<dynamic> request({
    required String endpoint,
    required String method,
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;

      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;

      case 'PUT':
        response = await http.put(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;

      case 'PATCH':
        response = await http.patch(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;

      case 'DELETE':
        response = await http.delete(uri, headers: headers);
        break;

      default:
        throw Exception('Method không hợp lệ');
    }

    final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data?['message'] ?? 'API Error');
    }
  }
}
