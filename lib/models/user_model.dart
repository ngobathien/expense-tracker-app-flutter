class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? avatar;
  final String provider;
  final String role;
  final String status;
  final bool isVerified;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.avatar,
    required this.provider,
    required this.role,
    required this.status,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
      provider: json['provider'],
      role: json['role'],
      status: json['status'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'provider': provider,
      'role': role,
      'status': status,
      'isVerified': isVerified,
    };
  }
}
