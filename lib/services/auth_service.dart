import 'package:expense_tracker_app/services/api_service.dart';

class AuthService {
  /// ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await ApiService.request(
      endpoint: '/auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
    );

    return data;
  }

  /// ================= REGISTER =================
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final data = await ApiService.request(
      endpoint: '/auth/register',
      method: 'POST',
      body: {'email': email, 'password': password, 'fullName': fullName},
    );

    return data;
  }

  /// ================= VERIFY OTP =================
  static Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await ApiService.request(
      endpoint: '/auth/verify-otp',
      method: 'POST',
      body: {'email': email, 'otp': otp},
    );
  }

  /// ================= RESEND OTP =================
  static Future<void> resendOtp(String email) async {
    await ApiService.request(
      endpoint: '/auth/resend-otp',
      method: 'POST',
      body: {'email': email},
    );
  }

  /// ================= FORGOT PASSWORD =================
  static Future<void> forgotPassword(String email) async {
    await ApiService.request(
      endpoint: '/auth/forgot-password',
      method: 'POST',
      body: {'email': email},
    );
  }

  /// ================= RESET PASSWORD =================
  static Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await ApiService.request(
      endpoint: '/auth/reset-password',
      method: 'POST',
      body: {'resetToken': token, 'newPassword': newPassword},
    );
  }

  /// ================= REFRESH TOKEN =================
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final data = await ApiService.request(
      endpoint: '/auth/refresh-token',
      method: 'POST',
      body: {'refreshToken': refreshToken},
    );

    return data;
  }

  /// ================= CHANGE PASSWORD =================
  static Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await ApiService.request(
      endpoint: '/auth/change-password',
      method: 'PUT',

      body: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
  }

  /// ================= PROFILE =================
  static Future<Map<String, dynamic>> getProfile() async {
    final data = await ApiService.request(
      endpoint: '/auth/profile',
      method: 'GET',
    );

    return data;
  }
}
