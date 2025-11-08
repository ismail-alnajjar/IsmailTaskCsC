import 'package:flutter/material.dart';

class SignUpRow extends StatelessWidget {
  const SignUpRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Color(0x8A000000), // Colors.black54
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/SignUp');
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF007C83), // اللون الأساسي
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
