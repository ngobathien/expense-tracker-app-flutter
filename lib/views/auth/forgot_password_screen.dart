import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quên mật khẩu?',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Nhập email để nhận OTP',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            CustomInput(
              controller: emailController,
              label: 'Email',
              hint: 'Nhập email của bạn',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: 'Gửi mã OTP',
              isLoading: authVM.isLoading,
              onPressed: () async {
                final email = emailController.text.trim();

                final success = await authVM.forgotPassword(email);

                if (success && context.mounted) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.verifyOtp,
                    arguments: email, // 🔥 truyền email
                  );
                }
              },
            ),

            if (authVM.error != null) ...[
              const SizedBox(height: 12),
              Text(authVM.error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
