import '../models/user_model.dart';
import 'api_service.dart';

class UserService {
  /// GET PROFILE
  static Future<UserModel> getProfile() async {
    final res = await ApiService.request(endpoint: '/users/me', method: 'GET');

    return UserModel.fromJson(res['data']);
  }

  /// UPDATE PROFILE
  static Future<UserModel> updateProfile(UserModel user) async {
    final res = await ApiService.request(
      endpoint: '/users/me',
      method: 'PUT',
      body: user.toJson(),
    );

    return UserModel.fromJson(res['data']);
  }
}
