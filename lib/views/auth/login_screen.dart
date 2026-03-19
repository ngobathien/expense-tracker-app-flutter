import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../router/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // LOGO
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFFFF7B00),
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Đăng nhập',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Chào mừng bạn trở lại',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // EMAIL
              CustomInput(
                controller: emailController,
                label: 'Email',
                hint: 'Nhập email của bạn',
                prefixIcon: Icons.mail_outline,
              ),

              const SizedBox(height: 20),

              // PASSWORD
              CustomInput(
                controller: passwordController,
                label: 'Mật khẩu',
                hint: 'Nhập mật khẩu',
                prefixIcon: Icons.lock_outline,
                suffixIcon: Icons.visibility_outlined,
                obscureText: true,
              ),

              const SizedBox(height: 32),

              // LOGIN BUTTON
              CustomButton(
                text: 'Đăng nhập',
                isLoading: authVM.isLoading,
                onPressed: () async {
                  // gọi action login 
                  final success = await authVM.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  if (success && context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                    );
                  }
                },
              ),

              // ERROR
              if (authVM.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  authVM.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 16),

              // FORGOT PASSWORD
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // REGISTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: const Text(
                      'Đăng ký ngay',
                      style: TextStyle(
                        color: Color(0xFFFF7B00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text('hoặc', style: TextStyle(color: Colors.grey)),
              ),

              const SizedBox(height: 24),

              // GOOGLE BUTTON
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.g_mobiledata,
                  size: 32,
                  color: Colors.red,
                ),
                label: const Text(
                  'Tiếp tục với Google',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
