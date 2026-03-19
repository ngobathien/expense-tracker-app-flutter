import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;

  /// GET PROFILE
  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      notifyListeners();

      user = await UserService.getProfile();
    } catch (e) {
      debugPrint('Error fetch profile: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// UPDATE PROFILE
  Future<bool> updateProfile(UserModel model) async {
    try {
      isLoading = true;
      notifyListeners();

      user = await UserService.updateProfile(model);

      return true;
    } catch (e) {
      debugPrint('Error update profile: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
