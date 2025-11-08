import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF087D8A), Color(0xFF087D8A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'Login',
            style: TextStyle(
              fontFamily: 'ClashDisplay',
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
            'Enter your details to log in',
            style: TextStyle(
              fontSize: 16,
              color: Color(0x8A000000), // نفس الأسود الفاتح
            ),
          ),
        ),
      ],
    );
  }
}
