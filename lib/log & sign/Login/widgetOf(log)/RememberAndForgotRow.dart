import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/provider/login_provider.dart';

class RememberAndForgotRow extends StatelessWidget {
  const RememberAndForgotRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProv, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: loginProv.rememberMe,
                  activeColor: const Color(0xFF007C83), // اللون الأساسي
                  onChanged: (value) => loginProv.setRememberMe(value ?? false),
                ),
                const Text(
                  'Remember Me',
                  style: TextStyle(
                    color: Color(0x8A000000), // Colors.black54
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // TODO: Forgot password action
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0x8A000000), // Colors.black54
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
