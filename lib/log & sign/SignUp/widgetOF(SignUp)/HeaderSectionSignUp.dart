import 'package:flutter/material.dart';

class HeaderSectionSignUp extends StatelessWidget {
  const HeaderSectionSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF087D8A), Color(0xFF087D8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                height: 1,
                fontWeight: FontWeight.w700,
                fontSize: 42,
                color: Colors.white, // مهم لأنه راح يتلوّن بالـ gradient
              ),
            ),
          ),
          const SizedBox(height: 8),
          const AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: 1,
            child: Text(
              'Enter your details to Sign up',
              style: TextStyle(
                fontSize: 16,
                color: Color(0x8A000000), // نفس الأسود الفاتح
              ),
            ),
          ),
        ],
      ),
    );
  }
}
