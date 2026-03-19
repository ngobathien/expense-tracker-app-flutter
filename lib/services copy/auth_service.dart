import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1/auth';

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) return data;
    throw Exception(data['message']);
  }

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'fullName': fullName,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 201) return data;
    throw Exception(data['message']);
  }

  // ================= VERIFY OTP =================
  static Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message']);
    }
  }

  // ================= RESEND OTP =================
  static Future<void> resendOtp(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message']);
    }
  }

  // ================= FORGOT PASSWORD =================
  static Future<void> forgotPassword(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message']);
    }
  }

  // ================= RESET PASSWORD =================
  static Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'resetToken': token, 'newPassword': newPassword}),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message']);
    }
  }

  // ================= REFRESH TOKEN =================
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final res = await http.post(
      Uri.parse('$baseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) return data;
    throw Exception(data['message']);
  }

  // ================= CHANGE PASSWORD =================
  static Future<void> changePassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message']);
    }
  }

  // ================= PROFILE =================
  static Future<Map<String, dynamic>> getProfile(String accessToken) async {
    final res = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) return data;
    throw Exception(data['message']);
  }
}
