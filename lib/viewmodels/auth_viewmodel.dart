import 'package:expense_tracker_app/models/user_model.dart';
import 'package:expense_tracker_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  String? accessToken;
  String? refreshToken;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => accessToken != null;

  // ================= AUTO LOGIN =================
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    accessToken = prefs.getString('accessToken');
    refreshToken = prefs.getString('refreshToken');

    if (accessToken != null) {
      ApiService.setToken(accessToken!);

      try {
        // 🔥 GỌI API PROFILE
        final profile = await AuthService.getProfile();

        print("PROFILE RESPONSE: $profile"); // 👈 LOG 1

        _currentUser = UserModel.fromJson(profile);

        print("USER ID SAU AUTO LOGIN: ${_currentUser?.id}"); // 👈 LOG 2
      } catch (e) {
        print("LỖI LOAD PROFILE: $e"); // 👈 LOG 3
      }
    }

    notifyListeners();
  }

  // ================= LOGIN =================
  Future<bool> login(String email, String password) async {
    _setLoading(true);

    try {
      final data = await AuthService.login(email: email, password: password);

      accessToken = data['accessToken'];
      refreshToken = data['refreshToken'];
      _currentUser = UserModel.fromJson(data['user']);

      // ✅ SAVE TOKEN
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken!);
      ApiService.setToken(accessToken!);
      await prefs.setString('refreshToken', refreshToken!);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ================= REGISTER =================
  Future<bool> register(String email, String password, String fullName) async {
    _setLoading(true);

    try {
      await AuthService.register(
        email: email,
        password: password,
        fullName: fullName,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ================= VERIFY OTP =================
  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);

    try {
      await AuthService.verifyOtp(email: email, otp: otp);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ================= RESEND OTP =================
  Future<void> resendOtp(String email) async {
    try {
      await AuthService.resendOtp(email);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ================= FORGOT PASSWORD =================
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);

    try {
      await AuthService.forgotPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ================= RESET PASSWORD =================
  Future<bool> resetPassword(String token, String newPassword) async {
    _setLoading(true);

    try {
      await AuthService.resetPassword(token: token, newPassword: newPassword);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ================= REFRESH TOKEN =================
  Future<void> refreshAccessToken() async {
    if (refreshToken == null) return;

    try {
      final data = await AuthService.refreshToken(refreshToken!);

      accessToken = data['accessToken'];
      // set lại token gắn vào đầu api
      ApiService.setToken(accessToken!);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken!);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ================= CHANGE PASSWORD =================
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (accessToken == null) return false;

    _setLoading(true);

    try {
      await AuthService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ================= PROFILE =================
  Future<Map<String, dynamic>?> getProfile() async {
    if (accessToken == null) return null;

    try {
      return await AuthService.getProfile();
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    accessToken = null;
    refreshToken = null;

    ApiService.clearToken();

    notifyListeners();
  }

  // ================= PRIVATE =================
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
