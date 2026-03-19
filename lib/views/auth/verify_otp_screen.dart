import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/custom_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  String get otp => controllers.map((c) => c.text).join(); // ghép 4 số

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    // 👉 lấy email từ register
    final email = ModalRoute.of(context)?.settings.arguments as String?;

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
              'Xác thực OTP',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Mã đã gửi đến: ${email ?? ""}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _otpBox(index)),
            ),

            const SizedBox(height: 40),

            CustomButton(
              text: 'Xác nhận',
              isLoading: authVM.isLoading,
              onPressed: () async {
                if (email == null) return;

                final success = await authVM.verifyOtp(email, otp);

                if (success && context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
            ),

            if (authVM.error != null) ...[
              const SizedBox(height: 12),
              Text(authVM.error!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 24),

            Center(
              child: TextButton(
                onPressed: () {
                  if (email != null) {
                    authVM.resendOtp(email);
                  }
                },
                child: const Text(
                  'Gửi lại mã',
                  style: TextStyle(color: Color(0xFFFF7B00)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
