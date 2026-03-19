import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tạo tài khoản',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Bắt đầu quản lý tài chính của bạn',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // Họ và tên
              CustomInput(
                controller: nameController,
                label: 'Họ và tên',
                hint: 'Nhập tên của bạn',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 20),

              // EMAIL
              CustomInput(
                controller: emailController,
                label: 'Email',
                hint: 'Nhập email',
                prefixIcon: Icons.mail_outline,
              ),

              const SizedBox(height: 20),

              // MẬT KHẨU
              CustomInput(
                controller: passwordController,
                label: 'Mật khẩu',
                hint: 'Nhập mật khẩu',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 32),

              // NÚT Đăng ký
              CustomButton(
                text: 'Đăng ký',
                isLoading: authVM.isLoading,
                onPressed: () async {
                  final success = await authVM.register(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    nameController.text.trim(),
                  );

                  if (success && context.mounted) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.verifyOtp,
                      arguments: emailController.text.trim(),
                    );
                  }
                },
              ),

              // ERROR
              if (authVM.error != null) ...[
                const SizedBox(height: 12),
                Text(authVM.error!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã có tài khoản? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Color(0xFFFF7B00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
